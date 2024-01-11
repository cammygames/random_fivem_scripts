function SetupInteractionDialog (dialog_id, data, extra_options)
    local k = data.k
    local npc = data.npc
    if npc.interaction.min_rep > 0 then
      local target = npc.interaction.min_rep_from_other_npc or k
      if GetNPCRep(target) < npc.interaction.min_rep then
        lib.notify({
            title = npc.interaction.min_rep_not_met_message,
            type = 'error'
        })
        return
      end
    end

    local dialog_options = {
        {
            title = 'Fence',
            icon = 'user-tie',
            description = 'Occupation',
            readOnly = true,
        },
        {
            title = GetNPCRep(k) ..' Rep',
            icon = 'thermometer-half',
            description = 'Your current standing',
            readOnly = true,
        },
    }

    for _, v in ipairs(extra_options) do
        dialog_options[#dialog_options+1] = v
    end

    lib.registerContext({
        id = dialog_id,
        title = npc.name,
        options = dialog_options
    })

  lib.showContext(dialog_id)
end