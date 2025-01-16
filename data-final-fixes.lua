do
    require("util")

    local CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local INSERTER_ROTATION_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local INSERTER_POWER_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local PUMP_PUMPING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local BOILER_ENERGY_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local GENERATOR_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local SOLAR_PANEL_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local MAX_QUALITY_LEVEL = 5 -- legendary in space-age

    local function multiply_energy(energy, mult)
        return tostring(util.parse_energy(energy) * mult) .. "J"
    end

    local function alter_assembling_machines(max_quality_level)
        local crafting_speed_multiplier = 1.0 / (1.0 + CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["assembling-machine"]) do
            prototype.crafting_speed = prototype.crafting_speed * crafting_speed_multiplier
        end
    end

    local function alter_furnaces(max_quality_level)
        local crafting_speed_multiplier = 1.0 / (1.0 + CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["furnace"]) do
            prototype.crafting_speed = prototype.crafting_speed * crafting_speed_multiplier
        end
    end

    local function alter_inserters(max_quality_level)
        local rotation_speed_multiplier = 1.0 / (1.0 + INSERTER_ROTATION_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        local power_consumption_multiplier = 1.0 / (1.0 + INSERTER_POWER_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["inserter"]) do
            prototype.rotation_speed = prototype.rotation_speed * rotation_speed_multiplier
            prototype.energy_per_movement = multiply_energy(prototype.energy_per_movement, power_consumption_multiplier)
            prototype.energy_per_rotation = multiply_energy(prototype.energy_per_rotation, power_consumption_multiplier)
        end
    end

    local function alter_pumps(max_quality_level)
        local pumping_speed_multiplier = 1.0 / (1.0 + PUMP_PUMPING_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["pump"]) do
            prototype.pumping_speed = prototype.pumping_speed * pumping_speed_multiplier
        end
    end

    local function alter_boilers(max_quality_level)
        local power_consumption_multiplier = 1.0 / (1.0 + BOILER_ENERGY_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["boiler"]) do
            prototype.energy_consumption = multiply_energy(prototype.energy_consumption, power_consumption_multiplier)
        end
    end

    local function alter_generators(max_quality_level)
        local power_production_multiplier = 1.0 / (1.0 + GENERATOR_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["generator"]) do
            prototype.fluid_usage_per_tick = prototype.fluid_usage_per_tick * power_production_multiplier
            if prototype.max_power_output ~= nil then
                prototype.max_power_output = multiply_energy(prototype.max_power_output, power_production_multiplier)
            end
        end
    end

    local function alter_solar_panels(max_quality_level)
        local power_production_multiplier = 1.0 / (1.0 + SOLAR_PANEL_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["solar-panel"]) do
            prototype.production = multiply_energy(prototype.production, power_production_multiplier)
        end
        for key, prototype in pairs(data.raw["solar-panel-equipment"]) do
            prototype.power = multiply_energy(prototype.power, power_production_multiplier)
        end
    end

    alter_assembling_machines(MAX_QUALITY_LEVEL)
    alter_furnaces(MAX_QUALITY_LEVEL)
    alter_inserters(MAX_QUALITY_LEVEL)
    alter_pumps(MAX_QUALITY_LEVEL)
    alter_boilers(MAX_QUALITY_LEVEL)
    alter_generators(MAX_QUALITY_LEVEL)
    alter_solar_panels(MAX_QUALITY_LEVEL)
end