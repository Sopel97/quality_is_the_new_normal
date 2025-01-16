do
    require("util")

    local CRAFTING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local INSERTER_ROTATION_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local INSERTER_POWER_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local PUMP_PUMPING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local BOILER_ENERGY_CONSUMPTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local GENERATOR_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local SOLAR_PANEL_ENERGY_PRODUCTION_INCREASE_PER_QUALITY_LEVEL = 0.3
    local ACCUMULATOR_ENERGY_CAPACITY_INCREASE_PER_QUALITY_LEVEL = 1.0
    local ACCUMULATOR_ENERGY_THROUGHPUT_INCREASE_PER_QUALITY_LEVEL = 0.3
    local LAB_RESEARCHING_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local BEACON_POWER_CONSUMPTION_DECREASE_PER_QUALITY_LEVEL = 1.0
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
        for key, prototype in pairs(data.raw["offshore-pump"]) do
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

    local function alter_accumulators(max_quality_level)
        local power_capacity_multiplier = 1.0 / (1.0 + ACCUMULATOR_ENERGY_CAPACITY_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        local power_throughput_multiplier = 1.0 / (1.0 + ACCUMULATOR_ENERGY_THROUGHPUT_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["accumulator"]) do
            prototype.energy_source.buffer_capacity = multiply_energy(prototype.energy_source.buffer_capacity, power_capacity_multiplier)
            prototype.energy_source.input_flow_limit = multiply_energy(prototype.energy_source.input_flow_limit, power_throughput_multiplier)
            prototype.energy_source.output_flow_limit = multiply_energy(prototype.energy_source.output_flow_limit, power_throughput_multiplier)
        end
        for key, prototype in pairs(data.raw["battery-equipment"]) do
            prototype.energy_source.buffer_capacity = multiply_energy(prototype.energy_source.buffer_capacity, power_capacity_multiplier)
        end
    end

    local function alter_labs(max_quality_level)
        local researching_speed_multiplier = 1.0 / (1.0 + LAB_RESEARCHING_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["lab"]) do
            prototype.researching_speed = prototype.researching_speed * researching_speed_multiplier
        end
    end

    local function alter_beacons(max_quality_level)
        local power_consumption_multiplier = 1.0 + BEACON_POWER_CONSUMPTION_DECREASE_PER_QUALITY_LEVEL * max_quality_level
        for key, prototype in pairs(data.raw["beacon"]) do
            prototype.energy_usage = multiply_energy(prototype.energy_usage, power_consumption_multiplier)

            if prototype.distribution_effectivity_bonus_per_quality_level ~= nil then
                local distribution_effectivity_offset = -prototype.distribution_effectivity_bonus_per_quality_level * max_quality_level
                prototype.distribution_effectivity = prototype.distribution_effectivity + distribution_effectivity_offset
            end
        end
    end

    alter_assembling_machines(MAX_QUALITY_LEVEL)
    alter_furnaces(MAX_QUALITY_LEVEL)
    alter_inserters(MAX_QUALITY_LEVEL)
    alter_pumps(MAX_QUALITY_LEVEL)
    alter_boilers(MAX_QUALITY_LEVEL)
    alter_generators(MAX_QUALITY_LEVEL)
    alter_solar_panels(MAX_QUALITY_LEVEL)
    alter_accumulators(MAX_QUALITY_LEVEL)
    alter_labs(MAX_QUALITY_LEVEL)
    alter_beacons(MAX_QUALITY_LEVEL)
end