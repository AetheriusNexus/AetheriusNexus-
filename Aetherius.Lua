-- [[ AETHERIUS NEXUS | V12 FINAL ]] --
-- Rebranded: Aetherius Studios
-- Mobile Optimization: High

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- [[ 1. GAME DETECTION ]] --
local isBloxFruits = (game.PlaceId == 2753915549 or game.PlaceId == 4442245219 or game.PlaceId == 7449423635)

local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V12",
    SubTitle = "by Aetherius Studios",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

-- [[ SECURITY STATUS ]] --
local Authorized = false
local FreeKey = "A3TH3R1USN3XUS77821X902L"

local Tabs = {
    License = Window:AddTab({ Title = "License", Icon = "lock" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "target" }),
    Visuals = Window:AddTab({ Title = "Vision", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if isBloxFruits then
    Tabs.BloxFruits = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" })
end

-- [[ 2. COMBAT: SMOOTH LERP AIMBOT ]] --
_G.Aimbot = false
_G.AimbotSmoothness = 0.1
local CombatSec = Tabs.Combat:AddSection("Aetherius Precision")

CombatSec:AddToggle("Aimbot", {Title = "Silent Smooth-Aim", Default = false, Callback = function(v) _G.Aimbot = v end})
CombatSec:AddSlider("AimSmooth", {Title = "Sensitivity", Default = 0.1, Min = 0.01, Max = 1, Callback = function(v) _G.AimbotSmoothness = v end})

runService.RenderStepped:Connect(function()
    if _G.Aimbot and Authorized then
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

-- [[ 3. VISION: TEAM-BASED BOX ESP ]] --
local VisSec = Tabs.Visuals:AddSection("Visual Analytics")
_G.BoxEsp = false

VisSec:AddToggle("BoxEsp", {Title = "Team Box ESP", Default = false, Callback = function(v) _G.BoxEsp = v end})

runService.Heartbeat:Connect(function()
    if _G.BoxEsp and Authorized then
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
    else
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("NexusBox") then p.Character.NexusBox:Destroy() end
        end
    end
end)

-- [[ 4. BLOX FRUITS: EXCLUSIVE FEATURES ]] --
if isBloxFruits then
    local BFSec = Tabs.BloxFruits:AddSection("Automated Systems")
    BFSec:AddToggle("AutoClick", {Title = "Fast Attack (Auto-Click)", Default = false})
    BFSec:AddButton({Title = "Server Hop (Safe Zone)", Callback = function()
        if not Authorized then return end
        local TPS = game:GetService("TeleportService")
        TPS:Teleport(game.PlaceId, localPlayer)
    end})
end

-- [[ 5. SETTINGS: THEME & UI ]] --
local SetSec = Tabs.Settings:AddSection("Interface Styles")
SetSec:AddDropdown("UITheme", {
    Title = "Nexus Color Mode",
    Values = {"Dark", "Light", "Amethyst", "Aqua"},
    Callback = function(v) Window:SetTheme(v) end
})

-- [[ 6. PERMANENT DRAGGABLE "Α" ICON ]] --
local ToggleGUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
ToggleGUI.Name = "AetheriusFixedToggle"
local AlphaBtn = Instance.new("TextButton", ToggleGUI)
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(1, 0)
local Stroke = Instance.new("UIStroke", AlphaBtn)

AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 20, 0.4, 0)
AlphaBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AlphaBtn.Text = "Α"
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
Stroke.Color = Color3.fromRGB(255, 0, 50)
Stroke.Thickness = 2

-- Pro-Level Dragging
local dragStart, startPos, dragging
AlphaBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = i.Position startPos = AlphaBtn.Position end end)
AlphaBtn.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dragStart AlphaBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
AlphaBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

AlphaBtn.MouseButton1Click:Connect(function()
    local core = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if core then core.Enabled = not core.Enabled end
end)

-- [[ FINAL LICENSE VERIFICATION ]] --
Tabs.License:AddInput("Auth", {Title = "Submit Key", Callback = function(v) 
    if v == FreeKey then 
        Authorized = true 
        Fluent:Notify({Title = "Success", Content = "Welcome to Aetherius Studios Core.", Duration = 5}) 
    end 
end})
