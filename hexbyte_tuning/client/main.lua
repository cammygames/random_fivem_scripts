local QBCore = exports['qb-core']:GetCoreObject()
local PreviousVehicleState = {}

local function HasDifference(tbl, key, value)
    local retval = false

    for k, v in pairs(tbl) do
        if k == key then
            if v ~= value then
                retval = true
            end
        end
    end

    return retval
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function DropTuneName(tbl)
    local out = {}

    for k, v in pairs(tbl) do
        if k ~= "tuneName" then
            out[k] = tonumber(v)
        end
    end

    return out
end

local function ToggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
end

local function GetVehicleTune(veh)
    if not veh then
        veh = GetVehiclePedIsUsing(PlayerPedId())
    end

    local mapping = {}

    for k, v in ipairs(Config.EditableKeys) do
        mapping[v] = round(GetVehicleHandlingFloat(veh, "CHandlingData", v), 2)
    end

    return mapping
end

exports("GetVehicleTune", GetVehicleTune)

local function SetVehicleTune(data, veh)
    if not veh then
        veh = GetVehiclePedIsUsing(PlayerPedId())
    end

    for k, v in pairs(data) do
        if Config.EditableFields[k] ~= nil then
            if v < Config.EditableFields[k].min then
                v = Config.EditableFields[k].min
            elseif v > Config.EditableFields[k].max then
                v = Config.EditableFields[k].max
            end
        end

        if HasDifference(PreviousVehicleState, k, v) then
            SetVehicleHandlingFloat(veh, "CHandlingData", k, v)
        end
    end
end

exports("SetVehicleTune", SetVehicleTune)

local function OpenTuneMenu()
    local veh = GetVehiclePedIsUsing(PlayerPedId())

    if not veh then
        QBCore.Functions.Notify("Please enter a vehicle", "error")
        return
    end

    PreviousVehicleState = GetVehicleTune(veh)

    ToggleNuiFrame(true)

    SendReactMessage('open', {
        fields = Config.EditableFields,
        tune = PreviousVehicleState
    })
end

local function ResetTune(veh)
    if not veh then
        veh = GetVehiclePedIsUsing(PlayerPedId())
    end

    for k, v in pairs(Config.EditableFields) do
        SetVehicleHandlingFloat(veh, "CHandlingData", k, v.default)
    end
end

RegisterCommand("ResetTune", function ()
    ResetTune()
end)

RegisterNetEvent("hexbyte:tuing:client:openTuneMenu", function ()
    OpenTuneMenu()
end)

RegisterNetEvent("hexbyte:tuning:client:applyFromChip", function (data)
    SetVehicleTune(data)
end)

RegisterNUICallback("saveToCar", function (data)
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    local tuneName = data.tuneName;
    data = DropTuneName(data);

    TriggerServerEvent("hexbyte:tuning:saveTuning", GetVehicleNumberPlateText(veh), data)
    SetVehicleTune(data)
end)

RegisterNUICallback("saveToChip", function (data)
    local tuneName = data.tuneName;
    data = DropTuneName(data);
    
    TriggerServerEvent("hexbyte:tuning:server:saveToChip", {
        tune = data,
        name = tuneName
    })
end)

RegisterNUICallback("exit", function()
    ToggleNuiFrame(false)
end)