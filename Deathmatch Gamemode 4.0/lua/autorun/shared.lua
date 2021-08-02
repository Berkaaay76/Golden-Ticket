Klassenauswahl = Klassenauswahl or {}
meinelogs = meinelogs or {}
fileread = file.Open("degahtest/klassen.txt", "r", "DATA")
alleslesen = fileread:Read(fileread:Size())
damage_logs = {} --Liste die alle damagelogs drin speichert
death_logs = death_logs or {}
PrintTable(death_logs)

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
        name = "Deagleman", -- [1]
        klasse = "weapon_deagle2",
        ammo = "pistol",
        description = "Die Klasse des Deaglemans",
        waffe = "Deagle"
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
--[[death_logs{
			1 	{
					opfer = "Mok",
					killer = "Lok",
					waffe = "gun",
					Zeit = *aktuelle Zeit*
				},
			2 	{
					opfer = "Mok"
					killer = "Lok"
					waffe = "gun"
					Zeit = *aktuelle Zeit*
				}
			
		}]]