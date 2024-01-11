Config = {}

/*
    Add to the fields from CHandlingData you want players to be able to edit.

    NOTE: Currently only supports float fields as they are set via the SetVehicleHandlingFloat function. This will be expanded in the future.

    Useful Resources:
        https://forums.gta5-mods.com/topic/24280/understanding-and-editing-gtav-s-handling
        https://gtamods.com/wiki/Handling.meta
*/
Config.EditableFields = {
    fInitialDriveForce = {
        default = 1.0,
        min = 0.01,
        max = 2.0
    },
    fDriveInertia = {
        default = 1.0,
        min = 0.01,
        max = 2.0
    },
    fDriveBiasFront = {
        default = 0.5,
        min = 0.0,
        max = 1.0
    },
    fBrakeBiasFront = {
        default = 0.5,
        min = 0.0,
        max = 1.0
    },
    fTractionBiasFront = {
        default = 0.5,
        min = 0.01,
        max = 0.99
    }
}

-- Set this to nil to disable the job requirement
Config.RequiredJob = "mechanic"

/*
    DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING
*/

local function ListTableKeys(tbl)
    local keys = {}

    for k, v in pairs(tbl) do
        keys[#keys+1] = k
    end

    return keys
end

Config.EditableKeys = ListTableKeys(Config.EditableFields)
