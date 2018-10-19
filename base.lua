jewelry.register("jewelry:amulet_base", {
    description = "Amulet Base",
    image = "jewelry_amulet.png",
    group = "amulet",
    base = true,
})

jewelry.register("jewelry:bracelet_base", {
    description = "Bracelet Base",
    image = "jewelry_bracelet.png",
    group = "bracelet",
    base = true,
})

jewelry.register("jewelry:anklet_base", {
    description = "Anklet Base",
    image = "jewelry_anklet.png",
    group = "anklet",
    base = true,
})

jewelry.register("jewelry:glasses_base", {
    description = "Glasses Base",
    image = "jewelry_glasses.png",
    group = "glasses",
    base = true,
})

local steel = "default:steel_ingot"

minetest.register_craft{
    output = "jewelry:amulet_base",
    recipe = {
        {steel, "", steel},
        {"", steel, ""},
        {"", steel, ""},
    },
}

minetest.register_craft{
    output = "jewelry:bracelet_base",
    recipe = {
        {steel, "", steel},
        {"", "", ""},
        {steel, "", steel},
    },
}

minetest.register_craft{
    output = "jewelry:anklet_base",
    recipe = {
        {"", steel, ""},
        {steel, "", steel},
        {"", steel, ""},
    },
}

minetest.register_craft{
    output = "jewelry:glasses_base",
    recipe = {
        {steel, "", steel},
        {"default:glass", steel, "default:glass"},
    },
}
