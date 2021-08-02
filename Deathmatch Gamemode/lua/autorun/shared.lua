-->Sounds Hinzufügen
sound.Add({
    name = "speed_boi",
    channel = CHAN_STATIC,
    volume = 120.0,
    level = 100,
    pitch = {95, 110},
    sound = "weapons/enzo/running90.wav"
})

sound.Add({
    name = "countdown",
    channel = CHAN_STATIC,
    volume = 120.0,
    level = 100,
    pitch = {95, 110},
    sound = "weapons/enzo/countdown.wav"
})

counter = 0
counter_rpg = 0

--> Spawnnachricht wenn jmd Spawnt
function Spawn(ply)
    ply:ChatPrint(ply:Nick() .. " ist gespawned!")
end

hook.Add("PlayerSpawn", "Spawnmessage", Spawn)

-- !Kill und !Drop
function hallo(ply, text, team)
    if text == "!kill" then
        ply:Kill()
    end

    if text == "!startgame" then
        ply:EmitSound("countdown")
        ply:PrintMessage(HUD_PRINTCENTER, "5")

        timer.Simple(1, function()
            ply:PrintMessage(HUD_PRINTCENTER, "4")
        end)

        timer.Simple(2, function()
            ply:PrintMessage(HUD_PRINTCENTER, "3")
        end)

        timer.Simple(3, function()
            ply:PrintMessage(HUD_PRINTCENTER, "2")
        end)

        timer.Simple(4, function()
            ply:PrintMessage(HUD_PRINTCENTER, "1")
        end)

        timer.Simple(5, function()
            ply:Give("weapon_stunstick")
            ply:SelectWeapon("weapon_stunstick")
            ply:PrintMessage(HUD_PRINTCENTER, "Töte so viele wie du kannst! Du hast 30 Sekunden")
        end)

        timer.Simple(48.1, function()
            counter = 0
        end)

        timer.Simple(43.2, function()
            counter_rpg = 0
        end)
    end

    if text == "!drop" then
        ply:DropWeapon()
    end
end

hook.Add("PlayerSay", "MokLok", hallo)

--> Info über das Leben von allen Spielern
function Lebensanzeige(sender, text, teamchat)
    if text == "!life" then
        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Spieler: " .. v:GetName() .. " Leben " .. v:Health())
        end
    end
end

hook.Add("PlayerSay", "CoolesDingundso", Lebensanzeige)

--> Stunstick Equip und RPG equip
hook.Add("WeaponEquip", "WeaponEquipExample", function(wep, ply)
    if wep:GetClass() == "weapon_stunstick" then
        ply:EmitSound("speed_boi")
        ply:SetRunSpeed(1500)
        ply:SetWalkSpeed(1000)

        timer.Simple(35, function()
            ply:StripWeapon("weapon_stunstick")
            ply:PrintMessage(HUD_PRINTCENTER, "Die Zeit ist abgelaufen. Deine Kills: " .. counter)
            ply:StopSound("speed_boi")
            ply:SetRunSpeed(600)
        end)
    end

    timer.Simple(36.1, function()
        if counter >= 22 then
            ply:PrintMessage(HUD_PRINTCENTER, "Du hast Level 2 erreicht! ")
        end
    end)

    timer.Simple(38, function()
        if counter >= 22 then
            ply:EmitSound("countdown")
            ply:PrintMessage(HUD_PRINTCENTER, "5")
        end
    end)

    timer.Simple(39, function()
        if counter >= 22 then
            ply:PrintMessage(HUD_PRINTCENTER, "4")
        end
    end)

    timer.Simple(40, function()
        if counter >= 22 then
            ply:PrintMessage(HUD_PRINTCENTER, "3")
        end
    end)

    timer.Simple(41, function()
        if counter >= 22 then
            ply:PrintMessage(HUD_PRINTCENTER, "2")
        end
    end)

    timer.Simple(42, function()
        if counter >= 22 then
            ply:PrintMessage(HUD_PRINTCENTER, "1")
        end
    end)

    timer.Simple(43, function()
        if counter >= 22 then
            ply:Give("weapon_rpg")
            ply:GiveAmmo(200, "RPG_Round", false)
            ply:SelectWeapon("weapon_rpg")
            ply:PrintMessage(HUD_PRINTCENTER, "LEVEL 2")
            ply:Freeze()
        end
    end)

    if wep:GetClass() == "weapon_rpg" then
        ply:SetRunSpeed(1)
        ply:SetWalkSpeed(1)
    end
end)

return hook.Add("EntityTakeDamage", "Wenndernpcdmgbekommt", function(target, dmginfo)
    if (target:IsNPC()) then
        dmginfo:SetDamage(9000)
    end
end), hook.Add("OnNPCKilled", "Killcounter", function(npc, attacker, inflictor)
    --> Killzähler mit einem Counter
    counter = counter + 1
    counter_rpg = counter_rpg + 1

    if attacker:HasWeapon("weapon_stunstick") then
        attacker:ChatPrint("Deine Kills: " .. counter)
    end

    if attacker:HasWeapon("weapon_rpg") then
        attacker:ChatPrint("Deine Kills: " .. counter_rpg)
    end
end)