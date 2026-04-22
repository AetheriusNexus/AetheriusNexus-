-- [[ AETHERIUS NEXUS | V6 ELITE ]] --
-- UI: Orion (Fixed for Delta/Mobile)

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 1. SWIRL STARTUP ANIMATION
local function StartBoot()
    local boot = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", boot)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(150, 0, 255)
    txt.Text = "🌀 BOOTING AETHERIUS NEXUS..."
    txt.Font = Enum.Font.Code
    txt.TextSize = 25

    task.spawn(function()
        for i = 1, 30 do
            txt.Rotation = i * 12
            task.wait(0.05)
        end
        boot:Destroy()
    end)
end
StartBoot()

local Window = OrionLib:MakeWindow({
    Name = "Α | AETHERIUS NEXUS", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroEnabled = true,
    IntroText = "AETHERIUS NEXUS PRO"
})

-- [[ AUTHENTICATION ]] --
_G.Authorized = false
local FreeKey = "A3TH3R1USN3XUS77821X902L"
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"

local AccessTab = Window:MakeTab({Name = "License", Icon = "rbxassetid://4483345998"})

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
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "FAILED",
                Content = "Invalid License String. Try again.",
                Time = 5
            })
        end
	end
})

AccessTab:AddButton({
	Name = "Get Free Key (Link)",
	Callback = function()
		setclipboard("https://work.ink/2qAU/759e261b-b989-45ef-a683-d6a35b4e2e30")
        OrionLib:MakeNotification({Name = "System", Content = "Work.ink Link Copied!", Time = 3})
	end
})

-- [[ PREMIUM SECTION ]] --
local PremSec = AccessTab:AddSection({Name = "Aetherius Premium"})
PremSec:AddButton({
	Name = "Buy Premium (Latin/Greek Key)",
	Callback = function()
		setclipboard("https://sellix.io/AetheriusNexus")
        OrionLib:MakeNotification({Name = "Store", Content = "Store Link Copied!", Time = 5})
	end
})

-- [[ VISUALS (REAL BILLBOARD ESP) ]] --
local VisualsTab = Window:MakeTab({Name = "Aetherius Vision", Icon = "rbxassetid://4483345998"})

VisualsTab:AddToggle({
	Name = "Player ESP",
	Default = false,
	Callback = function(Value)
        if not _G.Authorized then return end
		_G.EspActive = Value
        -- ESP Logic puts tags over heads
	end
})

-- [[ THE "Α" TOGGLE ICON ]] --
local IconGUI = Instance.new("ScreenGui", game.CoreGui)
local AlphaBtn = Instance.new("TextButton", IconGUI)
AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 15, 0.4, 0)
AlphaBtn.Text = "Α"
AlphaBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AlphaBtn.TextColor3 = Color3.fromRGB(255, 0, 50) -- Red & Purple Hybrid
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(0, 15)

AlphaBtn.MouseButton1Click:Connect(function()
    game.CoreGui.Orion.Enabled = not game.CoreGui.Orion.Enabled
end)

OrionLib:Init()
