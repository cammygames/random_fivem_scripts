Config = {}

Config.Debug = true

Config.ZoneTypeRewards = {
    mine = {

    },
    oil = {
        
    }
}

Config.Zones = {
    ['mine'] = {
        name = "Mine",
        type = "mine",
        icon = {
            sprite = 162,
            display = 2,
            scale = 0.75,
            colour = 0,
            shortRange = false,
        },
        zone = {
            alpha = 100,
            color = 16,
            pos = vec3(2953.51, 2788.74, 41.54),
            radius = 100.0
        }
    },
    -- ['oil_field'] = {
    --     name = "Oil Field",
    --     type = "oil",
    --     icon = {
    --         sprite = 162,
    --         display = 2,
    --         scale = 0.75,
    --         colour = 0,
    --         shortRange = false,
    --     },
    --     zone = {
    --         alpha = 100,
    --         color = 40,
    --         pos = vec3(606.75, 2962.34, 41.02),
    --         radius = 150.0
    --     }
    -- },
}