util.AddNetworkString("Teamauswahl")
util.AddNetworkString("Zufallszahl_user")
util.AddNetworkString("Countdown_zuUser")
util.AddNetworkString("Klassenoeffnen")
util.AddNetworkString("Teamreset")
util.AddNetworkString("client_Teamauswahl")
util.AddNetworkString("waffengeben")
util.AddNetworkString("allelogs")
util.AddNetworkString("farbenimlog")
util.AddNetworkString("Countdown_server")
util.AddNetworkString("Deathdaten")
resource.AddWorkshop("468382515")
resource.AddWorkshop("758794428")
resource.AddWorkshop("248302805")
resource.AddFile("materials/Bilder/gruenerhaken.png")
resource.AddFile("materials/Bilder/los.png")
resource.AddFile("materials/Bilder/losbanner.png")
include("shared.lua")

local DieTeams = {
    [TEAM_USA] = true,
    [TEAM_RUS] = true
}

--Spawnpunkte müssen noch gefixxt werden//
net.Receive("client_Teamauswahl", function(len, ply)
    local rb = net.ReadInt(3)

    if rb == 2 and ply:IsSuperAdmin() then
        for k, plyy in pairs(player.GetAll()) do
            plyy:changeTeam(1)
            counter_usa = 0
            counter_rus = 0
            countdown = 11
            plyy:Freeze(false)
            plyy:ChatPrint("Alle Spieler sind Da!")
            net.Start("Teamauswahl")
            net.WriteInt(math.random(1, 2), 3)
            net.Send(plyy)
        end
    else
        ply:ChatPrint("Du hast nicht die Rechte dafür")
    end
end)

net.Receive("Zufallszahl_user", function(len, plyr)
    local sb = net.ReadInt(3)

    --AutoBalancing
    if sb == 1 then
        plyr:changeTeam(TEAM_USA, true)
        plyr:ChatPrint("Du bist im Team der US-Army!")

        -- Beliebige Spieleranzahl
        if (#team.GetPlayers(TEAM_USA)) > (#team.GetPlayers(TEAM_RUS)) then
            plyr:changeTeam(TEAM_RUS, true)
            plyr:ChatPrint("AutoBalancing: Du bist im Team der Russen!")
        end
    elseif sb == 2 then
        timer.Simple(0.5, function()
            plyr:changeTeam(TEAM_RUS, true)
            plyr:ChatPrint("Du bist im Team der Russen!")

            if (#team.GetPlayers(TEAM_RUS)) > (#team.GetPlayers(TEAM_USA)) then
                plyr:changeTeam(TEAM_USA, true)
                plyr:ChatPrint("AutoBalancing: Du bist im Team der US-Army!")
            end
        end)
    end

    timer.Simple(0.9, function()
        for k, v in pairs(player.GetAll()) do
            v:KillSilent()
        end
    end)
end)

net.Receive("Teamreset", function(len, plyr)
    local u = net.ReadInt(3)

    if u == 1 and plyr:IsSuperAdmin() then
        for k, v in pairs(player.GetAll()) do
            v:changeTeam(1)
            v:StripWeapons()
        end
    end
end)

hook.Add("PlayerSpawn", "WennSpeielerspawnt", function(playr)
    if DieTeams[playr:Team()] then
        playr:Freeze(true)
        playr:StripWeapons()
        playr:ChatPrint("Warte bis die Runde vorbei ist")
        net.Start("Countdown_zuUser")
        net.WriteBool(true)
        net.Send(playr)
    end
end)

net.Receive("Countdown_server", function(len, playr)
    local countdown_freeze = net.ReadInt(3)

    if countdown_freeze == 0 then
        playr:Freeze(false)
    end
end)

--SilentKill hat kein effekt auf playerdeath hook
hook.Add("PlayerDeath", "WennSpielerstirbt", function(victim, inflictor, attacker)
    local Timestamp = os.time()
    local TimeString = os.date("[%d.%m.%Y - %H:%M:%S]", Timestamp)

    -- Checken, dass dich der Spieler nicht selber tötet
    if (victim ~= attacker) then
        net.Start("Deathdaten")
        net.WriteString(victim:Name())
        net.WriteString(attacker:Name())
        net.WriteString(attacker:GetActiveWeapon():GetClass())
        net.WriteString(TimeString)
        net.Broadcast()
        file.Append("degahtest/kills.txt", "\n" .. TimeString .. " " .. victim:Name() .. " wurde getötet von: " .. attacker:Name())
    else
        nachricht = victim:Name() .. "Hat sich selber getötet"
    end

    if victim:Team() == TEAM_RUS and attacker:Team() == TEAM_USA then
        counter_usa = counter_usa + 1
        victim:KillSilent()
        victim:Freeze(true)
        victim:ChatPrint("Du bist gestorben! Warte bis die Runde vorbei ist.")

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die USA hat folgende Punkte: " .. counter_usa)
        end
    end

    if victim:Team() == TEAM_USA and attacker:Team() == TEAM_RUS then
        counter_rus = counter_rus + 1
        victim:KillSilent()
        victim:Freeze(true)
        victim:ChatPrint("Du bist gestorben! Warte bis die Runde vorbei ist.")

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die Russen haben folgende Punkte: " .. counter_rus)
        end
    end

    -- Sobald alle Spieler von einem Spieltot sind
    if counter_usa == (#team.GetPlayers(TEAM_RUS)) then
        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die USA Gewinnt!")
            v:StripWeapons()
            v:SetRunSpeed(600)
            v:SetWalkSpeed(600)
            v:KillSilent()

            -- Muss eine sekunde warten damit der table count nicht behindert wird
            timer.Simple(1, function()
                v:Freeze(false)
                v:changeTeam(1)
            end)
        end
    end

    if counter_rus == (#team.GetPlayers(TEAM_USA)) then
        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die RUSSEN Gewinnen!")
            v:StripWeapons()
            v:SetRunSpeed(600)
            v:SetWalkSpeed(600)
            v:KillSilent()

            timer.Simple(1, function()
                v:Freeze(false)
                v:changeTeam(1)
            end)
        end
    end
end)

hook.Add("PlayerSay", "WennSpielersagt", function(sender, text)
    if text == "!kill" then
        sender:Kill()

        return ""
    end

    if text == "!resetteams" and sender:IsSuperAdmin() then
        for k, v in pairs(player.GetAll()) do
            v:changeTeam(1)
        end

        return ""
    end

    if text == "!a" and sender:IsSuperAdmin() then
        net.Start("Klassenoeffnen")
        net.Send(sender)

        return ""
    end

    if text == "!allelogs" and sender:IsSuperAdmin() then
        net.Start("allelogs")
        net.Send(sender)

        return ""
    end
end)

net.Receive("waffengeben", function(len, plyr)
    local Timestamp = os.time()
    local TimeString = os.date("[%d.%m.%Y - %H:%M:%S]", Timestamp)
    local l = net.ReadInt(3)
    spielername = net.ReadString()
    local waffenklasse = Klassenauswahl.klassen[l] -- Key des Tables
    if not waffenklasse then return end -- Damit wird es nur ausgeführt, wenn auch wirklich der Client eine von den Nummern sendet und keine beliebige
    plyr:Give(waffenklasse.klasse)
    plyr:GiveAmmo(90, waffenklasse.ammo)
    plyr:SelectWeapon(waffenklasse.klasse)
    plyr:ChatPrint("Du bist ein " .. waffenklasse.name)
    file.Append("degahtest/klassen.txt", "\n" .. TimeString .. " " .. spielername .. " ist in der Klasse: " .. waffenklasse.name)
    net.Start("farbenimlog")
    net.WriteString(waffenklasse.name)
    net.Broadcast() -- Damit ich in den Logs jeden spieler anzeigen lassen kann
end)