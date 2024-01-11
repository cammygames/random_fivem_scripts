MyRep = {} -- This is basicaly a read only copy of the data, server controls updates.

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback('moss_npc:server:initLoadData', false, function(data)
        MyRep = data.rep

        CreateThread(function ()
            for k, npc in pairs(data.cfg) do
                local ped = CreateNPC(npc)
        
                exports.ox_target:addLocalEntity(ped, {
                    {
                        label="Talk",
                        onSelect = function (_)
                            TriggerEvent("moss_npc:client:"..npc.type..":openMenu", {k=k, npc=npc})
                        end
                    }
                })
            end
        end)
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent("moss_npc:server:logOutSync")
end)

RegisterNetEvent("moss_npc:client:sync_rep", function (rep)
    MyRep = rep
end)

RegisterNetEvent("moss_npc:client:notify", function (cfg)
    lib.notify(cfg)
end)
