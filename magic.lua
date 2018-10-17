tigris.jewelry.register("tigris_jewelry:solar_shield_amulet", {
    description = "Amulet of Solar Shield",
    image = "tigris_jewelry_amulet.png^tigris_jewelry_solar_shield.png",
    group = "amulet",

    -- Immune to sun.
    absorb = {"sun"},
    armor = {sun = 0},

    -- At damage every ~5 seconds, 720 uses will give 1 hour of sunwalking.
    uses = 720,
})

minetest.register_craft{
    output = "tigris_jewelry:solar_shield_amulet",
    recipe = {
        {"group:coal", "default:obsidian", "group:coal"},
        {"tigris_magic:mana_essence", "tigris_jewelry:amulet_base", "tigris_magic:force_essence"},
    },
}

tigris.jewelry.register("tigris_jewelry:speed_anklet", {
    description = "Anklet of Speed",
    image = "tigris_jewelry_anklet.png^tigris_jewelry_speed.png",
    group = "anklet",

    effects = {speed = 1.5, jump = 1.1},
})

minetest.register_craft{
    output = "tigris_jewelry:speed_anklet",
    recipe = {
        {"default:ice", "tigris_magic:blood_essence", "default:ice"},
        {"tigris_magic:force_essence", "tigris_jewelry:anklet_base", "tigris_magic:force_essence"},
    },
}

tigris.jewelry.register("tigris_jewelry:mana_boost_bracelet", {
    description = "Bracelet of Mana Boost",
    image = "tigris_jewelry_bracelet.png^tigris_magic_mana_icon.png",
    group = "bracelet",
    mana = {max = 1.3, regen = 1.5},
})

minetest.register_craft{
    output = "tigris_jewelry:mana_boost_bracelet",
    recipe = {
        {"tigris_magic:mana_essence", "tigris_magic:twisted_essence", "tigris_magic:mana_essence"},
        {"tigris_magic:mana_essence", "tigris_jewelry:bracelet_base", "tigris_magic:mana_essence"},
        {"tigris_magic:mana_essence", "tigris_magic:twisted_essence", "tigris_magic:mana_essence"},
    },
}
