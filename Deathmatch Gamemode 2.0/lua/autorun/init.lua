util.AddNetworkString("Teamauswahl")
util.AddNetworkString("Zufallszahl_user")
util.AddNetworkString("Countdown_zuUser")
resource.AddWorkshop("468382515")
resource.AddWorkshop("758794428")

local DieTeams = {
    [TEAM_USA] = true,
    [TEAM_RUS] = true
}

--Spawnpunkte müssen noch gefixxt werden//
concommand.Add("Startgame", function()
    for k, plyy in pairs(player.GetAll()) do
        if table.Count(player.GetAll()) == 4 then
            plyy:changeTeam(1)
            counter_usa = 0
            counter_rus = 0
            countdown = 5
            plyy:Freeze(false)
            plyy:ChatPrint("Alle Spieler sind Da!")
            net.Start("Teamauswahl")
            net.WriteInt(math.random(1, 2), 3)
            net.Send(plyy)
        else
            plyy:ChatPrint("Es müssen 4 Spieler anwesend sein!")
        end
    end
end)

net.Receive("Zufallszahl_user", function(len, plyr)
    local sb = net.ReadInt(3)

    if sb == 1 then
        plyr:changeTeam(10, true)
        plyr:ChatPrint("Du bist im Team der US-Army!")

        if (table.Count(team.GetPlayers(10))) >= 3 then
            plyr:changeTeam(11, true)
            plyr:ChatPrint("AutoBalancing: Du bist im Team der Russen!")
        end
    end

    if sb == 2 then
        timer.Simple(0.5, function()
            plyr:changeTeam(11, true)
            plyr:ChatPrint("Du bist im Team der Russen!")

            if (table.Count(team.GetPlayers(11))) >= 3 then
                plyr:changeTeam(10, true)
                plyr:ChatPrint("AutoBalancing: Du bist im Team der US-Army!")
            end
        end)
    end

    -- Nur bestätitgung damit ich nicht changeteam überall oben machen muss
    timer.Simple(0.9, function()
        for k, v in pairs(player.GetAll()) do
            v:KillSilent()
        end
    end)
end)

hook.Add("PlayerSpawn", "WennSpeielrspawnt", function(playr)
    countdown = 5

    if DieTeams[playr:Team()] then
        playr:Freeze(true)
        net.Start("Countdown_zuUser")
        net.WriteBool(true)
        net.Send(playr)
    end

    timer.Simple(5.1, function()
        playr:Freeze(false)

        if playr:Team() == TEAM_USA then
            playr:SelectWeapon("weapon_m42")
        elseif playr:Team() == TEAM_RUS then
            playr:SelectWeapon("weapon_ak472")
        end
    end)
end)

--SilentKill hat kein effekt auf playerdeath hook
hook.Add("PlayerDeath", "WennSpielerstirbt", function(victim, inflictor, attacker)
    if victim:Team() == TEAM_RUS and attacker:Team() == TEAM_USA then
        counter_usa = counter_usa + 1

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die USA hat folgende Punkte: " .. counter_usa)
        end
    end

    if victim:Team() == TEAM_USA and attacker:Team() == TEAM_RUS then
        counter_rus = counter_rus + 1

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("Die Russen haben folgende Punkte: " .. counter_rus)
        end
    end

    if counter_usa == 3 then
        counter_usa = 0

        for k, v in pairs(player.GetAll()) do
            v:changeTeam(1)
            v:ChatPrint("Die USA Gewinnt!")
            v:StripWeapons()
        end
    end

    if counter_rus == 3 then
        counter_rus = 0

        for k, v in pairs(player.GetAll()) do
            v:changeTeam(1)
            v:ChatPrint("Die RUSSEN Gewinnen!")
            v:StripWeapons()
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
end)