function CreateNPC(cfg)
    lib.requestModel(cfg.model, 1000)

    local ped = CreatePed(0, cfg.model, cfg.pos, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    PlaceObjectOnGroundProperly(ped)

    if cfg.anim.Animation then
        local movementFlag = 0
        local duration = cfg.anim.Options.Duration

        lib.requestAnimDict(cfg.anim.Dictionary, 1000)
        if cfg.anim.Options.Flags then
            if cfg.anim.Options.Flags.Loop then
                movementFlag = 1
            end

            if cfg.anim.Options.Flags.Move then movementFlag = 51 end
            if cfg.anim.Options.Flags.Stuck then movementFlag = 50 end
        end

        TaskPlayAnim(ped, cfg.anim.Dictionary, cfg.anim.Animation, 2.0, 2.0, duration or -1, movementFlag, 0, false, false, false)
        RemoveAnimDict(cfg.anim.Dictionary)
    elseif cfg.anim.Scenario then
        TaskStartScenarioInPlace(ped, cfg.anim.Scenario, 0, true)
    end

    return ped
end