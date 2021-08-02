include("init.lua")
include("shared.lua")

surface.CreateFont("font_oberflaeche", {
    font = "Roboto",
    extended = false,
    size = 17,
    weight = 500,
})

surface.CreateFont("font_ueberschrift", {
    font = "Roboto",
    extended = false,
    size = 20,
    weight = 500,
})

surface.CreateFont("font_adminpanel", {
    font = "Roboto",
    extended = false,
    size = 13.5,
    weight = 500,
})

surface.CreateFont("font_auswaehlen", {
    font = "Roboto",
    extended = false,
    size = 14,
    weight = 500,
})

surface.CreateFont("font_klassen", {
    font = "Roboto",
    extended = false,
    size = 18,
    weight = 500,
})

surface.CreateFont("font_klassen_desc", {
    font = "Roboto",
    extended = false,
    size = 14,
    weight = 500,
})

function Klassenauswahl.Open()
    local Bildschirmbreite = ScrW()
    local Bildschirmhoehe = ScrH()
    Klassenauswahl.Oberflaeche = vgui.Create("DFrame")
    Klassenauswahl.Oberflaeche:SetSize(Bildschirmbreite * 0.4, Bildschirmhoehe * 0.5)
    Klassenauswahl.Oberflaeche:MakePopup()
    Klassenauswahl.Oberflaeche:Center()
    Klassenauswahl.Oberflaeche:SetTitle("")
    Klassenauswahl.Oberflaeche:DockMargin(20, 20, 20, 20)
    Klassenauswahl.Oberflaeche:SetIcon("materials/Bilder/los.png")
    Klassenauswahl.Oberflaeche:SetDraggable(false)
    --Klassenauswahl.Oberflaeche:ShowCloseButton(false)
    local MenuHoehe = Klassenauswahl.Oberflaeche:GetTall() -- Damit es auf verschiedenen resolutions auch gleich bleibt
    local MenuBreite = Klassenauswahl.Oberflaeche:GetWide()
    local Abstandlinks_Bild = MenuBreite * 0.35
    local Abstandoben_Bild = MenuHoehe * 0.02
    local losbild = vgui.Create("DImage", Klassenauswahl.Oberflaeche)
    losbild:SetTall(MenuHoehe * 0.08) -- Hoehe und Breite auf das Menu bezogen damit es bei jedem gleich aussieht
    losbild:SetWide(MenuBreite * 0.33)
    losbild:SetPos(Abstandlinks_Bild, Abstandoben_Bild) -- Abstand aufbauen um es mittig zu stellen
    losbild:SetImage("materials/Bilder/losbanner.png")

    Klassenauswahl.Oberflaeche.Paint = function(me, w, h)
        surface.SetDrawColor(Klassenauswahl.Farben["Hintergrundfarbe"]) --Kündigt quasi ein rechteck an
        surface.DrawRect(0, 0, w, h) -- Rechteck gefüllt
        draw.SimpleText("Wähle deine Klasse: ", "font_ueberschrift", w * 0.07, h * 0.15, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Admin Only: ", "font_oberflaeche", w * 0.73, h * 0.101, Klassenauswahl.Farben["textfarbe_Rot"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        if LocalPlayer():Team() == TEAM_USA then
            draw.SimpleText("Du bist im Team der US-ARMY", "font_auswaehlen", w * 0.07, h * 0.2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        if LocalPlayer():Team() == TEAM_RUS then
            draw.SimpleText("Du bist im Team der RUSSEN", "font_auswaehlen", w * 0.07, h * 0.2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    local Abstandlinks_Button1 = MenuBreite * 0.85
    local Abstandoben_Button1 = MenuHoehe * 0.1
    local adminpanel_begin = vgui.Create("DButton", Klassenauswahl.Oberflaeche)
    adminpanel_begin:SetPos(Abstandlinks_Button1, Abstandoben_Button1)
    adminpanel_begin:SetText("")
    adminpanel_begin:SetWide(Bildschirmbreite * .05)

    adminpanel_begin.Paint = function(me, w, h)
        surface.SetDrawColor(Klassenauswahl.Farben["adminpanel"])
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Beginne Spiel", "font_adminpanel", w / 2, h / 2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    adminpanel_begin.DoClick = function()
        if LocalPlayer():IsSuperAdmin() then
            net.Start("client_Teamauswahl")
            net.WriteInt(2, 3)
            net.SendToServer()
            Klassenauswahl.Oberflaeche:Close()
        else
            LocalPlayer():ChatPrint("Du hast keine Rechte dafür")
        end
    end

    local Abstandlinks_Button2 = MenuBreite * 0.85
    local Abstandoben_Button2 = MenuHoehe * 0.15
    local adminpanel_reset = vgui.Create("DButton", Klassenauswahl.Oberflaeche)
    adminpanel_reset:SetPos(Abstandlinks_Button2, Abstandoben_Button2)
    adminpanel_reset:SetText("")
    adminpanel_reset:SetWide(Bildschirmbreite * .05)

    adminpanel_reset.Paint = function(me, w, h)
        surface.SetDrawColor(Klassenauswahl.Farben["adminpanel"])
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Reset Teams", "font_adminpanel", w / 2, h / 2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    adminpanel_reset.DoClick = function()
        if LocalPlayer():IsSuperAdmin() then
            Klassenauswahl.Oberflaeche:Close()
            net.Start("Teamreset")
            net.WriteInt(1, 3)
            net.SendToServer()
        else
            LocalPlayer():ChatPrint("Du hast keine Rechte dafür")
        end
    end

    local Abstandlinks_Button3 = MenuBreite * 0.85
    local Abstandoben_Button3 = MenuHoehe * 0.2
    local adminpanel_logs = vgui.Create("DButton", Klassenauswahl.Oberflaeche)
    adminpanel_logs:SetPos(Abstandlinks_Button3, Abstandoben_Button3)
    adminpanel_logs:SetText("")
    adminpanel_logs:SetWide(Bildschirmbreite * .05)

    adminpanel_logs.Paint = function(me, w, h)
        surface.SetDrawColor(Klassenauswahl.Farben["adminpanel"])
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Logs", "font_adminpanel", w / 2, h / 2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    net.Receive("farbenimlog", function()
        spielerdergereadetwurde = net.ReadString() -- Ich brauche den Spieler der drauf geklickt hat
        klassedesusers = net.ReadString()
    end)

    adminpanel_logs.DoClick = function()
        if LocalPlayer():IsSuperAdmin() then
            local f = file.Open("degahtest/klassen.txt", "r", "DATA")
            chat.AddText(Klassenauswahl.Farben["textfarbe_Rot"], f:Read(24), Klassenauswahl.Farben["textfarbe_gruen"], spielerdergereadetwurde, Klassenauswahl.Farben["textfarbe"], " ist in der Klasse: ", Klassenauswahl.Farben["textfarbe_blau"], klassedesusers)
        else
            LocalPlayer():ChatPrint("Du hast keine Rechte dafür")
        end
    end

    local scroll = vgui.Create("DScrollPanel", Klassenauswahl.Oberflaeche)
    local scrollhoehe = Klassenauswahl.Oberflaeche:GetTall()
    local abstand_scroll = scrollhoehe * 0.2 --Abstand zur oberen Vguis
    scroll:DockMargin(0, abstand_scroll, 0, 0) -- Damit alles normal angezeigt wird und nicht in einem scrollmenu , ausführung des abstands
    scroll:Dock(FILL)

    for key, klassendata in pairs(Klassenauswahl.klassen) do
        local klassenanzeige = vgui.Create("DPanel", scroll) -- Vgui create muss in den loop damit der gesamte Table ausgeprintet wird.
        klassenanzeige:DockMargin(30, 0, 30, 20) -- Abstand zwischen den Klassen
        klassenanzeige:SetTall(100) -- Größe der DPanel Box
        klassenanzeige:Dock(TOP) -- Platzierung

        klassenanzeige.Paint = function(me, w, h)
            surface.SetDrawColor(Klassenauswahl.Farben["scrollpanels"])
            surface.DrawRect(6, 6, 780, 900) -- Füllung des Panels mit der Farbe
            draw.SimpleText(klassendata.name, "font_klassen", w * 0.02, h * 0.2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(klassendata.description, "font_klassen_desc", w * 0.02, h * 0.4, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(klassendata.waffe, "font_klassen_desc", w * 0.02, h * 0.85, Klassenauswahl.Farben["textfarbe_gruen"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local PanelMenuHoehe = klassenanzeige:GetTall() -- Damit es auf verschiedenen resolutions auch gleich bleibt
        local PanelMenuBreite = klassenanzeige:GetWide()
        local Abstandlinks_Button_waffen = PanelMenuBreite * 9
        local Abstandoben_Button_waffen = PanelMenuHoehe * 0.38
        local Button_waffen = vgui.Create("DButton", klassenanzeige)
        Button_waffen:SetText("")
        Button_waffen:SetWide(Bildschirmbreite * .05)
        Button_waffen:SetTall(Bildschirmhoehe * .03)
        Button_waffen:SetPos(Abstandlinks_Button_waffen, Abstandoben_Button_waffen)

        Button_waffen.Paint = function(me, w, h)
            surface.SetDrawColor(Klassenauswahl.Farben["textfarbe_gruen"])
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText("Auswählen", "font_auswaehlen", w / 2, h / 2, Klassenauswahl.Farben["textfarbe"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        Button_waffen.DoClick = function()
            net.Start("waffengeben")
            net.WriteInt(key, 3) -- (weil ich in ein Table reinloope)Dem Client werden die Keys vom Table gesendet. 1.Button = [1] = Sniper, 2.Button = [2] = Sturmsoldat, 3. Button = [3] = Shotgun
            net.WriteString(LocalPlayer():Name())
            net.SendToServer()
            Klassenauswahl.Oberflaeche:Close()
        end
    end
end

net.Receive("Klassenoeffnen", function(len)
    Klassenauswahl.Open()
end)

net.Receive("Teamauswahl", function(len)
    local s = net.ReadInt(3)
    print("Der Client hat folgende Nachricht erhalten: " .. s)
    net.Start("Zufallszahl_user")
    net.WriteInt(s, 3)
    net.SendToServer()
end)

net.Receive("Countdown_zuUser", function(len)
    countdown = 11
    local r = net.ReadBool()

    if (r) then
        LocalPlayer():ChatPrint("Wähle eine Klasse aus. Du hast 10 Sekunden Zeit!")
        Klassenauswahl.Open()

        timer.Create("Countdown", 1, 11, function()
            countdown = countdown - 1
            LocalPlayer():ChatPrint(countdown)
        end)
    end
end)

hook.Add("Initialize", "Dateiencreate", function()
    if not file.Exists("degahtest", "DATA") then
        file.CreateDir("degahtest")
        file.Write("degahtest/klassen.txt")
        file.Write("degahtest/kills.txt")
    end
end)

net.Receive("Killlogs", function()
    local f = file.Open("degahtest/kills.txt", "r", "DATA")
    chat.AddText(f:Read(f:Size()))
end)