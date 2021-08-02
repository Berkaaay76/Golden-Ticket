Klassenauswahl = Klassenauswahl or {}

Klassenauswahl.Farben = {
    ["Hintergrundfarbe"] = Color(47, 49, 54, 255),
    ["textfarbe"] = Color(255, 255, 255),
    ["adminpanel"] = Color(68, 73, 84, 255),
    ["scrollpanels"] = Color(61, 66, 77),
    ["textfarbe_Rot"] = Color(255, 0, 0),
    ["Transparent"] = Color(255, 255, 255, 0),
    ["textfarbe_gruen"] = Color(76, 123, 49),
    ["textfarbe_blau"] = Color(0, 0, 255)
}

Klassenauswahl.klassen = {
    {
        name = "Sniper", -- [1]
        klasse = "ls_sniper",
        ammo = "SMG1",
        description = "Die Klasse des Snipers",
        waffe = "Scharfschützengewehr"
    },
    {
        name = "Sturmsoldat", -- [2]
        klasse = "weapon_m42",
        ammo = "SMG1",
        description = "Die Klasse des Sturmsoldaten",
        waffe = "Sturmgewehr"
    },
    {
        name = "Nahkämpfer", -- [3]
        klasse = "weapon_pumpshotgun2",
        ammo = "Buckshot",
        description = "Die Klasse des Nahkämpfers",
        waffe = "Shotgun"
    },
}