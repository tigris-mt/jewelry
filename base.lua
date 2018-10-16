tigris.jewelry.register("tigris_jewelry:amulet_base", {
    description = "Amulet Base",
    image = "tigris_jewelry_amulet.png",
    group = "amulet",
})

tigris.jewelry.register("tigris_jewelry:bracelet_base", {
    description = "Bracelet Base",
    image = "tigris_jewelry_bracelet.png",
    group = "bracelet",
})

tigris.jewelry.register("tigris_jewelry:anklet_base", {
    description = "Anklet Base",
    image = "tigris_jewelry_anklet.png",
    group = "anklet",
})

minetest.register_craft{
    output = "tigris_jewelry:amulet_base",
    recipe = {
        {"default:steel_ingot", "", "default:steel_ingot"},
        {"", "default:steel_ingot", ""},
        {"", "default:steel_ingot", ""},
    },
}

minetest.register_craft{
    output = "tigris_jewelry:bracelet_base",
    recipe = {
        {"default:steel_ingot", "", "default:steel_ingot"},
        {"", "", ""},
        {"default:steel_ingot", "", "default:steel_ingot"},
    },
}

minetest.register_craft{
    output = "tigris_jewelry:anklet_base",
    recipe = {
        {"", "default:steel_ingot", ""},
        {"default:steel_ingot", "", "default:steel_ingot"},
        {"", "default:steel_ingot", ""},
    },
}
