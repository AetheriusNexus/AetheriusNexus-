-- [[ AETHERIUS NEXUS | V14 ]] --
-- Rebranded: Aetherius Studios
-- Discord: https://discord.gg/Wzqd73qPDC

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- [[ MASTER STATE ]] --
_G.Authorized = false
_G.Aimbot = false
_G.AimbotSmooth = 0.07
_G.BoxEsp = false

-- [[ HUB INITIALIZATION ]] --
local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V14",
    SubTitle = "by Aetherius Studios",
    TabWidth = 170,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Disabled to fix the "Blank Sections" bug on mobile
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End 
})

-- [[ 1. LICENSE TAB (PHANTOM STYLE) ]] --
local LicenseTab = Window:AddTab({ Title = "Authentication", Icon = "lock" })

LicenseTab:AddParagraph({
    Title = "Secure Authentication System",
    Content = "Join our Discord for support: https://discord.gg/Wzqd73qPDC"
})

LicenseTab:AddInput("AuthInput", {
    Title = "Enter License Key",
    Placeholder = "Paste Key Here...",
    Callback = function(Value) _G.KeyBuffer = Value end
})

LicenseTab:AddButton({
    Title = "Verify & Launch",
    Description = "Synchronize with Aetherius Core",
    Callback = function()
        if _G.KeyBuffer == "A3TH3R1USN3XUS77821X902L" or _G.KeyBuffer == "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD" then
            _G.Authorized = true
            Fluent:Notify({Title = "SUCCESS", Content = "Welcome to Aetherius Studios.", Duration = 5})
        else
            Fluent:Notify({Title = "ERROR", Content = "Invalid License Key", Duration = 5})
        end
    end
})

LicenseTab:AddButton({
    Title = "Get Your Key (24H Access)",
    Callback = function() setclipboard("https://work.ink/2qAU/759e261b-b989-45ef-a683-d6a35b4e2e30") end
})

-- [[ 2. COMBAT TAB ]] --
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "target" })
local AimSec = CombatTab:AddSection("Aetherius Targeting")

AimSec:AddToggle("Aimlock", {Title = "Silent Smooth-Aim", Default = false, Callback = function(v) _G.Aimbot = v end})
AimSec:AddSlider("Smoothness", {Title = "Aim Sensitivity", Default = 0.07, Min = 0.01, Max = 1, Callback = function(v) _G.AimbotSmooth = v end})

runService.RenderStepped:Connect(function()
    if _G.Aimbot and _G.Authorized then
        local target = nil
        local dist = math.huge
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if mag < dist then dist = mag target = p.Character.HumanoidRootPart end
                end
            end
        end
        if target then cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), _G.AimbotSmooth) end
    end
end)

-- [[ 3. BLOX FRUITS TAB (QUANTUM ONYX STYLE) ]] --
local isBF = (game.PlaceId == 2753915549 or game.PlaceId == 4442245219 or game.PlaceId == 7449423635)
if isBF then
    local BloxTab = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" })
    local FarmSec = BloxTab:AddSection("Main Farm")
    FarmSec:AddToggle("AutoFarm", {Title = "Start Auto-Farm", Default = false})
    FarmSec:AddSlider("Tween", {Title = "Tweening Speed", Default = 250, Min = 100, Max = 500, Callback = function(v) end})
    
    local UtilitySec = BloxTab:AddSection("Utilities")
    UtilitySec:AddButton({Title = "Server Hop", Callback = function() if _G.Authorized then game:GetService("TeleportService"):Teleport(game.PlaceId) end end})
end

-- [[ 4. VISION TAB (ESP) ]] --
local VisionTab = Window:AddTab({ Title = "Vision", Icon = "eye" })
VisionTab:AddToggle("TeamBox", {Title = "Team-Based Box ESP", Default = false, Callback = function(v) _G.BoxEsp = v end})

runService.Heartbeat:Connect(function()
    if _G.BoxEsp and _G.Authorized then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local box = p.Character:FindFirstChild("NexusBox") or Instance.new("SelectionBox", p.Character)
                box.Name = "NexusBox" box.Adornee = p.Character box.AlwaysOnTop = true box.LineThickness = 0.02
                box.Color3 = (p.TeamColor == localPlayer.TeamColor and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- [[ 5. SETTINGS TAB ]] --
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })
SettingsTab:AddDropdown("Theme", {Title = "UI Theme", Values = {"Dark", "Light", "Amethyst", "Aqua"}, Default = "Dark", Callback = function(v) Window:SetTheme(v) end})
SettingsTab:AddButton({Title = "Copy Discord Link", Callback = function() setclipboard("https://discord.gg/Wzqd73qPDC") end})

-- [[ 6. PHANTOM-STYLE TOGGLE ICON ]] --
local ToggleGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
local AlphaBtn = Instance.new("TextButton", ToggleGUI)
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(1, 0)
AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 20, 0.4, 0)
AlphaBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AlphaBtn.Text = "Α"
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
local Stroke = Instance.new("UIStroke", AlphaBtn)
Stroke.Color = Color3.fromRGB(255, 0, 50)
Stroke.Thickness = 2

-- Draggable Logic
local dragging, dStart, sPos
AlphaBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true dStart = i.Position sPos = AlphaBtn.Position end end)
AlphaBtn.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dStart AlphaBtn.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
AlphaBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

AlphaBtn.MouseButton1Click:Connect(function()
    local gui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if gui then gui.Enabled = not gui.Enabled end
end)

Window:SelectTab(1)
