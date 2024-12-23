Config = {}

Config.Debug = true

Config.Notify = "ox_lib"
Config.ProgressBar = "ox_lib"
Config.Target = "ox_target"
Config.Framework = "ESX"
Config.Inventory = "ox_inventory"

Config.Picking = {
    Grapes1 = {
        pos = vec3(-1861.7833, 2097.8284, 139.1004),
        radius = 0.6,
        debug = true,
        icon = "fas fa-hand",
        animation = {dict = "missmechanic", set = "work_base", duration = 5000},
        enableMinigame = true,
        rewards = {
            { item = "white_grapes", label = "White Grapes", amount = math.random(2, 5)},
          --{ item = "white_grapes", label = "White Grapes", min = 2, max = 5},
        }
    },
    Grapes2 = {
        pos = vec3(-2861.7833, 2097.8284, 139.1004),
        radius = 0.6,
        debug = true,
        icon = "fas fa-hand",
        animation = {dict = "missmechanic", set = "work_base", duration = 5000},
        rewards = {
            { item = "red", label = "Red Grapes", amount = math.random(2, 5)},
          --{ item = "white_grapes", label = "White Grapes", min = 2, max = 5},
        }
    }
}

Config.Processing = {
    Process1 = {
        modelCoords = vec4(-1889.2221, 2093.3654, 139.99259, 352.125),
        model = "prop_crate_01a",
        animation = {dict = "amb@world_human_jog_standing@male@idle_a", set = "idle_c", duration = 3000},
        --teleportCoords = vec4() -- This should be in the middle of the crate prop
    }
}


Config.Fermentation = {
    Station1 = {
        modelCoords = vec4(-1925.0935, 2059.2265, 139.81745, 164.999),
        model = "sf_prop_sf_distillery_01a",
        enableModel = true, -- when false the prop won't spawn. Good to use if you have mlo with the prop,
        duration = 5000,
        items = {
            red_wine = {
                item = "red_wine",
                label = "Red Wine",
                requiredItem = "red_must",
                requiredItemLabel = "Red Must",
                requiredMust = 5,
                rewardAmount = 1,
            },
            white_wine = {
                item = "white_wine",
                label = "White Wine",
                requiredItem = "white_must",
                requiredItemLabel = "White Must",
                requiredMust = 5,
                rewardAmount = 1
            },
        },
    }
}

Config.Items = {
    redGrape = {
        label = "Red Grapes",
        item = "red_grapes",
        amount = math.random(1, 5),
        treadItems = {
            label = "Red Must",
            item = "red_must",
            rewardAmount = 1,
            requiredGrapes = 5
        }
    },
    whiteGrape = {
        label = "White Grapes",
        item = "white_grapes",
        amount = math.random(1, 5),
        treadItems = {
            label = "White Must",
            item = "white_must",
            rewardAmount = 1,
            requiredGrapes = 5
        }
    }
}