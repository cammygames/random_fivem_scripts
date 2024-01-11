function GetConfig()
    return cache("moss_npc:config", function ()
        local fixed_config = {}

        for k, cfg in pairs(Config.NPC) do
            if type(cfg.pos) == "table" then
                cfg.pos = cfg.pos[math.random(#cfg.pos)]
                lib.print.debug("Pos for npc "..k.." "..cfg.pos)
            end

            fixed_config[k] = cfg
        end

        return fixed_config
    end)
end

function GetAllNpcNames()
    return cache("moss_npc:all_npcs", function ()
        local retval = {}

        for k, v in pairs(Config.NPC) do
            retval[#retval+1] = k
        end
    
        return retval
    end)
end

function GetRandomTableEntry(tbl)
  local num_tbl = {}

  for k, v in pairs(tbl) do
    num_tbl[#num_tbl+1] = {
      k=k,
      v=v,
    }
  end

  return num_tbl[math.random(#num_tbl)]
end