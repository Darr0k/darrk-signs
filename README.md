# Dependencies

1. [ox_lib](https://github.com/overextended/ox_lib/releases) - Use the latest release. If you do not use the latest release, MAKE SURE TO BUILD THE UI. Find their docs here on how to build the UI.
2. [qb-core](https://github.com/qbcore-framework/qb-core).
3. [qb-target](https://github.com/qbcore-framework/qb-target).

# Add to qb-core/shared/items.lua
```lua
minecraft_sign = {
    name = "minecraft_sign",
    label = "Minecraft Sign",
    weight = 750,
    type = "item",
    image = "minecraft_sign.png",
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = "A Sign"
},
floor_sign = {
    name = "floor_sign",
    label = "Floor Sign",
    weight = 1000,
    type = "item",
    image = "floor_sign.png",
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = "A Metal Floor Sign"
},
```

#Add to qb-inventory/html/images

![floor_sign](https://github.com/Darr0k/darrk-signs/assets/96451713/d6cadd30-19ee-401b-bfb4-101644c3157d)
![minecraft_sign](https://github.com/Darr0k/darrk-signs/assets/96451713/24b05778-dd39-40b1-855c-00129a650839)
