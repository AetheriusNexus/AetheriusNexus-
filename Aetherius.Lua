local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- [[ WINDOW SETUP ]] --
local Window = OrionLib:MakeWindow({
    Name = "💠 AETHERIS NEXUS | V3 ULTRA", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "AetherisNexusV3",
    IntroText = "Daxion Systems Loading..."
})

-- [[ VARIABLES ]] --
_G.AttackMethod = "Melee"
_G.AttackSpeed = "Normal"
_G.FarmDistance = 10
_G.UndergroundFarm = false

-- [[ TABS ]] --
local MainTab = Window:MakeTab({Name = "Universal", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local BloxTab = Window:MakeTab({Name = "Blox Fruits", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local StyleTab = Window:MakeTab({Name = "Customization", Icon = "rbxassetid://4483362748", PremiumOnly = false})

--- [[ BLOX FRUITS SECTION ]] ---
BloxTab:AddSection({Name = "Combat Settings"})

BloxTab:AddDropdown({
	Name = "Select Fighting Tool",
	Default = "Melee",
	Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
	Callback = function(Value)
		_G.AttackMethod = Value
	end    
})

BloxTab:AddDropdown({
	Name = "Attack Speed",
	Default = "Normal",
	Options = {"Normal", "Fast", "Ultra (Dangerous)"},
	Callback = function(Value)
		_G.AttackSpeed = Value
	end    
})

BloxTab:AddSection({Name = "Farming Settings"})

BloxTab:AddSlider({
	Name = "Farm Distance",
	Min = 0,
	Max = 50,
	Default = 10,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Studs",
	Callback = function(Value)
		_G.FarmDistance = Value
	end    
})

BloxTab:AddToggle({
	Name = "Underground Mode (Anti-Player)",
	Default = false,
	Callback = function(Value)
		_G.UndergroundFarm = Value
	end
})

BloxTab:AddToggle({
	Name = "Drag Mobs (Mob Pull)",
	Default = false,
	Callback = function(Value)
		_G.DragMobs = Value
	end
})

--- [[ CUSTOMIZATION SECTION ]] ---
StyleTab:AddSection({Name = "UI Themes"})

StyleTab:AddButton({
	Name = "Aetheris Purple (Default)",
	Callback = function()
        -- Note: Orion themes are handled via internal library colors
        OrionLib:MakeNotification({Name = "Theme Applied", Content = "Purple Nexus Theme Active", Time = 3})
	end
})

StyleTab:AddButton({
	Name = "Vanguard Red",
	Callback = function()
        -- Custom Color Logic here
	end
})

StyleTab:AddButton({
	Name = "Emerald Green",
	Callback = function()
        -- Custom Color Logic here
	end
})

StyleTab:AddButton({
	Name = "Void Black",
	Callback = function()
        -- Custom Color Logic here
	end
})

--- [[ UNIVERSAL FEATURES ]] ---
MainTab:AddToggle({
	Name = "Auto-Clicker",
	Default = false,
	Callback = function(Value)
		_G.AutoClick = Value
		task.spawn(function()
			while _G.AutoClick do
				game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
				task.wait(0.05)
				game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
				task.wait(0.05)
			end
		end)
	end
})

MainTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 500,
	Default = 16,
	Increment = 1,
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

OrionLib:Init()
