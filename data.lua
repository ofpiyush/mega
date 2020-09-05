local resources = require("resources")

function make_infinite_chest(name, tint, order)
    local infinite_chest = table.deepcopy(data.raw["infinity-container"]["infinity-chest"])

    local icons = {{
        icon=infinite_chest.icon,
        icon_size=infinite_chest.icon_size,
        tint=tint
    },}

    local item_name = name .. "-infinity-chest"
    
    infinite_chest.name = item_name
    infinite_chest.icons = icons
    infinite_chest.order = order
    infinite_chest.gui_mode = "none"
    infinite_chest.erase_contents_when_mined = true
    infinite_chest.logistic_mode = "passive-provider"  
  
    local item = {
        type = "item",
        name = item_name,
        icons = icons,
        subgroup = "other",
        order = order,
        place_result = item_name,
        stack_size = 5
    }
  
    local recipe = {
        type = "recipe",
        name = item_name,
        enabled = false,
        energy_required=60,
        ingredients = {
            {name,5000},
            {"electric-mining-drill", 35},
            {"beacon",100},
            {"electric-energy-interface",1},
            {"steel-plate", 100},
            {"productivity-module-3", 60},
        },
        result = item_name
    }
  
    data:extend({ infinite_chest, item, recipe })
end

function make_infinite_pipe(name, tint, order)
    local infinite_pipe = table.deepcopy(data.raw["infinity-pipe"]["infinity-pipe"])
    local item_data = data.raw.fluid[name]
    local icons = {{
        icon=item_data.icon,
        icon_size=item_data.icon_size,
        tint=tint
    },}

    local item_name = name .. "-infinity-pipe"
    
    infinite_pipe.name = item_name
    infinite_pipe.icons = icons
    infinite_pipe.order = order
    infinite_pipe.gui_mode = "none"
  
    local item = {
        type = "item",
        name = item_name,
        icon = item_data.icon,
        icon_size = item_data.icon_size,
        subgroup = "other",
        order = order,
        place_result = item_name,
        stack_size = 5
    }

  
    local recipe = {
      type = "recipe",
      name = item_name,
      enabled = false,
      energy_required=60,
      category="crafting-with-fluid",
      ingredients = {
          {type="fluid", name=name, amount=10000},
          {"pipe", 100},
          {"electric-engine-unit",100},
          {"electric-energy-interface",1},
          {"steel-plate", 100},
          {"productivity-module-3", 60},
      },
      result = item_name
    }
  
    data:extend({ infinite_pipe, item, recipe })
end



data:extend({
  {
    type = "recipe",
    name = "electric-energy-interface",
    enabled = false,
    energy_required=30,
    ingredients = {
        {"uranium-fuel-cell",100},
        {"nuclear-reactor",5},
        {"heat-exchanger",50},
        {"steam-turbine",100},
        {"accumulator",50},
        {"effectivity-module-3",60},
    },
    result = "electric-energy-interface"
  },
})


data.raw["infinity-container"]["infinity-chest"].gui_mode = "none"
data.raw["infinity-pipe"]["infinity-pipe"].gui_mode = "none"
data.raw["heat-interface"]["heat-interface"].gui_mode = "none"
data.raw["electric-energy-interface"]["electric-energy-interface"].gui_mode = "none"
data.raw["electric-energy-interface"]["electric-energy-interface"].energy_source = {
    type = "electric",
    buffer_capacity = "1GJ",
    usage_priority = "primary-output",
    input_flow_limit = "0W",
    output_flow_limit = "2GW",
}

for i, item in pairs(resources.chest) do
    make_infinite_chest(item.name, item.tint, "a"..tostring(i))
end

for i, item in pairs(resources.pipe) do
    make_infinite_pipe(item.name, item.tint, "b"..tostring(i))
end


local eee_research = {
    type = "technology",
    name = "electric-energy-interface",
    icon = data.raw["accumulator"]["accumulator"].icon,
    icon_size = data.raw["accumulator"]["accumulator"].icon_size,
    unit = {
        count=1500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1}
        },
        time = 30
    },
    prerequisites={"nuclear-power","effectivity-module-3","space-science-pack","electric-energy-accumulators"},
    effects={
        {
          type  = "unlock-recipe",
          recipe = "electric-energy-interface"
        }
    }
}

local inf_pipe_research = {
    type = "technology",
    name = "infinity-pipes",
    icon = data.raw["pipe"]["pipe"].icon,
    icon_size = data.raw["pipe"]["pipe"].icon_size,
    unit = {
        count=2000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1}
        },
        time = 60
    },
    prerequisites={"productivity-module-3","space-science-pack","electric-energy-interface"},
    effects={},
}

for _,item in pairs(resources.pipe) do
    table.insert(inf_pipe_research.effects,{
        type  = "unlock-recipe",
        recipe = item.name .. "-infinity-pipe"
    })
end


local inf_chest_research = {
    type = "technology",
    name = "infinity-chests",
    icon = data.raw["infinity-container"]["infinity-chest"].icon,
    icon_size = data.raw["infinity-container"]["infinity-chest"].icon_size,
    unit = {
        count=2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1}
        },
        time = 60
    },
    prerequisites={"effect-transmission","mining-productivity-3","productivity-module-3","space-science-pack","electric-energy-interface"},
    effects={},
}
for _,item in pairs(resources.chest) do
    table.insert(inf_chest_research.effects,{
        type  = "unlock-recipe",
        recipe = item.name .. "-infinity-chest"
    })
end

data:extend({eee_research,inf_pipe_research, inf_chest_research})
