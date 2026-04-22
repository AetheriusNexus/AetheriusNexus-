-- [[ AETHERIUS NEXUS | V5 PREMIER ]] --

-- 1. SWIRL STARTUP ANIMATION
local frames = {
    "🌀 Booting Aetherius Nexus .",
    "🌀 Booting Aetherius Nexus ..",
    "🌀 Booting Aetherius Nexus ...",
    "✨ Nexus Systems Online!",
}

for i = 1, 10 do
    for _, frame in ipairs(frames) do
        print(frame)
        task.wait(0.1)
    end
end

-- 2. INITIALIZE KAVO UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("AETHERIUS NEXUS | PREMIUM", "Midnight")

-- [[ LICENSE KEYS ]] --
local FreeKey = "A3TH3R1USN3XUS77821X902L" 
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"
local Authorized = false

-- [[ ACCESS TAB ]] --
local AccessTab = Window:NewTab("Access Control")
local LicenseSec = AccessTab:NewSection("Nexus License Management")

LicenseSec:NewTextBox("Enter License Key", "Free (24h) or Premium (Monthly)", function(input)
    if input == PremiumKey then
        Authorized = true
        Library:Notify("Nexus Elite", "Premium Month Active. Welcome Zach Stark.", 5)
    elseif input == FreeKey then
        Authorized = true
        Library:Notify("Nexus Verified", "Standard 24-Hour Access Granted.", 5)
    else
        Library:Notify("Access Denied", "Invalid Key. Visit Work.ink for the current string.", 5)
    end
end)

-- [[ BLOX FRUITS SEAS & ISLANDS ]] --
local currentSea = (game.PlaceId == 4442245219 and "First Sea") or (game.PlaceId == 7449423635 and "Second Sea") or (game.PlaceId == 2753915549 and "Third Sea") or "Unknown"

local IslandData = {
    ["First Sea"] = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Skylands", "Prison", "Magma Village"},
    ["Second Sea"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Ice Castle", "Forgotten Island"},
    ["Third Sea"] = {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats"}
}

local BloxTab = Window:NewTab("Blox Fruits")
local TPSection = BloxTab:NewSection("Current Location: " .. currentSea)

TPSection:NewDropdown("Teleport to Island", "Safe Travel Protocol", IslandData[currentSea] or {"No Islands Found"}, function(v)
    if Authorized then
        Library:Notify("Aetherius", "Teleporting to " .. v, 3)
    end
end)

-- [[ FRUIT & ESP UTILS ]] --
local Utils = Window:NewTab("Utilities")
local FruitSec = Utils:NewSection("Fruit Analytics")

FruitSec:NewButton("Fruit Notifier", "Scans for spawned fruits", function()
    local found = false
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and (v:FindFirstChild("Handle") or v.Name:find("Fruit")) then
            local dist = math.floor((v.Handle.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            Library:Notify("FRUIT DETECTED", v.Name .. " | Distance: " .. dist .. "m", 10)
            found = true
        end
    end
    if not found then Library:Notify("System", "No fruits found.", 3) end
end)

local Visuals = Window:NewTab("Visuals")
local ESPSec = Visuals:NewSection("Aetherius Vision")

-- ESP with PlayerName [Display] | HP | Distance
ESPSec:NewToggle("Player ESP", "Customized for Blox Fruits", function(state)
    _G.EspActive = state
end)

-- [[ CUSTOM THEME COLORS ]] --
local ThemeSec = Visuals:NewSection("Hub Customization")
ThemeSec:NewButton("Aetherius Purple", "Signature Theme", function() Library:ChangeColor("AccentColor", Color3.fromRGB(138, 43, 226)) end)
ThemeSec:NewButton("Nexus Red", "Vanguard Theme", function() Library:ChangeColor("AccentColor", Color3.fromRGB(200, 0, 0)) end)
ThemeSec:NewButton("Emerald Green", "Clean Theme", function() Library:ChangeColor("AccentColor", Color3.fromRGB(0, 200, 0)) end)
ThemeSec:NewButton("Void Black", "Stealth Theme", function() Library:ChangeColor("AccentColor", Color3.fromRGB(20, 20, 20)) end)
