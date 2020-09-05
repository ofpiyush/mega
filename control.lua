local resources = require("resources")

function infinity_chests(data)
    return function (event)
        local entity = event.created_entity or event.entity
        
        if (entity and entity.valid) and not (data[entity.name] == nil) then
            if entity.type == "infinity-container" then
                entity.set_infinity_container_filter(1,{name=data[entity.name], count=10000,index=1})
                entity.remove_unfiltered_items = true
            end
            if entity.type == "infinity-pipe" then
                entity.set_infinity_pipe_filter({name=data[entity.name], percentage=2})
            end
        end
    end 
end

do
    local function init_events()
        filters = {}
        data = {}
        for _, item in pairs(resources.chest) do
            local chest_type = item.name .. "-infinity-chest"
            table.insert(filters,{filter="name", name=chest_type})
            data[chest_type] = item.name
        end

        for _, item in pairs(resources.pipe) do
            local pipe_type = item.name .. "-infinity-pipe"
            table.insert(filters,{filter="name", name=pipe_type})
            data[pipe_type] = item.name
        end

        local fn = infinity_chests(data)
        script.on_event(defines.events.on_built_entity, fn, filters)
        script.on_event(defines.events.on_robot_built_entity, fn, filters)
    end

    script.on_load(function()
        init_events()
    end)

    script.on_init(function()
        init_events()
    end)

    script.on_configuration_changed(function(data)
        init_events()
    end)

end