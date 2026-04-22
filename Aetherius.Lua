-- [[ AETHERIUS NEXUS | V10 VANGUARD ]] --
-- Library: Fluent (Mobile Optimized)
-- Features: Fixed ESP, Locked Aimbot, Draggable Toggle

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera

local Window = Fluent:CreateWindow({
    Title = "AETHERIUS NEXUS | V10",
    SubTitle = "by Aetherius Studios",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

-- [[ SECURITY & CONFIG ]] --
local Authorized = false
local FreeKey = "A3TH3R1USN3XUS77821X902L"
local PremiumKey = "AETERNUM-ΧΑΟΣ-ΣΤΡΑΤΟΣ-99-VANGUARD"

local Tabs = {
    License = Window:AddTab({ Title = "License", Icon = "lock" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "target" }),
    BloxFruits = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Vision", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ 1. LICENSE SYSTEM ]] --
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
            Fluent:Notify({Title = "SUCCESS", Content = "Features Unlocked | Aetherius Studios", Duration = 5})
        else
            Fluent:Notify({Title = "FAILED", Content = "Invalid Key", Duration = 5})
        end
    end
})

-- [[ 2. COMBAT (AIMBOT) ]] --
_G.AimbotEnabled = false
local CombatSec = Tabs.Combat:AddSection("Aetherius Targeting")

CombatSec:AddToggle("Aimbot", {Title = "Silent Aimbot (Camera Lock)", Default = false, Callback = function(v) 
    _G.AimbotEnabled = v 
end})

-- Aimbot Logic Loop
runService.RenderStepped:Connect(function()
    if _G.AimbotEnabled and Authorized then
        local target = nil
        local maxDist = math.huge
        
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = localPlayer:GetMouse()
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
        end
        
        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    end
end)

-- [[ 3. VISION (FIXED ESP) ]] --
_G.EspActive = false
Tabs.Visuals:AddToggle("PlayerESP", {Title = "Enable Player ESP", Default = false, Callback = function(v) 
    _G.EspActive = v 
end})

-- ESP Thread
task.spawn(function()
    while true do
        if _G.EspActive and Authorized then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    if not p.Character.Head:FindFirstChild("NexusESP") then
                        local gui = Instance.new("BillboardGui", p.Character.Head)
                        gui.Name = "NexusESP"
                        gui.AlwaysOnTop = true
                        gui.Size = UDim2.new(0, 100, 0, 50)
                        gui.StudsOffset = Vector3.new(0, 2, 0)
                        
                        local lbl = Instance.new("TextLabel", gui)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = Color3.fromRGB(255, 0, 50)
                        lbl.TextStrokeTransparency = 0
                        lbl.TextSize = 14
                        
                        task.spawn(function()
                            while _G.EspActive and p.Character and p.Character:FindFirstChild("Humanoid") do
                                local dist = math.floor((p.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
                                lbl.Text = p.Name .. "\n" .. math.floor(p.Character.Humanoid.Health) .. "HP | " .. dist .. "m"
                                task.wait(0.5)
                            end
                            gui:Destroy()
                        end)
                    end
                end
            end
        end
        task.wait(2)
    end
end)

-- [[ 4. DRAGGABLE ALPHA ICON (Α) ]] --
local ToggleGUI = Instance.new("ScreenGui", game.CoreGui)
local AlphaBtn = Instance.new("TextButton", ToggleGUI)
Instance.new("UICorner", AlphaBtn).CornerRadius = UDim2.new(1, 0)
local Stroke = Instance.new("UIStroke", AlphaBtn)

AlphaBtn.Size = UDim2.new(0, 60, 0, 60)
AlphaBtn.Position = UDim2.new(0, 10, 0.5, 0)
AlphaBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AlphaBtn.Text = "Α"
AlphaBtn.TextColor3 = Color3.fromRGB(150, 0, 255)
AlphaBtn.TextSize = 40
AlphaBtn.Font = Enum.Font.Greek
Stroke.Color = Color3.fromRGB(255, 0, 50)
Stroke.Thickness = 2

-- Enhanced Draggable Logic
local dragging, dragInput, dragStart, startPos
AlphaBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = AlphaBtn.Position
    end
end)
AlphaBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        AlphaBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
AlphaBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

AlphaBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

Window:SelectTab(1)
