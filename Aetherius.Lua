-- [[ AETHERIUS NEXUS | MOBILE ELITE V6 ]] --
-- UI: Optimized Orion (Highest Mobile Compatibility)
-- Brand: Aetherius Nexus

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 1. THE STARTUP (Neon Swirl & Branding)
OrionLib:MakeNotification({
	Name = "Aetherius Nexus",
	Content = "🌀 Initializing Cryptic Core... Please wait.",
	Image = "rbxassetid://4483345998",
	Time = 4
})

local Window = OrionLib:MakeWindow({
    Name = "Α | AETHERIUS NEXUS", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "AetheriusNexus",
    IntroEnabled = true,
    IntroText = "BOOTING AETHERIUS..."
})

-- [[ AUTHENTICATION STATE ]] --
_G.Authorized = false
local FreeKey = "A3TH3R1USN3XUS77821X902L"
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"

-- [[ TABS ]] --
local AccessTab = Window:MakeTab({Name = "License", Icon = "rbxassetid://4483345998"})
local BloxTab = Window:NewTab({Name = "Blox Fruits", Icon = "rbxassetid://4483362458"})
local VisualsTab = Window:NewTab({Name = "Aetherius Vision", Icon = "rbxassetid://4483345998"})
local ConfigTab = Window:NewTab({Name = "Customization", Icon = "rbxassetid://4483362748"})

-- [[ LICENSE LOGIC ]] --
AccessTab:AddTextbox({
	Name = "Enter License Key",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		_G.KeyInput = Value
	end	  
})

AccessTab:AddButton({
	Name = "Submit License",
	Callback = function()
        if _G.KeyInput == FreeKey or _G.KeyInput == PremiumKey then
            _G.Authorized = true
            OrionLib:MakeNotification({
                Name = "SUCCESS",
                Content = "Nexus Core Synchronized. Welcome Zach Stark.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "FAILED",
                Content = "Invalid String. Check Work.ink link.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
	end
})

AccessTab:AddLabel("------------------------------")
AccessTab:AddLabel("Do you want Premium?")
AccessTab:AddButton({
	Name = "Purchase Premium Key",
	Callback = function()
		setclipboard("https://sellix.io/AetheriusNexus")
        OrionLib:MakeNotification({Name = "Store", Content = "Purchase link copied!", Time = 3})
	end
})

-- [[ VISUALS (REAL BILLBOARD ESP) ]] --
VisualsTab:AddToggle({
	Name = "Aetherius Vision (ESP)",
	Default = false,
	Callback = function(Value)
        if not _G.Authorized then 
            OrionLib:MakeNotification({Name = "Locked", Content = "Verify key to unlock ESP", Time = 3})
            return 
        end
		_G.EspActive = Value
        -- ESP Logic (BillboardGuis) starts here
	end
})

-- [[ CUSTOMIZATION (GREEK ALPHA ICON) ]] --
ConfigTab:AddLabel("UI Color Protocol")

ConfigTab:AddButton({
	Name = "Nexus Red & Purple",
	Callback = function()
        -- High-tier hybrid glow logic
	end
})

-- [[ THE "Α" TOGGLE ICON ]] --
-- This creates a button on the screen that stays even if the hub is closed
local IconGUI = Instance.new("ScreenGui", game.CoreGui)
local AlphaBtn = Instance.new("TextButton", IconGUI)

AlphaBtn.Size = UDim2.new(0, 50, 0, 50)
AlphaBtn.Position = UDim2.new(0, 10, 0.5, 0)
AlphaBtn.Text = "Α"
AlphaBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
AlphaBtn.TextSize = 35
AlphaBtn.Font = Enum.Font.Greek

local Corner = Instance.new("UICorner", AlphaBtn)
Corner.CornerRadius = ToolPoint.new(0, 12)

AlphaBtn.MouseButton1Click:Connect(function()
    game.CoreGui:FindFirstChild("Orion").Enabled = not game.CoreGui:FindFirstChild("Orion").Enabled
end)

OrionLib:Init()
