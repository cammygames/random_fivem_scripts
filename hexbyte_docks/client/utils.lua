function LoadProp(model)
    if not HasModelLoaded(model) then
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(100)
        end
    end
end

function CreateProp(model, pos, network, freeze)
    LoadProp(model)

    local prop = CreateObject(model, pos.x, pos.y, pos.z, network or false, network or false, false)
    PlaceObjectOnGroundProperly(prop)

    SetEntityHeading(prop, pos.w)
    FreezeEntityPosition(prop, freeze or false)
    SetEntityAsMissionEntity(prop, true, true)

    return prop
end

function CreateBlip(coords, text, sprite, colour, scale, disp) 
	local blip = AddBlipForCoord(coords)
	SetBlipAsShortRange(blip, true)
	SetBlipSprite(blip, sprite or 1)
	SetBlipColour(blip, colour or 0)
	SetBlipScale(blip, scale or 0.7)
	SetBlipDisplay(blip, (disp or 6))
    
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)

    return blip
end