local m = {
    -- Registered jewelry.
    registered = {},
    -- Registered actions.
    actions = {},
}
jewelry = m

-- Jewelry groups.
--- max: Number of slots in that group.
m.groups = {
    amulet = {
        max = 1,
    },

    bracelet = {
        max = 2,
    },

    anklet = {
        max = 2,
    },

    eyes = {
        max = 2,
    },
}

-- Sum up the total slots.
m.slots = 0
for k,v in pairs(m.groups) do
    m.slots = m.slots + v.max
end

-- Jewelry inventory formspec.
local form = smartfs.create("jewelry", function(state)
    state:size(8, 6)

    state:inventory(0, 0, 8, 2, "jewelry")
    if state.location.type ~= "inventory" then
        state:inventory(0, 2, 8, 4, "main")
    end

    state:element("code", {name = "listring", code = "listring[current_player;jewelry]listring[current_player;main]"})
end)

-- Add to inventories.
smartfs.add_to_inventory(form, "jewelry_anklet.png", "Jewelry")

-- And fallback chatcommand.
minetest.register_chatcommand("jewelry", {
    description = "Open your jewelry inventory",
    func = function(name)
        form:show(name)
    end,
})

-- Refresh the player's jewelry effects.
function m.refresh(player)
    local list = player:get_inventory():get_list("jewelry")

    -- Initialize refresh state.
    local state = {}
    for k,v in pairs(m.actions) do
        v.init(state)
    end

    -- For all jewelry...
    for _,v in ipairs(list) do
        if v:get_count() > 0 then
            local r = m.registered[v:get_name()]
            -- Add actions to state.
            for k,v in pairs(m.actions) do
                v.add(state, r)
            end
        end
    end

    -- Apply new state to player.
    for k,v in pairs(m.actions) do
        v.apply(state, player)
    end
end

-- Multiplication of uses upon death.
local die_uses = tonumber(minetest.settings:get("jewelry.die_uses")) or 25

-- If damage enabled, wear upon being hit.
if minetest.settings:get_bool("jewelry.damage", true) then
    local old = tigris.damage.player_damage_callback
    tigris.damage.player_damage_callback = function(player, damage, blame)
        -- Copied groups for absorbing.
        local g = table.copy(damage.groups)
        local list = player:get_inventory():get_list("jewelry")
        -- List of indexes to wear down.
        local wear = {}

        -- For all jewelry...
        for i,v in ipairs(list) do
            if v:get_count() > 0 then
                local r = m.registered[v:get_name()]

                -- Check absorbing.
                local match = false
                for _,v in ipairs(r.absorb) do
                    if damage.groups[v] and damage.groups[v] > 0 then
                        -- Remove absorbed group from list.
                        g[v] = nil
                        match = true
                    end
                end

                -- If absorbed anything, add to the wear pile.
                if match then
                    wear[i] = 65535 / r.uses
                end
            end
        end

        -- Check if there's actually any damage left after absorbing.
        local g_has = false
        for k in pairs(g) do
            g_has = true
            break
        end

        for i,v in ipairs(list) do
            if v:get_count() > 0 then
                local r = m.registered[v:get_name()]
                -- Even wear_on_all only applies when there's actually damage.
                local match = (r.wear_on_all and g_has)
                -- Check for specific wear types.
                for _,v in ipairs(r.wear_on) do
                    if g[v] and g[v] > 0 then
                        match = true
                    end
                end
                -- If found a match, then add to wear pile.
                if match then
                    wear[i] = 65535 / r.uses
                end
            end
        end

        -- Apply wear.
        for i,v in pairs(wear) do
            list[i]:add_wear(v)
        end
        player:get_inventory():set_list("jewelry", list)

        m.refresh(player)
        return old(player, damage, blame)
    end

    -- On death, apply wear * die_uses.
    minetest.register_on_dieplayer(function(player)
        local list = player:get_inventory():get_list("jewelry")
        for i,v in ipairs(list) do
            local r = m.registered[v:get_name()]
            if r then
                v:add_wear(65535 / r.uses * die_uses)
            end
        end
        player:get_inventory():set_list("jewelry", list)
    end)
end

minetest.register_on_joinplayer(function(player)
    -- Initialize jewelry list.
    player:get_inventory():set_size("jewelry", m.slots)

    -- Clear out unknown jewelry.
    local list = player:get_inventory():get_list("jewelry")
    for i,v in ipairs(list) do
        if not m.registered[v:get_name()] then
            v:set_count(0)
        end
    end
    player:get_inventory():set_list("jewelry", list)

    -- And built initial state.
    m.refresh(player)
end)

-- On jewelry inventory actions, refresh state.
minetest.register_on_player_inventory_action(function(player, action, inv, info)
    if (action == "move" and (info.to_list == "jewelry" or info.from_list == "jewelry")) or (action == "put" and info.listname == "jewelry") then
        m.refresh(player)
    end
end)

minetest.register_allow_player_inventory_action(function(player, action, inv, info)
    local stack
    -- If moving to jewelry, build stack from lists.
    if action == "move" and info.to_list == "jewelry" and info.from_list ~= "jewelry" then
        stack = ItemStack(player:get_inventory():get_list(info.from_list)[info.from_index])
        stack:set_count(info.count)
    -- If putting, stack is provided.
    elseif action == "put" and info.listname == "jewelry" then
        stack = info.stack
    -- Otherwise we don't need to worry about this.
    else
        return nil
    end

    -- Invalid items can't be inserted.
    if not m.registered[stack:get_name()] then
        return 0
    end

    -- Get current total of the item's group.
    local current = player:get_inventory():get_list("jewelry")
    local group = m.registered[stack:get_name()].group
    local ctotal = 0
    for _,v in ipairs(current) do
        if v:get_count() > 0 then
            if m.registered[v:get_name()].group == group then
                ctotal = ctotal + v:get_count()
            end
        end
    end

    -- If we're already at the max, don't allow it.
    if ctotal >= m.groups[group].max then
        return 0
    end

    return nil
end)

function m.register(name, d)
    local rname = name
    name = name:gsub("^:", "")
    if not d.base then
        m.registered[name] = d
    end

    d.uses = d.uses or 300
    d.absorb = d.absorb or {}
    d.wear_on_all = d.wear_on_all or false
    d.wear_on = d.wear_on or {}

    (d.base and minetest.register_craftitem or minetest.register_tool)(rname, {
        description = d.description,
        groups = {jewelry = 1, ["jewelry_" .. d.group] = 1},
        inventory_image = d.image,
        _doc_items_longdesc = d.longdesc,
        _doc_items_durability = (not d.base) and d.uses or nil,
    })
end

function m.register_action(name, d)
    m.actions[name] = d
end

tigris.include("base.lua")
tigris.include("actions.lua")
