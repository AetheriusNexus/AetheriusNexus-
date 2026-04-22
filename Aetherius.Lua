-- [[ AETHERIUS NEXUS | V6 ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Initializing with Aetherius Signature Purple
local Window = Library.CreateLib("AETHERIUS NEXUS | V6", "Midnight")
Library:ChangeColor("AccentColor", Color3.fromRGB(150, 0, 255))

-- [[ AUTHENTICATION CONFIG ]] --
local FreeKey = "A3TH3R1USN3XUS77821X902L"
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"
local Authorized = false
local IsPremium = false

-- [[ STARTUP SWIRL ]] --
print([[
    .---.  .---. .---. .---. .---. .---. .---. 
   /  _  \/  ___/|  ___/|  _  \/  _  \/  ___/
   |  _  ||  ___/|  ___/|  _  <|  _  |\___ \ 
   \__|__/\_____/\_____/\_| \_/\__|__/\____/ 
   B O O T I N G   N E X U S . . .
]])

-- [[ ACCESS CONTROL TAB ]] --
local AccessTab = Window:NewTab("License")
local LicenseSec = AccessTab:NewSection("License Verification")

-- Key Input
local inputKey = ""
LicenseSec:NewTextBox("Enter License Key", "Paste Key Here", function(txt)
    inputKey = txt
end)

-- SUBMIT BUTTON (For Mobile Users)
LicenseSec:NewButton("Submit Key", "Verify your license now", function()
    if inputKey == PremiumKey then
        Authorized, IsPremium = true, true
        Library:Notify("Nexus Elite", "Premium Month Active. Welcome Zach Stark.", 5)
    elseif inputKey == FreeKey then
        Authorized, IsPremium = true, false
        Library:Notify("Nexus Verified", "Standard 24-Hour Access Active.", 5)
    else
        Library:Notify("Security Alert", "Invalid Key. Redownload from Work.ink", 5)
    end
end)

LicenseSec:NewButton("Get Free Key (Link)", "Copies Work.ink to clipboard", function()
    setclipboard("https://work.ink/2qAU/759e261b-b989-45ef-a683-d6a35b4e2e30")
    Library:Notify("System", "Work.ink Link Copied!", 3)
end)

-- PREMIUM SECTION
local PremSec = AccessTab:NewSection("Aetherius Premium")
PremSec:NewLabel("Unlock All Features & No Ads")
PremSec:NewButton("Purchase Premium Key", "Buy via Sellix / PayPal", function()
    -- Professional strategy: Point this to a Discord or Sellix link
    setclipboard("https://sellix.io/AetheriusNexus") 
    Library:Notify("Store", "Purchase Link Copied to Clipboard!", 5)
end)

-- [[ BLOX FRUITS SECTIONS ]] --
local BloxTab = Window:NewTab("Blox Fruits")
local SeaSec = BloxTab:NewSection("Dynamic Sea Analytics")

-- Auto-Sea Detection
local currentSea = (game.PlaceId == 4442245219 and "First Sea") or (game.PlaceId == 7449423635 and "Second Sea") or (game.PlaceId == 2753915549 and "Third Sea") or "Unknown"
SeaSec:NewLabel("Zone Detected: " .. currentSea)

-- [[ AETHERIUS VISION (REAL VISUAL ESP) ]] --
local Visuals = Window:NewTab("Visuals")
local ESPSec = Visuals:NewSection("Aetherius Vision (ESP)")

ESPSec:NewToggle("Player Vision", "Show Players Through Walls", function(state)
    if not Authorized then return end
    _G.EspActive = state
    
    while _G.EspActive do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                -- Check if ESP already exists
                if not p.Character.Head:FindFirstChild("AetheriusTag") then
                    local bill = Instance.new("BillboardGui", p.Character.Head)
                    bill.Name = "AetheriusTag"
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 100, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    
                    local lbl = Instance.new("TextLabel", bill)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.fromRGB(150, 0, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.TextSize = 12
                    
                    -- Update Loop for Tag
                    task.spawn(function()
                        while _G.EspActive and p.Character and p.Character:FindFirstChild("Humanoid") do
                            local dist = math.floor((p.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            local hp = math.floor(p.Character.Humanoid.Health)
                            lbl.Text = p.Name .. " [" .. p.DisplayName .. "]\n" .. hp .. "HP | " .. dist .. "m"
                            task.wait(0.5)
                        end
                        bill:Destroy()
                    end)
                end
            end
        end
        task.wait(2)
    end
end)

-- [[ HUB CUSTOMIZATION ]] --
local StyleTab = Window:NewTab("Customization")
local ThemeSec = StyleTab:NewSection("Elite UI Themes")

ThemeSec:NewButton("Signature Purple", "Pure Nexus Aura", function()
    Library:ChangeColor("AccentColor", Color3.fromRGB(150, 0, 255))
end)

ThemeSec:NewButton("Vanguard Red", "Aggressive Combat Aura", function()
    Library:ChangeColor("AccentColor", Color3.fromRGB(255, 0, 50))
end)

ThemeSec:NewButton("Emerald Green", "Clean Efficiency Aura", function()
    Library:ChangeColor("AccentColor", Color3.fromRGB(0, 255, 120))
end)

ThemeSec:NewButton("Void Black", "Stealth Protocol", function()
    Library:ChangeColor("AccentColor", Color3.fromRGB(30, 30, 30))
end)
