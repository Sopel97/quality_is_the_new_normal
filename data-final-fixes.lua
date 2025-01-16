do
    local CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local MAX_QUALITY_LEVEL = 5 -- legendary in space-age

    local function alter_assembling_machines(max_quality_level)
        local crafting_speed_multiplier = 1.0 / (1.0 + CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["assembling-machine"]) do
            prototype.crafting_speed = prototype.crafting_speed * crafting_speed_multiplier
        end
    end

    alter_assembling_machines(MAX_QUALITY_LEVEL)
end