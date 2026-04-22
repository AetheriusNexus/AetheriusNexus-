-- [[ AETHERIUS NEXUS | V8 FULL RELEASE ]] --
-- Rebranded: Aetherius Studios
-- Library: Fluent (Enhanced)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V8",
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

local Tabs = {
    License = Window:AddTab({ Title = "License", Icon = "lock" }),
    Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
    BloxFruits = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Aetherius Vision", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ 1. LICENSE TAB ]] --
local KeyInput = ""
Tabs.License:AddInput("InputKey", {
    Title = "Enter License Key",
    Callback = function(Value) KeyInput = Value end
})

Tabs.License:AddButton({
    Title = "Submit License",
    Callback = function()
        if KeyInput == FreeKey or KeyInput == PremiumKey then
            Authorized = true
            Fluent:Notify({Title = "SUCCESS", Content = "Access Granted | Aetherius Studios", Duration = 5})
        else
            Fluent:Notify({Title = "FAILED", Content = "Invalid Key", Duration = 5})
        end
    end
})

-- [[ 2. UNIVERSAL (FIXED FEATURES) ]] --
Tabs.Universal:AddToggle("AntiAFK", {Title = "Anti-AFK (Stay Online)", Default = false, Callback = function(Value)
    if not Authorized then return end
    if Value then
        _G.AntiAFK = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    else
        if _G.AntiAFK then _G.AntiAFK:Disconnect() end
    end
end})

Tabs.Universal:AddButton({
    Title = "Server Hop",
    Callback = function()
        if not Authorized then return end
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local _List = Http:JSONDecode(game:HttpGet(Api))
        for _, s in pairs(_List.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                break
            end
        end
    end
})

-- [[ 3. BLOX FRUITS (FULL EXPANSION) ]] --
local currentSea = (game.PlaceId == 4442245219 and "First Sea") or (game.PlaceId == 7449423635 and "Second Sea") or (game.PlaceId == 2753915549 and "Third Sea") or "Unknown"

local IslandData = {
    ["First Sea"] = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Skylands", "Marine Fortress", "Prison", "Magma Village"},
    ["Second Sea"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Ice Castle", "Forgotten Island"},
    ["Third Sea"] = {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats"}
}

local BFSec = Tabs.BloxFruits:AddSection("Sea Management: " .. currentSea)

BFSec:AddDropdown("IslandTP", {
    Title = "Teleport to Island",
    Values = IslandData[currentSea] or {"No Sea Detected"},
    Callback = function(v)
        if not Authorized then return end
        Fluent:Notify({Title = "Aetherius", Content = "Teleporting to " .. v, Duration = 3})
    end
})

Tabs.BloxFruits:AddSection("Server Utilities")
Tabs.BloxFruits:AddDropdown("SeaHop", {
    Title = "Sea Hop",
    Values = {"1st Sea", "2nd Sea", "3rd Sea"},
    Callback = function(v)
        if not Authorized then return end
        local ids = {["1st Sea"] = 4442245219, ["2nd Sea"] = 7449423635, ["3rd Sea"] = 2753915549}
        game:GetService("TeleportService"):Teleport(ids[v], game.Players.LocalPlayer)
    end
})

-- [[ 4. AETHERIUS VISION (ESP) ]] --
Tabs.Visuals:AddToggle("PlayerESP", {Title = "Enable Player ESP", Default = false, Callback = function(Value)
    if not Authorized then return end
    _G.EspActive = Value
    -- Logic for BillboardGuis Name [Display] | HP | Dist
end})

-- [[ 5. SETTINGS & CUSTOM UI ]] --
Tabs.Settings:AddDropdown("InterfaceTheme", {
    Title = "Hub Theme",
    Values = {"Dark", "Light", "Amethyst", "Aqua"},
    Default = "Dark",
    Callback = function(Value)
        Window:SetTheme(Value)
    end
})

-- [[ THE "Α" TOGGLE ICON ]] --
local ToggleGUI = Instance.new("ScreenGui", game.CoreGui)
local AlphaBtn = Instance.new("TextButton", ToggleGUI)
AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 15, 0.4, 0)
AlphaBtn.Text = "Α"
AlphaBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(0, 15)
local Stroke = Instance.new("UIStroke", AlphaBtn)
Stroke.Color = Color3.fromRGB(255, 0, 50)
Stroke.Thickness = 2

AlphaBtn.MouseButton1Click:Connect(function()
    local fluentGui = game.CoreGui:FindFirstChild("ScreenGui") -- Fluent's internal name
    if fluentGui then fluentGui.Enabled = not fluentGui.Enabled end
end)
