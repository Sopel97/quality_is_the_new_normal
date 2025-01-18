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
    local MODULE_SPEED_INCREASE_PER_QUALITY_LEVEL = 0.3
    local MODULE_PRODUCTIVITY_INCREASE_PER_QUALITY_LEVEL = 0.3
    local MODULE_EFFICIENCY_INCREASE_PER_QUALITY_LEVEL = 0.3
    local REACTOR_POWER_INCREASE_PER_QUALITY_LEVEL = 0.3
    local WAGON_CAPACITY_INCREASE_PER_QUALITY_LEVEL = 0.3
    local ROBOPORT_RECHARGE_RATE_INCREASE_PER_QUALITY_LEVEL = 0.3
    local PERSONAL_ROBOPORT_ROBOT_LIMIT_INCREASE_PER_QUALITY_LEVEL = 0.3
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

        for key, prototype in pairs(data.raw["fusion-generator"]) do
            prototype.max_fluid_usage = prototype.max_fluid_usage * power_production_multiplier
        end

        for key, prototype in pairs(data.raw["generator-equipment"]) do
            prototype.power = multiply_energy(prototype.power, power_production_multiplier)
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

    local function alter_modules(max_quality_level)
        local speed_effect_multiplier = 1.0 / (1.0 + MODULE_SPEED_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        local productivity_effect_multiplier = 1.0 / (1.0 + MODULE_PRODUCTIVITY_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        local efficiency_effect_multiplier = 1.0 / (1.0 + MODULE_EFFICIENCY_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["module"]) do
            local effect = prototype.effect

            if prototype.category == "speed" then
                effect.speed = effect.speed * speed_effect_multiplier
            end

            if prototype.category == "productivity" then
                effect.productivity = effect.productivity * productivity_effect_multiplier
            end

            if prototype.category == "efficiency" then
                effect.consumption = effect.consumption * efficiency_effect_multiplier
            end

            -- Quality left as-is because it's properly balanced
        end
    end

    local function alter_reactors(max_quality_level)
        local power_multiplier = 1.0 / (1.0 + REACTOR_POWER_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        for key, prototype in pairs(data.raw["reactor"]) do
            prototype.consumption = multiply_energy(prototype.consumption, power_multiplier)
        end

        for key, prototype in pairs(data.raw["fusion-reactor"]) do
            prototype.power_input = multiply_energy(prototype.power_input, power_multiplier)
            prototype.max_fluid_usage = prototype.max_fluid_usage * power_multiplier
        end
    end

    local function alter_wagons(max_quality_level)
        local capacity_multiplier = 1.0 / (1.0 + WAGON_CAPACITY_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        
        for key, prototype in pairs(data.raw["cargo-wagon"]) do
            prototype.quality_affects_inventory_size = true
            prototype.inventory_size = math.floor(prototype.inventory_size * capacity_multiplier + 0.5)
        end

        for key, prototype in pairs(data.raw["fluid-wagon"]) do
            prototype.quality_affects_capacity = true
            prototype.capacity = math.floor(prototype.capacity * capacity_multiplier + 0.5)
        end
    end

    local function alter_roboports(max_quality_level)
        local recharge_rate_multiplier = 1.0 / (1.0 + ROBOPORT_RECHARGE_RATE_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        local robot_limit_multiplier = 1.0 / (1.0 + PERSONAL_ROBOPORT_ROBOT_LIMIT_INCREASE_PER_QUALITY_LEVEL * max_quality_level)
        
        for key, prototype in pairs(data.raw["roboport"]) do
            prototype.charging_energy = multiply_energy(prototype.charging_energy, recharge_rate_multiplier)
        end

        for key, prototype in pairs(data.raw["roboport-equipment"]) do
            prototype.charging_energy = multiply_energy(prototype.charging_energy, recharge_rate_multiplier)
            prototype.robot_limit = math.floor(prototype.robot_limit * robot_limit_multiplier + 0.5)
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
    alter_modules(MAX_QUALITY_LEVEL)
    alter_reactors(MAX_QUALITY_LEVEL)
    alter_wagons(MAX_QUALITY_LEVEL)
    alter_roboports(MAX_QUALITY_LEVEL)

    -- Things left as is by design
    --    - robots - because they would be too bad to be workable at all
    --    - chests - because they don't really matter anyway
    --    - military - because biters are annoying as is in SA and it will be even worse with this mod
    --    - poles - because there's no way to scale them back and are not that important anyway
    --    - health - doesn't matter
    --    - equipment grid sizes - because it's just QoL
    --    - repair packs - because whatever
    --    - train fuels - because they are in a good state, though this is controversial, may change at some point
    --    - science value - because making quality science in the base game is not a good idea
    --    - thrusters - because you need a lot anyway, may change in the future
    --    - asteroid collectors - because there's no good way to scale them back, may change in the future
    --    - exoskeletons - because it's QoL
    --    - quality modules - because they are at a good point and lowering changes would completely derail this mod
    --    - drills - no good way of scaling them, might consider a constant multiplier if they end up being way too overpowered with the SA mining productivity research
end