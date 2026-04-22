-- [[ AETHERIUS NEXUS | V13 FINAL FIX ]] --
-- Developed by: Aetherius Studios
-- Mobile-First Architecture

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- [[ MASTER CONFIG ]] --
_G.Authorized = false
_G.AimbotEnabled = false
_G.AimbotSmoothness = 0.08
_G.EspActive = false
_G.BoxEsp = false

local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V13",
    SubTitle = "by Aetherius Studios",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End 
})

-- [[ 1. LICENSE TAB (FIXED POPULATION) ]] --
local LicenseTab = Window:AddTab({ Title = "License", Icon = "lock" })
local KeyInput = ""

LicenseTab:AddInput("InputKey", {
    Title = "Enter License Key",
    Default = "",
    Placeholder = "Paste Key from Work.ink",
    Callback = function(Value) KeyInput = Value end
})

LicenseTab:AddButton({
    Title = "Submit License",
    Description = "Verify Key to Unlock Features",
    Callback = function()
        if KeyInput == "A3TH3R1USN3XUS77821X902L" or KeyInput == "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD" then
            _G.Authorized = true
            Fluent:Notify({Title = "SUCCESS", Content = "Core Synchronized | Aetherius Studios", Duration = 5})
        else
            Fluent:Notify({Title = "FAILED", Content = "Invalid License String", Duration = 5})
        end
    end
})

LicenseTab:AddButton({
    Title = "Get Key (Work.ink)",
    Callback = function() setclipboard("https://work.ink/2qAU/759e261b-b989-45ef-a683-d6a35b4e2e30") end
})

-- [[ 2. COMBAT TAB (SMOOTH AIMBOT) ]] --
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "target" })
local CombatSec = CombatTab:AddSection("Aetherius Precision")

CombatSec:AddToggle("Aimbot", {Title = "Silent Smooth-Aim", Default = false, Callback = function(v) _G.AimbotEnabled = v end})
CombatSec:AddSlider("AimSmooth", {Title = "Sensitivity", Default = 0.08, Min = 0.01, Max = 1, Callback = function(v) _G.AimbotSmoothness = v end})

runService.RenderStepped:Connect(function()
    if _G.AimbotEnabled and _G.Authorized then
        local target = nil
        local shortestDist = math.huge
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if mag < shortestDist then
                        shortestDist = mag
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
        end
        if target then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), _G.AimbotSmoothness)
        end
    end
end)

-- [[ 3. BLOX FRUITS TAB (MULTI-GAME COMPATIBLE) ]] --
local BloxTab = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" })
local BFSec = BloxTab:AddSection("Automated Systems")

BFSec:AddToggle("AutoClick", {Title = "Fast Attack (Auto-Click)", Default = false})
BFSec:AddButton({Title = "Server Hop", Callback = function()
    if not _G.Authorized then return end
    game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
end})

-- [[ 4. VISION TAB (ESP) ]] --
local VisionTab = Window:AddTab({ Title = "Vision", Icon = "eye" })
local VisSec = VisionTab:AddSection("Aetherius Vision")

VisSec:AddToggle("BoxEsp", {Title = "Team Box ESP", Default = false, Callback = function(v) _G.BoxEsp = v end})

runService.Heartbeat:Connect(function()
    if _G.BoxEsp and _G.Authorized then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local box = char:FindFirstChild("NexusBox") or Instance.new("SelectionBox", char)
                box.Name = "NexusBox"
                box.Adornee = char
                box.AlwaysOnTop = true
                box.LineThickness = 0.02
                box.Color3 = (p.TeamColor == localPlayer.TeamColor and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- [[ 5. SETTINGS TAB (UI CUSTOMIZATION) ]] --
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })
SettingsTab:AddDropdown("Theme", {
    Title = "Interface Theme",
    Values = {"Dark", "Light", "Amethyst", "Aqua"},
    Default = "Dark",
    Callback = function(v) Window:SetTheme(v) end
})

-- [[ 6. MASTER TOGGLE ICON (ALPHA) ]] --
local ToggleGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
ToggleGUI.Name = "MasterNexusToggle"
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
local dStart, sPos, dragging
AlphaBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true dStart = i.Position sPos = AlphaBtn.Position end end)
AlphaBtn.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dStart AlphaBtn.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
AlphaBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

AlphaBtn.MouseButton1Click:Connect(function()
    local gui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if gui then gui.Enabled = not gui.Enabled end
end)

Window:SelectTab(1)
