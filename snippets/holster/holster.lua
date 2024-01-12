local weapons = {
    'WEAPON_KNIFE',
    'WEAPON_NIGHTSTICK',
    'WEAPON_BREAD',
    'WEAPON_FLASHLIGHT',
    'WEAPON_HAMMER',
    'WEAPON_BAT',
    'WEAPON_GOLFCLUB',
    'WEAPON_CROWBAR',
    'WEAPON_BOTTLE',
    'WEAPON_DAGGER',
    'WEAPON_HATCHET',
    'WEAPON_MACHETE',
    'WEAPON_SWITCHBLADE',
    'WEAPON_BATTLEAXE',
    'WEAPON_POOLCUE',
    'WEAPON_WRENCH',
    'WEAPON_PISTOL',
    'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_REVOLVER',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SMG',
    'WEAPON_ASSAULTSMG',
    'WEAPON_MINISMG',
    'WEAPON_MACHINEPISTOL',
    'WEAPON_COMBATPDW',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_HEAVYSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_MG',
    'WEAPON_COMBATMG',
    'WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER',
    'WEAPON_MARKSMANRIFLE',
    'WEAPON_GRENADELAUNCHER',
    'WEAPON_RPG',
    'WEAPON_STINGER',
    'WEAPON_MINIGUN',
    'WEAPON_GRENADE',
    'WEAPON_STICKYBOMB',
    'WEAPON_SMOKEGRENADE',
    'WEAPON_BZGAS',
    'WEAPON_MOLOTOV',
    'WEAPON_DIGISCANNER',
    'WEAPON_FIREWORK',
    'WEAPON_MUSKET',
    'WEAPON_STUNGUN',
    'WEAPON_HOMINGLAUNCHER',
    'WEAPON_PROXMINE',
    'WEAPON_FLAREGUN',
    'WEAPON_MARKSMANPISTOL',
    'WEAPON_RAILGUN',
    'WEAPON_DBSHOTGUN',
    'WEAPON_AUTOSHOTGUN',
    'WEAPON_COMPACTLAUNCHER',
    'WEAPON_PIPEBOMB',
    'WEAPON_DOUBLEACTION',
    'WEAPON_SNOWBALL',
    'WEAPON_PISTOLXM3',
    'WEAPON_CANDYCANE',
    'WEAPON_CERAMICPISTOL',
    'WEAPON_NAVYREVOLVER',
    'WEAPON_GADGETPISTOL',
    'WEAPON_PISTOLXM3',
    'WEAPON_TECPISTOL',
    'WEAPON_HEAVYRIFLE',
    'WEAPON_MILITARYRIFLE',
    'WEAPON_TACTICALRIFLE',
    'WEAPON_SWEEPERSHOTGUN',
    'WEAPON_ASSAULTRIFLE_MK2',
    'WEAPON_BULLPUPRIFLE_MK2',
    'WEAPON_CARBINERIFLE_MK2',
    'WEAPON_COMBATMG_MK2',
    'WEAPON_HEAVYSNIPER_MK2',
    'WEAPON_KNUCKLE',
    'WEAPON_MARKSMANRIFLE_MK2',
    'WEAPON_PRECISIONRIFLE',
    'WEAPON_PETROLCAN',
    'WEAPON_PUMPSHOTGUN_MK2',
    'WEAPON_RAYCARBINE',
    'WEAPON_RAYMINIGUN',
    'WEAPON_RAYPISTOL',
    'WEAPON_REVOLVER_MK2',
    'WEAPON_SMG_MK2',
    'WEAPON_SNSPISTOL_MK2',
    'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_STONE_HATCHET'
}

local holstered = true
local canFire = true
local currWeap = `WEAPON_UNARMED`
local wearingHolster = nil
local lastHolsterTexture = nil

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function checkWeapon(newWeap)
    for i = 1, #weapons do
        if joaat(weapons[i]) == newWeap then
            return true
        end
    end
    return false
end

local function isWeaponHolsterable(weap)
    for i = 1, #Config.WeapDraw.weapons do
        if joaat(Config.WeapDraw.weapons[i]) == weap then
            return true
        end
    end
    return false
end

RegisterNetEvent('weapons:ResetHolster', function()
    holstered = true
    canFire = true
    currWeap = `WEAPON_UNARMED`
    lastHolsterTexture = nil
    wearingHolster = nil
end)

-- Get one big list of numbers to do the basic check for has a holster
function GetAllVariants(category)
    local final = {}

    for _, v in pairs(Config.WeapDraw.variants[category]) do
        if final[v.with] == nil then
            final[#final+1] = v.with
        end

        if final[v.without] == nil then
            final[#final+1] = v.without
        end
    end

    return final
end

function MapVariantsToKeys(category)
    local final = {}

    for _, v in pairs(Config.WeapDraw.variants[category]) do
        if final[v.with] == nil then
            final[v.with] = v
        end

        if final[v.without] == nil then
            final[v.without] = v
        end
    end

    return final
end

local allHolsters = {}
local holsterConfigs = {}

for k, _ in pairs(Config.WeapDraw.mapping) do
    allHolsters[k] = GetAllVariants(k)
    holsterConfigs[k] = MapVariantsToKeys(k)
end

CreateThread(function()
    while true do
    Wait(4)
    if IsPedArmed(PlayerPedId(), 4 | 2) then
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
    else
        Wait(1500)
    end
    end
end)


RegisterNetEvent('weapons:client:DrawWeapon', function()
    local sleep
    local weaponCheck = 0

    local holsterDrawableVariation = nil
    local holsterConfig = nil
    while true do
        local ped = PlayerPedId()
        sleep = 250
        if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedFalling(ped) and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) then
            sleep = 0
            if currWeap ~= GetSelectedPedWeapon(ped) then
                local pos = GetEntityCoords(ped, true)
                local rot = GetEntityHeading(ped)

                local newWeap = GetSelectedPedWeapon(ped)
                SetCurrentPedWeapon(ped, currWeap, true)
                loadAnimDict('reaction@intimidation@1h')
                loadAnimDict('reaction@intimidation@cop@unarmed')
                loadAnimDict('rcmjosh4')
                loadAnimDict('weapons@pistol@')

                wearingHolster = false
                for k, v in pairs(Config.WeapDraw.mapping) do
                    local holsterVariant = GetPedDrawableVariation(ped, v)

                    for i = 1, #allHolsters[k], 1 do
                        if holsterVariant == allHolsters[k][i] then
                            holsterDrawableVariation = v
                            holsterConfig = holsterConfigs[k][holsterVariant]
                            
                            if holstered then
                                lastHolsterTexture = GetPedTextureVariation(ped, v)
                            end

                            wearingHolster = true
                            break;
                        end 
                    end

                    if wearingHolster then
                        break;
                    end
                end

                if checkWeapon(newWeap) then
                    if holstered then
                        if wearingHolster then
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'rcmjosh4', 'josh_leadout_cop2', pos.x, pos.y, pos.z, 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(300)
                            SetCurrentPedWeapon(ped, newWeap, true)

                            if isWeaponHolsterable(newWeap) then
                                local texCount = GetNumberOfPedTextureVariations(ped, holsterDrawableVariation, holsterConfig.without)
                                local tex = 0

                                if texCount ~= 1 then 
                                    tex = lastHolsterTexture
                                end

                                SetPedComponentVariation(ped, holsterDrawableVariation, holsterConfig.without, tex, 2)
                            end
                            currWeap = newWeap
                            Wait(300)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        else
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1000)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            currWeap = newWeap
                            Wait(1400)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        end
                    elseif newWeap ~= currWeap and checkWeapon(currWeap) then
                        if wearingHolster then
                            canFire = false
                            CeaseFire()

                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@cop@unarmed', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(500)

                            if holstered then
                                lastHolsterTexture = GetPedTextureVariation(ped, v)
                            end

                            if isWeaponHolsterable(currWeap) then
                                SetPedComponentVariation(ped, holsterDrawableVariation, holsterConfig.with, lastHolsterTexture, 2)
                            end

                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            TaskPlayAnimAdvanced(ped, 'rcmjosh4', 'josh_leadout_cop2', pos.x, pos.y, pos.z, 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(300)
                            SetCurrentPedWeapon(ped, newWeap, true)

                            if isWeaponHolsterable(newWeap) then
                                print("Updating to without model?")
                                local texCount = GetNumberOfPedTextureVariations(ped, holsterDrawableVariation, holsterConfig.without)
                                local tex = 0

                                if texCount ~= 1 then 
                                    tex = lastHolsterTexture
                                end

                                SetPedComponentVariation(ped, holsterDrawableVariation, holsterConfig.without, tex, 2)
                            end

                            Wait(500)
                            currWeap = newWeap
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        else
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'outro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1600)
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1000)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            currWeap = newWeap
                            Wait(1400)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        end
                    else
                        if wearingHolster then
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            TaskPlayAnimAdvanced(ped, 'rcmjosh4', 'josh_leadout_cop2', pos.x, pos.y, pos.z, 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(300)
                            SetCurrentPedWeapon(ped, newWeap, true)

                            if isWeaponHolsterable(newWeap) then
                                local texCount = GetNumberOfPedTextureVariations(ped, holsterDrawableVariation, holsterConfig.without)
                                local tex = 0

                                if texCount ~= 1 then 
                                    tex = lastHolsterTexture
                                end

                                SetPedComponentVariation(ped, holsterDrawableVariation, holsterConfig.without, tex, 2)
                            end

                            currWeap = newWeap
                            Wait(300)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        else
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1000)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            currWeap = newWeap
                            Wait(1400)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        end
                    end
                else
                    if not holstered and checkWeapon(currWeap) then
                        if wearingHolster then
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@cop@unarmed', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(500)

                            if isWeaponHolsterable(currWeap) then
                                SetPedComponentVariation(ped, holsterDrawableVariation, holsterConfig.with, lastHolsterTexture, 2)
                            end

                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            ClearPedTasks(ped)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            holstered = true
                            canFire = true
                            currWeap = newWeap
                        else
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'outro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1400)
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            ClearPedTasks(ped)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            holstered = true
                            canFire = true
                            currWeap = newWeap
                        end
                    else
                        SetCurrentPedWeapon(ped, newWeap, true)
                        holstered = false
                        canFire = true
                        currWeap = newWeap
                    end
                end
            end
        end
        Wait(sleep)
        if currWeap == nil or currWeap == `WEAPON_UNARMED` then
            weaponCheck += 1
            if weaponCheck == 2 then
                break
            end
        end
    end
end)

function CeaseFire()
    CreateThread(function()
        while not canFire do
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerId(), true)
            Wait(0)
        end
    end)
end