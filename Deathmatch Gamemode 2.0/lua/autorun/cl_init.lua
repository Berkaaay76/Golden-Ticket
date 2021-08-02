include("init.lua")

sound.Add({
    name = "countdown",
    channel = CHAN_STATIC,
    volume = 120.0,
    level = 100,
    pitch = {95, 110},
    sound = "weapons/enzo/countdown_sound.wav"
})

net.Receive("Teamauswahl", function(len)
    local s = net.ReadInt(3)
    print("Der Client hat folgende Nachricht erhalten: " .. s)
    net.Start("Zufallszahl_user")
    net.WriteInt(s, 3)
    net.SendToServer()
end)

net.Receive("Countdown_zuUser", function(len)
    countdown = 5
    local r = net.ReadBool()

    if r == true then
        LocalPlayer():EmitSound("countdown")

        timer.Create("Countdown", 1, 5, function()
            LocalPlayer():Freeze(true)
            countdown = countdown - 1
            LocalPlayer():ChatPrint("Du kannst dich wieder bewegen in: " .. countdown)
        end)
    end
end)