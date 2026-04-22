-- [[ AETHERIUS NEXUS | V7.5 ]] --
-- Developed by: Aetherius Studios
-- Inspiration: Quantum Onyx Layout

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 1. NEON STARTUP
Fluent:Notify({
    Title = "Aetherius Nexus",
    Content = "🌀 Core Systems Initializing... Powered by Aetherius Studios.",
    Duration = 5
})

-- 2. QUANTUM-STYLE WINDOW
local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V7.5",
    SubTitle = "by Aetherius Studios",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ AUTHENTICATION STATE ]] --
local Authorized = false
local FreeKey = "A3TH3R1USN3XUS77821X902L"
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"

-- [[ TABS - SIDEBAR NAVIGATION ]] --
local Tabs = {
    License = Window:AddTab({ Title = "License", Icon = "lock" }),
    Main = Window:AddTab({ Title = "Universal", Icon = "globe" }),
    BloxFruits = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Aetherius Vision", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ 1. LICENSE TAB (NO ZACH STARK NAME) ]] --
local KeyInput = ""
Tabs.License:AddInput("InputKey", {
    Title = "Enter License Key",
    Placeholder = "Paste Key Here",
    Callback = function(Value) KeyInput = Value end
})

Tabs.License:AddButton({
    Title = "Submit License",
    Description = "Verify your access status",
    Callback = function()
        if KeyInput == FreeKey or KeyInput == PremiumKey then
            Authorized = true
            Fluent:Notify({Title = "SUCCESS", Content = "Core Synchronized | Aetherius Studios", Duration = 5})
        else
            Fluent:Notify({Title = "FAILED", Content = "Invalid License String", Duration = 5})
        end
    end
})

Tabs.License:AddButton({
    Title = "Get Key (Work.ink)",
    Callback = function() setclipboard("https://work.ink/2qAU/759e261b-b989-45ef-a683-d6a35b4e2e30") end
})

-- [[ 2. UNIVERSAL (Daxion & Combat) ]] --
local UniversalSec = Tabs.Main:AddSection("Daxion Performance")
UniversalSec:AddToggle("AntiAFK", {Title = "Anti-AFK (Stay Online)", Default = false})
UniversalSec:AddButton({Title = "Daxion Shield (Clear Logs)", Callback = function() end})
UniversalSec:AddButton({Title = "Server Hop", Callback = function() end})

-- [[ 3. BLOX FRUITS (Quantum Layout) ]] --
local FarmSec = Tabs.BloxFruits:AddSection("Main Farm")
FarmSec:AddToggle("AutoFarm", {Title = "Auto-Farm Level", Default = false})
FarmSec:AddSlider("TweenSpeed", {Title = "Tweening Speed", Default = 250, Min = 100, Max = 500, Callback = function(v) end})

-- [[ 4. THE CRYPTIC "Α" ICON (PURPLE & RED) ]] --
local ToggleGUI = Instance.new("ScreenGui", game.CoreGui)
local AlphaBtn = Instance.new("TextButton", ToggleGUI)
AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 15, 0.4, 0)
AlphaBtn.Text = "Α"
AlphaBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255) -- Signature Purple
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(0, 15)

local Stroke = Instance.new("UIStroke", AlphaBtn)
Stroke.Color = Color3.fromRGB(255, 0, 50) -- Nexus Red Glow
Stroke.Thickness = 2

AlphaBtn.MouseButton1Click:Connect(function()
    -- Toggles Fluent UI
    local core = game.CoreGui:FindFirstChild("Fluent") or game.CoreGui:FindFirstChild("ScreenGui")
    if core then core.Enabled = not core.Enabled end
end)

Window:SelectTab(1)
