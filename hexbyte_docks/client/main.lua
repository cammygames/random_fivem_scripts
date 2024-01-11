local QBCore = exports['qb-core']:GetCoreObject()

local playerJob = {}
local onDuty = false
local isAttached = false
local canSleep = false

local CONTAINER_HANDLER = nil
local TARGET_CONTAINER = nil
local TARGET_DROP_POS = nil
local CURRENT_DOCK = nil
local BONUS = 0

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() 
    QBCore.Functions.GetPlayerData(function(PlayerData) 
        playerJob = PlayerData.job 
        onDuty = playerJob.onduty 
    end)
    
    for _, settings in pairs(Config.DockConfigs) do
        CreateBlip(vector3(settings.signon.x, settings.signon.y, settings.signon.z), Lang:t("blip.title"), Config.BlipSettings.sprite, Config.BlipSettings.colour)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) 
    playerJob = JobInfo 
    onDuty = playerJob.onduty 
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty) 
    onDuty = duty 
end)

AddEventHandler('onResourceStart', function(resource) 
    if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData)
		playerJob = PlayerData.job
		onDuty = playerJob.onduty
	end)
end)

AddEventHandler('onResourceStop', function(resource) 
    if GetCurrentResourceName() ~= resource then return end
	DeleteEntity(TARGET_CONTAINER)
    TARGET_DROP_POS = nil
    isAttached = false
end)

local function pick_container()
    local rand = math.random(1, #Config.ContainerSpawnPos[CURRENT_DOCK])
    local container = Config.ContainerSpawnPos[CURRENT_DOCK][rand]
    if not IsAnyVehicleNearPoint(container, 2.5) and not IsAnyObjectNearPoint(container, 2.5) then
        TARGET_CONTAINER = CreateProp("prop_contr_03b_ld", container, true, false)
        SetNewWaypoint(container.x, container.y)
    
        TARGET_DROP_POS = Config.ContainerDropPositions[CURRENT_DOCK][math.random(1,#Config.ContainerDropPositions[CURRENT_DOCK])]
        
        DisplayNotification(Lang:t("info.container_ready"), "success")
    else
        pick_container()
    end
end

local function spawn_handler()
    local v = Config.DockConfigs[CURRENT_DOCK].vehicle

    if not IsAnyVehicleNearPoint(vector3(v.x ,v.y, v.z), 2.5) then
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            local veh = NetToVeh(netId)
            SetVehicleEngineOn(veh, false, true)
            CONTAINER_HANDLER = veh
            SetVehicleNumberPlateText(veh, "FS-" .. tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, v.w)
            exports[Config.FuelScript]:SetFuel(veh, 100.0)
            SetVehicleFixed(veh)
            SetEntityAsMissionEntity(veh, true, true)
            SetVehicleDoorsLocked(veh, 2)
            
            pick_container()
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))

            DisplayNotification(Lang:t("info.deposit_paid", { value = Config.ContainerHandlerRentalFee }), "info")
            DisplayNotification(Lang:t("info.started"), "info")

            TriggerServerEvent("hexbyte:docks:server:payDeposit")
        end, "handler", v, false)
    else
        DisplayNotification(Lang:t("error.all_occupied"), "error")
    end
end

AddEventHandler("hexbyte:docks:client:menu", function (dock)
    CURRENT_DOCK = dock
    local MainMenu = {}
    if CONTAINER_HANDLER ~= nil then
        MainMenu[#MainMenu+1] = { title = Lang:t("menu.collect"), description = Lang:t("menu.return_collect"), event = "hexbyte:docks:client:RequestPaycheck"}
    end
    if CONTAINER_HANDLER == nil then
        MainMenu[#MainMenu+1] = { title = Lang:t("menu.start"), description = Lang:t("menu.start_txt"), event = "hexbyte:docks:client:SpawnHandler"}
    end

    lib.registerContext({
        id = 'hexbyte:docks:client:menu',
        title = Lang:t("menu.header"),
        options = MainMenu
    })

    lib.showContext('hexbyte:docks:client:menu')
end)

AddEventHandler("hexbyte:docks:client:SpawnHandler", function ()
    if not onDuty then
        TriggerServerEvent("QBCore:ToggleDuty")
    end
    spawn_handler()
end)

AddEventHandler("hexbyte:docks:client:RequestPaycheck", function ()
    if BONUS > 0 then
        TriggerServerEvent('hexbyte:docks:server:RequestPaycheck', BONUS)
    end

    if onDuty then
        TriggerServerEvent("QBCore:ToggleDuty")
    end

    DeleteVehicle(CONTAINER_HANDLER)
    CONTAINER_HANDLER = nil
    TARGET_CONTAINER = nil
    TARGET_DROP_POS = nil
    BONUS = 0
end)

RegisterCommand('container', function(source, args)
    pick_container()
end, false)

local function RemoveContainerAfterDelay (cid)
    Citizen.CreateThread(function()
        Citizen.Wait(20000)
        SetEntityAsNoLongerNeeded(cid)
    end)
end

local function DrawMarkerLoop()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isAttached do
            Citizen.Wait(0)
            local pedCoords = GetEntityCoords(ped)
            local dist = #( pedCoords - TARGET_DROP_POS)
            if dist <= 100.0 then
                DrawMarker(Config.ContainerDropMarker.type, TARGET_DROP_POS.x, TARGET_DROP_POS.y, TARGET_DROP_POS.z-0.52, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.ContainerDropMarker.scale.x, Config.ContainerDropMarker.scale.y, Config.ContainerDropMarker.scale.z, Config.ContainerDropMarker.colour.r, Config.ContainerDropMarker.colour.g, Config.ContainerDropMarker.colour.b, Config.ContainerDropMarker.colour.a, false, true, 2, false, nil, nil, false)
            end
        end
    end)
end

local function SpawnPed(pos)
    local hash = GetHashKey(Config.SignOnNPC)
    
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(0)
    end

    local ent = CreatePed(4, hash, pos.x, pos.y, pos.z-0.99, pos.w, false, false)

    FreezeEntityPosition(ent,true)
    TaskSetBlockingOfNonTemporaryEvents(ent,true)
    SetEntityInvincible(ent,true)

    return ent
end

CreateThread(function ()
    for dock, settings in pairs(Config.DockConfigs) do
        local ent = SpawnPed(settings.signon)
        exports['qtarget']:AddTargetEntity(ent, {
            options = {
                {
                    icon = 'fas fa-clipboard-user',
                    label = Lang:t("target.talk"),
                    job = 'dockworker',
                    action = function(entity)
                        TriggerEvent('hexbyte:docks:client:menu', dock)
                    end
                }
            },
            distance = 2.5,
        })

        -- exports['qb-target']:SpawnPed({
        --     [1] = {
        --         model = Config.SignOnNPC,
        --         coords = settings.signon,
        --         minusOne = true,
        --         freeze = true,
        --         invincible = true,
        --         blockevents = true,
        --         scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
        --         target = {
        --             options = {
        --                 {
        --                     icon = 'fas fa-clipboard-user',
        --                     label = Lang:t("target.talk"),
        --                     job = 'dockworker',
        --                     action = function(entity)
        --                         TriggerEvent('hexbyte:docks:client:menu', dock)
        --                     end
        --                 }
        --             },
        --             distance = 2.5,
        --         },
        --     }
        -- })
    end
end)

CreateThread(function()
    AddTextEntry("attach_container", Lang:t("help.attach"))
    AddTextEntry("detatch_container", Lang:t("help.detatch"))
    while true do
        Citizen.Wait(0)
        if playerJob.name == "dockworker" and onDuty and TARGET_CONTAINER ~= nil then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if GetEntityModel(veh) == `handler` then
                    if isAttached then
                        if IsEntityAttachedToHandlerFrame(veh, TARGET_CONTAINER) == false then
                            isAttached = false
                            Wait(2000)
                            DeleteEntity(TARGET_CONTAINER)
                            pick_container()
                        end

                        local containerCoords = GetEntityCoords(TARGET_CONTAINER)
                        local dist = #( containerCoords - TARGET_DROP_POS)

                        if dist <= 3.0 then
                            DisplayHelpTextThisFrame("detatch_container")
                            if IsControlJustPressed(0, 55) then
                                DetachContainerFromHandlerFrame(veh)
                                isAttached = false
                                
                                RemoveContainerAfterDelay(TARGET_CONTAINER)
                                
                                TARGET_CONTAINER = -1
                                TARGET_DROP_POS = nil
                                
                                BONUS = BONUS + Config.PerContainerPayout

                                pick_container()

                                Wait(2000)
                            end
                        end
                    else
                        if IsHandlerFrameAboveContainer(veh, TARGET_CONTAINER) == 1 then
                            DisplayHelpTextThisFrame("attach_container")
                            
                            if IsControlJustPressed(0, 55) then
                                AttachContainerToHandlerFrame(veh, TARGET_CONTAINER)
                                isAttached = true
                                DrawMarkerLoop()
                                SetNewWaypoint(TARGET_DROP_POS.x, TARGET_DROP_POS.y)
                                DisplayNotification(Lang:t("info.container_move_to_location"), "info")
                            end
                        end
                    end

                    canSleep = false
                else
                    canSleep = true
                end
            else
                canSleep = true
            end
        else
            canSleep = true
        end

        if canSleep then
            Citizen.Wait(2000)
        end
    end
end)
