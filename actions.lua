jewelry.register_action("armor", {
    init = function(state)
        state.armor = {}
    end,

    add = function(state, r)
        for k,v in pairs(r.armor or {}) do
            state.armor[k] = (state.armor[k] or 1) * v
        end
    end,

    apply = function(state, player)
        armor_monoid.monoid:add_change(player, state.armor, "jewelry:armor")
    end,
})

jewelry.register_action("effects", {
    init = function(state)
        state.effects = {
            speed = 1,
            gravity = 1,
            jump = 1,
        }
    end,

    add = function(state, r)
        for k,v in pairs(r.effects or {}) do
            assert(state.effects[k])
            state.effects[k] = state.effects[k] * v
        end
    end,

    apply = function(state, player)
        player_monoids.gravity:add_change(player, state.effects.gravity, "jewelry:gravity")
        player_monoids.speed:add_change(player, state.effects.speed, "jewelry:speed")
        player_monoids.jump:add_change(player, state.effects.jump, "jewelry:jump")
    end,
})
