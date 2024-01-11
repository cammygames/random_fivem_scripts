Config = {}

Config.RewardsGivenToPlayer = false

Config.MaxRep = 100

Config.NPC = {
    ["kh"] = {
        name = "Kyron Henry",
        model = `CSB_Vernon`,
        pos = vector4(-1316.28, 124.53, 57.23-0.99, 207.56), --{vector4(-294.67, -346.82, 10.06-0.99, 5.07), vector4(-553.4, -872.04, 27.21-0.99, 137.09)}, -- supports table or vector4, but will only use one position from a table.
        anim = {
            --Scenario = "", -- You can just pass a Scenario insead of an anim.
            Animation = 'idle_a',
            Dictionary = 'amb@world_human_leaning@male@wall@back@foot_up@idle_a',
            Options = {
                Flags = {
                    Loop = true,
                },
            },
        },
        defaults = {
            rep = 0,
            unlocked = true,
        },
        type = "fence",
        interaction = {
            min_rep = 0,
            min_rep_not_met_message = "I ain't got time for you, go away!",
            min_rep_from_other_npc = nil, -- nil or npc. This will look at the players rep with the other npc
            messages = {
                "Some text here for the box. perhaps MD????"
            }
        },
        trade_cfg = {
            ["thermite"] = {
                min_rep = 0, -- Min rep required with this npc to be allowed to trade this item.
                rep_reward = 0.01, -- Rep will alter rep with this NPC. negative numbers will decrese rep.
                mode = "all", -- can be all or random. all will give all items in the rewards table. random will pick one random entry from the table.
                rewards = {
                    ["cash"] = 55,
                    ["joint"] = 1
                }
            }
            -- ["thermite"] = { -- the item the player has to put in to the inventory
            --     min_rep = 0, -- Min rep reuired with this npc to be allowed to trade this item.
            --     rep_reward = 5, -- Rep will alter rep with this NPC. negative numbers will decrese rep.
            --     rewards = {
            --         ["cash"] = 0, -- Cash with a number will give this amount in cash
            --         ["item_here"] = 1 -- item with a number with give the player this amount of the item.
            --         ["cash"] = { -- cash / item with a table will give the player the amount of item that is nearest their rep level. so a rep level 4 player would only get reward bouns of rep level 1 as they havent gotten to rep level 5. teirs can only be whole numbers eg, 1, 2, 3, 4, etc. if the player has a rep level lower than the lowest rep level in this tabel they will not get anything.
            --              [0] = 1,
            --              [1] = 1,
            --              [5] = 1,
            --              [10] = 1,
            --              [15] = 1,
            --              [20] = 1,
            --              [25] = 1,
            --              [30] = 1,
            --              [35] = 1,
            --              [40] = 1,
            --          },
                    
            --     }
            -- }
        }
    },
    -- ['ts'] = {
    --     name = "Test Job Shop",
    --     model = `S_M_M_Janitor`,
    --     pos = vector4(-1316.28, 124.53, 57.23-0.99, 207.56), --{vector4(-294.67, -346.82, 10.06-0.99, 5.07), vector4(-553.4, -872.04, 27.21-0.99, 137.09)}, -- supports table or vector4, but will only use one position from a table.
    --     anim = {
    --         --Scenario = "", -- You can just pass a Scenario insead of an anim.
    --         Animation = 'idle_a',
    --         Dictionary = 'amb@world_human_leaning@male@wall@back@foot_up@idle_a',
    --         Options = {
    --             Flags = {
    --                 Loop = true,
    --             },
    --         },
    --     },
    --     default_rep = 0,
    --     type = "job",
    --     features = {
    --         signon = true,
    --         shop = true
    --     },
    --     job = "mechanic",
    --     shop = {
            
    --     }
    -- }
}