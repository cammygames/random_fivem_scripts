local function UseShovel(data, slot)
    CreateThread(function ()
        if CurrentZone == nil then
            return
        end
    
        local rock = RequestRock()

        exports.ox_inventory:useItem(data, function(data)
            if data then
                ExcavateRock(rock)            
            end
        end)
    end)
end

exports("shovel", UseShovel)