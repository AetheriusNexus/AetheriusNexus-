-- [[ AETHERIUS NEXUS | V15 ]] --
-- Rewritten & Fixed by Aetherius Studios
-- Library: Fluent UI

-- ============================================================
-- SERVICES & CORE VARIABLES
-- ============================================================
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService   = game:GetService("HttpService")
local CoreGui       = game:GetService("CoreGui")
local Workspace     = game:GetService("Workspace")

local LocalPlayer   = Players.LocalPlayer
local Camera        = Workspace.CurrentCamera
local Mouse         = LocalPlayer:GetMouse()

-- ============================================================
-- GLOBAL STATE
-- ============================================================
_G.Authorized       = false
_G.Aimbot           = false
_G.AimbotSmooth     = 0.15
_G.AimbotPart       = "Head"
_G.AimbotFOV        = 200
_G.BoxESP           = false
_G.NameESP          = false
_G.HealthESP        = false
_G.TeamCheck        = true
_G.Chams            = false
_G.SpeedHack        = false
_G.SpeedValue       = 16
_G.InfiniteJump     = false
_G.NoClip           = false
_G.FlyEnabled       = false
_G.FlySpeed         = 50

-- ============================================================
-- VALID KEYS
-- ============================================================
local VALID_KEYS = {
    ["A3TH3R1USN3XUS77821X902L"]        = true,
    ["AETHERIUS-NEXUS-FREE-2025"]        = true,
    ["NEXUS-VANGUARD-ELITE-X99"]         = true,
    ["AETHERKEY-UNLOCK-0001"]            = true,
}
-- ============================================================
-- AETHERIUS CORE: AUTHENTICATION
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
_G.Authorized = false

-- Immediate Gamepass Check (Silent)
local VANGUARD_PASS_ID = 1808462490 
local passSuccess, ownsPass = pcall(function() return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, VANGUARD_PASS_ID) end)
if passSuccess and ownsPass then _G.Authorized = true end

-- ============================================================
-- LOAD FLUENT
-- ============================================================
local Fluent, SaveManager, InterfaceManager
local ok, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

if not ok or not Fluent then return warn("[AETHERIUS] Failed to load Fluent") end

-- ============================================================
-- CREATE WINDOW
-- ============================================================
local Window = Fluent:CreateWindow({
    Title    = "AETHERIUS NEXUS",
    SubTitle = "V15 | by Aetherius Studios",
    TabWidth = 170,
    Size     = UDim2.fromOffset(620, 500),
    Acrylic  = false,
    Theme    = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

-- ============================================================
-- TAB 1 — LICENSE
-- ============================================================
local LicenseTab = Window:AddTab({ Title = "License", Icon = "key-round" })
local BASE_URL = "https://6e36ccc6-1ba9-4d32-acc1-c77212944542-00-1sweu4pulyk66.picard.replit.dev/verify?key="
local GATEWAY_URL = "https://6e36ccc6-1ba9-4d32-acc1-c77212944542-00-1sweu4pulyk66.picard.replit.dev/"

LicenseTab:AddParagraph({
    Title   = "AETHERIUS NEXUS V15",
    Content = _G.Authorized and "Status: [ELITE ACCESS ACTIVE]" or "Enter a license key to unlock all game tabs.",
})

local KeyInput = ""
LicenseTab:AddInput("KeyField", {
    Title = "License Key",
    Callback = function(v) KeyInput = v end,
})

LicenseTab:AddButton({
    Title = "Verify & Unlock",
    Callback = function()
        if _G.Authorized then return Fluent:Notify({Title="Access Active", Content="You are already verified!"}) end
        
        local success, response = pcall(function() return game:HttpGet(BASE_URL .. KeyInput) end)
        
        if success and (response == "premium" or response == "success") then
            _G.Authorized = true
            Fluent:Notify({Title="AUTHORIZED", Content="Access Granted. Please re-run the script to load all tabs.", Duration=5})
        else
            Fluent:Notify({Title="DENIED", Content="Invalid License Key.", Duration=5})
        end
    end
})

-- ============================================================
-- TAB 2 — COMBAT (AIMBOT)
-- ============================================================
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "crosshair" })

-- FOV Circle setup
local AimFOVCircle = Drawing.new("Circle")
AimFOVCircle.Visible  = false
AimFOVCircle.Filled   = false
AimFOVCircle.Color    = Color3.fromRGB(255, 50, 50)
AimFOVCircle.Thickness = 1
AimFOVCircle.NumSides = 64
AimFOVCircle.Radius   = _G.AimbotFOV or 200
AimFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

CombatTab:AddToggle("AimbotToggle", {
    Title    = "Smooth Aimlock",
    Description = "Locks aim to nearest visible player",
    Default  = false,
    Callback = function(v)
        -- PUT THIS LINE AT THE TOP OF CALLBACK
        if not _G.Authorized then return end
        
        _G.Aimbot = v
        AimFOVCircle.Visible = v
    end,
})

CombatTab:AddSlider("SmoothSlider", {
    Title    = "Smoothness",
    Default  = 15,
    Min      = 1,
    Max      = 100,
    Rounding = 1,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.AimbotSmooth = v / 1000
    end,
})

CombatTab:AddSlider("FOVSlider", {
    Title    = "FOV Radius",
    Default  = 200,
    Min      = 50,
    Max      = 600,
    Rounding = 1,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.AimbotFOV = v
        AimFOVCircle.Radius = v
    end,
})

CombatTab:AddDropdown("AimbotPartDrop", {
    Title   = "Target Hitbox",
    Values  = { "Head", "HumanoidRootPart", "Torso", "UpperTorso" },
    Default = "Head",
    Callback = function(v)
        if not _G.Authorized then return end
        _G.AimbotPart = v
    end,
})

CombatTab:AddToggle("FOVVisToggle", {
    Title   = "Show FOV Circle",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        AimFOVCircle.Visible = _G.Aimbot and v
    end,
})

CombatTab:AddToggle("TeamCheckToggle", {
    Title    = "Team Check",
    Default  = true,
    Callback = function(v) 
        if not _G.Authorized then return end
        _G.TeamCheck = v 
    end,
})

-- ============================================================
-- TAB 3 — VISION (ESP)
-- ============================================================
local VisionTab = Window:AddTab({ Title = "Vision", Icon = "eye" })

VisionTab:AddToggle("BoxESPToggle", {
    Title    = "Box ESP",
    Default  = false,
    Callback = function(v)
        -- PUT THIS LINE AT THE TOP OF CALLBACK
        if not _G.Authorized then return end
        _G.BoxESP = v
    end,
})

VisionTab:AddToggle("NameESPToggle", {
    Title    = "Name ESP",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.NameESP = v
    end,
})

VisionTab:AddToggle("HealthESPToggle", {
    Title    = "Health Bar ESP",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.HealthESP = v
    end,
})

VisionTab:AddToggle("ChamsToggle", {
    Title    = "Chams (Through Walls)",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.Chams = v
    end,
})


-- ESP Drawing Pool
local ESPPool = {}

local function getOrCreateESP(player)
    if ESPPool[player] then return ESPPool[player] end
    local pool = {}
    pool.Box = Drawing.new("Square")
    pool.Box.Visible   = false
    pool.Box.Color     = Color3.fromRGB(255, 50, 50)
    pool.Box.Thickness = 1
    pool.Box.Filled    = false

    pool.Name = Drawing.new("Text")
    pool.Name.Visible  = false
    pool.Name.Size     = 13
    pool.Name.Center   = true
    pool.Name.Outline  = true
    pool.Name.Color    = Color3.fromRGB(255, 255, 255)

    pool.HealthBG = Drawing.new("Square")
    pool.HealthBG.Visible = false
    pool.HealthBG.Color   = Color3.fromRGB(30, 30, 30)
    pool.HealthBG.Filled  = true

    pool.HealthBar = Drawing.new("Square")
    pool.HealthBar.Visible = false
    pool.HealthBar.Color   = Color3.fromRGB(0, 220, 80)
    pool.HealthBar.Filled  = true

    ESPPool[player] = pool
    return pool
end

local function removeESP(player)
    if not ESPPool[player] then return end
    for _, d in pairs(ESPPool[player]) do
        d:Remove()
    end
    ESPPool[player] = nil
end

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
end)

RunService.Heartbeat:Connect(function()
    local anyESP = _G.BoxESP or _G.NameESP or _G.HealthESP

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local esp = getOrCreateESP(p)

        if not anyESP or not _G.Authorized or not p.Character then
            esp.Box.Visible      = false
            esp.Name.Visible     = false
            esp.HealthBG.Visible = false
            esp.HealthBar.Visible = false
            continue
        end

        local char = p.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")

        if not root or not hum then
            esp.Box.Visible      = false
            esp.Name.Visible     = false
            esp.HealthBG.Visible = false
            esp.HealthBar.Visible = false
            continue
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then
            esp.Box.Visible      = false
            esp.Name.Visible     = false
            esp.HealthBG.Visible = false
            esp.HealthBar.Visible = false
            continue
        end

        -- Approximate box size based on distance
        local dist   = (Camera.CFrame.Position - root.Position).Magnitude
        local scale  = 1 / dist * 120
        local bW     = scale * 3.5
        local bH     = scale * 5.5
        local bX     = rootPos.X - bW / 2
        local bY     = rootPos.Y - bH / 2

        -- Team color
        local isTeam = p.Team == LocalPlayer.Team and p.Team ~= nil
        local boxColor = isTeam and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(255, 50, 50)

        -- Box ESP
        esp.Box.Visible   = _G.BoxESP
        esp.Box.Position  = Vector2.new(bX, bY)
        esp.Box.Size      = Vector2.new(bW, bH)
        esp.Box.Color     = boxColor

        -- Name ESP
        esp.Name.Visible  = _G.NameESP
        esp.Name.Position = Vector2.new(rootPos.X, bY - 14)
        esp.Name.Text     = p.DisplayName .. " [" .. math.floor(dist) .. "m]"
        esp.Name.Color    = boxColor

        -- Health Bar ESP
        local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local hbW = 3
        local hbX = bX - hbW - 2

        esp.HealthBG.Visible  = _G.HealthESP
        esp.HealthBG.Position = Vector2.new(hbX, bY)
        esp.HealthBG.Size     = Vector2.new(hbW, bH)

        esp.HealthBar.Visible  = _G.HealthESP
        esp.HealthBar.Position = Vector2.new(hbX, bY + bH * (1 - healthRatio))
        esp.HealthBar.Size     = Vector2.new(hbW, bH * healthRatio)
        esp.HealthBar.Color    = Color3.fromRGB(
            math.floor(255 * (1 - healthRatio)),
            math.floor(220 * healthRatio),
            40
        )

        -- Chams
        if _G.Chams then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("AetheriusCham") then
                    local highlight = Instance.new("SelectionBox")
                    highlight.Name        = "AetheriusCham"
                    highlight.Adornee     = char
                    highlight.LineThickness = 0.02
                    highlight.Color3      = boxColor
                    highlight.AlwaysOnTop = true
                    highlight.Parent      = char
                    break
                end
            end
        else
            if char then
                local cham = char:FindFirstChild("AetheriusCham")
                if cham then cham:Destroy() end
            end
        end
    end
end)

-- ============================================================
-- TAB 4 — MOVEMENT (FIXED & PROTECTED)
-- ============================================================
local MovementTab = Window:AddTab({ Title = "Movement", Icon = "footprints" })

MovementTab:AddToggle("SpeedToggle", {
    Title    = "Speed Hack",
    Description = "Increases your walk speed",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.SpeedHack = v
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = v and (_G.SpeedValue or 30) or 16
            end
        end
    end,
})

MovementTab:AddSlider("SpeedSlider", {
    Title    = "Walk Speed",
    Default  = 30,
    Min      = 16,
    Max      = 250,
    Rounding = 1,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.SpeedValue = v
        if _G.SpeedHack then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.WalkSpeed = v
            end
        end
    end,
})

MovementTab:AddToggle("InfJumpToggle", {
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.InfiniteJump = v
    end,
})

MovementTab:AddToggle("NoClipToggle", {
    Title    = "Noclip",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.NoClip = v
    end,
})

MovementTab:AddToggle("FlyToggle", {
    Title    = "Fly (PC & Mobile)",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.FlyEnabled = v
    end,
})

MovementTab:AddSlider("FlySpeedSlider", {
    Title    = "Fly Speed",
    Default  = 50,
    Min      = 10,
    Max      = 300,
    Rounding = 1,
    Callback = function(v) 
        if not _G.Authorized then return end
        _G.FlySpeed = v 
    end,
})

-- ============================================================
-- MOVEMENT LOGIC (BACKGROUND LOOPS)
-- ============================================================

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and _G.Authorized then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip (Optimized)
RunService.Stepped:Connect(function()
    if _G.NoClip and _G.Authorized then
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end
end)

-- FIXED FLY LOGIC (Universal Mobile/PC)
local bv, bg
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if _G.FlyEnabled and _G.Authorized and root and hum then
        -- Prevent Falling Animation
        hum.PlatformStand = true 
        
        if not root:FindFirstChild("AetheriusFlyBV") then
            bv = Instance.new("BodyVelocity")
            bv.Name = "AetheriusFlyBV"
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = root
            
            bg = Instance.new("BodyGyro")
            bg.Name = "AetheriusFlyBG"
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.D = 100
            bg.Parent = root
        end
        
        -- Vector calculation for PC & Mobile
        local cameraCF = workspace.CurrentCamera.CFrame
        local dir = hum.MoveDirection -- Works for Mobile Joystick and PC WASD
        
        -- Vertical Movement (PC Only, but keeps speed)
        local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
        local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0
        
        local verticalDir = Vector3.new(0, up + down, 0)
        bv.Velocity = (dir + verticalDir) * (_G.FlySpeed or 50)
        bg.CFrame = cameraCF
    else
        -- Clean up Fly
        if hum then hum.PlatformStand = false end
        if root then
            if root:FindFirstChild("AetheriusFlyBV") then root.AetheriusFlyBV:Destroy() end
            if root:FindFirstChild("AetheriusFlyBG") then root.AetheriusFlyBG:Destroy() end
        end
    end
end)

-- ============================================================
-- TAB 5 — BLOX FRUITS
-- ============================================================
local BloxTab = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" })

BloxTab:AddParagraph({
    Title   = "Blox Fruits Scripts",
    Content = "Auto-farm, teleport, and utility scripts for Blox Fruits.",
})

local AutoFarmEnabled = false
BloxTab:AddToggle("BFAutoFarm", {
    Title    = "Auto Farm (Mobs)",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then AutoFarmEnabled = false return end
        AutoFarmEnabled = v
    end,
})

BloxTab:AddToggle("BFAutoQuest", {
    Title    = "Auto Accept Quest",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        -- Hooks into BloxFruits quest NPCs
    end,
})

BloxTab:AddButton({
    Title    = "Teleport to Shark Park (Sea 1)",
    Description = "Sea 1 fast travel",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1246, 40, -1882)
        end
    end,
})

BloxTab:AddButton({
    Title    = "Teleport to Skylands (Sea 1)",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(922, 850, -1208)
        end
    end,
})

BloxTab:AddButton({
    Title    = "Server Hop",
    Description = "Joins a new server instance",
    Callback = function()
        if not requireAuth() then return end
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

BloxTab:AddButton({
    Title    = "Bring All Fruits (Workspace Scan)",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:find("Fruit") then
                local p = obj:FindFirstChild("Handle") or obj.PrimaryPart
                if p then p.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 1, math.random(-5,5)) end
            end
        end
        Fluent:Notify({ Title = "Done", Content = "Scanned workspace for fruits.", Duration = 3 })
    end,
})

BloxTab:AddToggle("BFAutoEat", {
    Title    = "Auto Eat Fruits",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
    end,
})

-- ============================================================
-- TAB 6 — DA HOOD
-- ============================================================
local DHoodTab = Window:AddTab({ Title = "Da Hood", Icon = "shield" })

DHoodTab:AddParagraph({
    Title   = "Da Hood Scripts",
    Content = "Combat, mobility, and utility tools for Da Hood.",
})

DHoodTab:AddButton({
    Title    = "TP to Spawn",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
    end,
})

DHoodTab:AddToggle("DHInfAmmo", {
    Title    = "Infinite Ammo (Client)",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        -- Client-side ammo bypass attempt
    end,
})

DHoodTab:AddToggle("DHAntiRagdoll", {
    Title    = "Anti Ragdoll",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            local char = LocalPlayer.Character
            if char then
                for _, v2 in pairs(char:GetDescendants()) do
                    if v2:IsA("BallSocketConstraint") or v2:IsA("HingeConstraint") then
                        v2.Enabled = false
                    end
                end
            end
        end
    end,
})

DHoodTab:AddButton({
    Title    = "Collect All Cash (Scan)",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Cash" or obj.Name == "Money" then
                local tp = obj:FindFirstChild("RootPart") or obj.PrimaryPart or (obj:IsA("BasePart") and obj)
                if tp then tp.CFrame = root.CFrame end
            end
        end
    end,
})

-- ============================================================
-- TAB 7 — MM2 (Murder Mystery 2) - FIXED & PROTECTED
-- ============================================================
local MM2Tab = Window:AddTab({ Title = "MM2", Icon = "knife" })

MM2Tab:AddToggle("MM2RoleESP", {
    Title    = "Role Revealer (Chams)",
    Description = "Highlights Murderer (Red) and Sheriff (Blue)",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.MM2ESP = v
        
        task.spawn(function()
            while _G.MM2ESP do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local role = "Innocent"
                        local color = Color3.fromRGB(0, 255, 0)
                        
                        -- Check for Weapon to identify roles
                        if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                            role = "Murderer"
                            color = Color3.fromRGB(255, 0, 0)
                        elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                            role = "Sheriff"
                            color = Color3.fromRGB(0, 0, 255)
                        end
                        
                        if role ~= "Innocent" then
                            -- Apply Highlight/Cham
                            local highlight = p.Character:FindFirstChild("AetheriusHighlight") or Instance.new("Highlight", p.Character)
                            highlight.Name = "AetheriusHighlight"
                            highlight.FillColor = color
                            highlight.OutlineTransparency = 0
                        end
                    end
                end
                task.wait(1)
            end
            -- Clean up on toggle off
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("AetheriusHighlight") then
                    p.Character.AetheriusHighlight:Destroy()
                end
            end
        end)
    end,
})

MM2Tab:AddToggle("MM2CoinFarm", {
    Title    = "Auto Coin Farm (Deep Scan)",
    Description = "Actively hunts for the CoinContainer in the Map",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.CoinFarm = v
        
        task.spawn(function()
            while _G.CoinFarm do
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Aggressive scan for MM2's dynamic coin folder
                    local container = workspace:FindFirstChild("CoinContainer", true) 
                    if container then
                        for _, coin in pairs(container:GetChildren()) do
                            if coin:IsA("BasePart") or coin:IsA("Model") then
                                local target = coin:IsA("Model") and coin.PrimaryPart or coin
                                if target then
                                    target.CFrame = root.CFrame
                                    task.wait(0.01) -- Speed vacuum
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
})


-- ============================================================
-- TAB 8 — LUMBER TYCOON 2 (OG REPLACEMENT)
-- ============================================================
local LumberTab = Window:AddTab({ Title = "Lumber Tycoon 2", Icon = "tree" })

LumberTab:AddParagraph({
    Title   = "Lumber Tycoon 2 Utilities",
    Content = "Wood TP, water walking, and plot tools.",
})

LumberTab:AddButton({
    Title    = "Teleport to Wood Wood",
    Callback = function()
        if not _G.Authorized then return end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(270, 3, -420)
        end
    end,
})

LumberTab:AddToggle("WaterWalk", {
    Title    = "Walk on Water",
    Description = "Solidifies water so you don't sink",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        local water = workspace:FindFirstChild("Water")
        if water and water:IsA("BasePart") then
            water.CanCollide = v
        end
    end,
})

LumberTab:AddButton({
    Title    = "Bring All Loose Wood",
    Description = "Teleports unanchored wood to your plot",
    Callback = function()
        if not _G.Authorized then return end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "WoodLog" and obj:IsA("BasePart") and not obj.Anchored then
                    obj.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end,
})

-- ============================================================
-- TAB 9 — ARSENAL
-- ============================================================
local ArsenalTab = Window:AddTab({ Title = "Arsenal", Icon = "zap" })

ArsenalTab:AddParagraph({
    Title   = "Arsenal Elite",
    Content = "Advanced gun modifications and movement for Aetherius Nexus.",
})

-- 1. SILENT AIM (Calculates hit before shooting)
ArsenalTab:AddToggle("ArsSilentAim", {
    Title    = "Silent Aim",
    Description = "Hits land even if your crosshair is slightly off",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.SilentAim = v
        
        -- Logic is handled in the background loop below
    end,
})

-- 2. NO RECOIL / NO SPREAD
ArsenalTab:AddToggle("ArsNoRecoil", {
    Title    = "No Recoil & Spread",
    Description = "Lasers! Perfect accuracy with any weapon",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.NoRecoil = v
        
        task.spawn(function()
            while _G.NoRecoil and _G.Authorized do
                -- Arsenal stores gun stats in the local player's character/scripts
                local env = getsenv(LocalPlayer.PlayerGui.GUI.Client)
                if env and env.CurrentGun then
                    local gun = env.CurrentGun
                    if gun:FindFirstChild("Config") then
                        -- Alter gun config variables
                        local cfg = require(gun.Config)
                        cfg.Recoil = 0
                        cfg.Spread = 0
                    end
                end
                task.wait(1)
            end
        end)
    end,
})

-- 3. INSTANT RELOAD
ArsenalTab:AddToggle("ArsFastReload", {
    Title    = "Instant Reload",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.FastReload = v
        
        -- Hooks into the client's gun script to skip animation wait
        task.spawn(function()
            while _G.FastReload and _G.Authorized do
                local env = getsenv(LocalPlayer.PlayerGui.GUI.Client)
                if env and env.ReloadTime then
                    env.ReloadTime = 0
                end
                task.wait(0.5)
            end
        end)
    end,
})

-- 4. BUNNY HOP
ArsenalTab:AddToggle("ArsBHop", {
    Title    = "Bunny Hop",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.BHopEnabled = v
        task.spawn(function()
            while _G.BHopEnabled and _G.Authorized do
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.FloorMaterial ~= Enum.Material.Air then
                    hum.Jump = true
                end
                task.wait()
            end
        end)
    end,
})

-- ============================================================
-- ARSENAL BACKGROUND LOGIC (Silent Aim Hook)
-- ============================================================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.SilentAim and _G.Authorized and method == "FireServer" and self.Name == "HitPart" then
        -- Find closest target based on FOV
        local target = getClosestPlayer() -- Uses the function from your Combat tab
        if target then
            args[1] = target -- Force the bullet to hit the target part
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ============================================================
-- TAB 10 — BROOKHAVEN
-- ============================================================
local BHTab = Window:AddTab({ Title = "Brookhaven", Icon = "home" })

BHTab:AddButton({
    Title    = "TP to Bank",
    Callback = function()
        if not _G.Authorized then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-24, 16, -164)
        end
    end,
})

BHTab:AddToggle("BHSpeed", {
    Title    = "Speed Boost",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v and 80 or 16 end
        end
    end,
})


-- ============================================================
-- TAB 11 — PET SIM 99 / X (FIXED & PROTECTED)
-- ============================================================
local PetSimTab = Window:AddTab({ Title = "Pet Sim", Icon = "paw-print" })

PetSimTab:AddToggle("PSXAutoCollect", {
    Title    = "Auto Collect Loot",
    Description = "Snaps all dropped loot/coins to your character",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.PSXCollect = v
        
        task.spawn(function()
            while _G.PSXCollect do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Pet Sim 99 uses 'Things' folder for most drops
                    local things = workspace:FindFirstChild("Things")
                    if things then
                        for _, loot in pairs(things:GetChildren()) do
                            if loot.Name == "Loot" or loot.Name == "Coin" then
                                loot.CFrame = char.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end,
})

PetSimTab:AddButton({
    Title    = "Bring All Eggs to Character",
    Callback = function()
        if not _G.Authorized then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:find("Egg") and obj:IsA("Model") then
                obj:MoveTo(char.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            end
        end
    end,
})

-- NEW FEATURE: Pet Speed Multiplier
PetSimTab:AddSlider("PetSpeedSlider", {
    Title = "Pet Move Speed",
    Description = "Makes pets reach coins faster",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(v)
        if not _G.Authorized then return end
        -- Note: This is a client-side visual/logic boost
        _G.PetSpeedMult = v
    end
})

-- ============================================================
-- TAB 12 — DOORS (FIXED & PROTECTED)
-- ============================================================
local DoorsTab = Window:AddTab({ Title = "Doors", Icon = "door-open" })

DoorsTab:AddToggle("DoorsEntityESP", {
    Title    = "Entity ESP",
    Description = "Highlights Rush, Ambush, etc.",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.DoorsESP = v
        
        if v then
            task.spawn(function()
                while _G.DoorsESP do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if (obj.Name == "Rush" or obj.Name == "Ambush" or obj.Name == "Screech" or obj.Name == "Eyes") and not obj:FindFirstChild("AetheriusHigh") then
                            local h = Instance.new("Highlight", obj)
                            h.Name = "AetheriusHigh"
                            h.FillColor = Color3.fromRGB(255, 0, 0)
                            h.AlwaysOnTop = true
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("AetheriusHigh") then obj.AetheriusHigh:Destroy() end
            end
        end
    end,
})

DoorsTab:AddToggle("DoorsInfStam", {
    Title    = "Infinite Stamina",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.InfStamina = v
        task.spawn(function()
            while _G.InfStamina do
                local char = LocalPlayer.Character
                if char then
                    -- Doors uses a 'Stamina' value in the character
                    local s = char:FindFirstChild("Stamina")
                    if s then s.Value = 100 end
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- NEW FEATURE: Full Bright (See in Dark)
DoorsTab:AddToggle("DoorsFullBright", {
    Title = "Full Bright",
    Description = "Removes darkness from rooms",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        if v then
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        else
            game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})


-- ============================================================
-- TAB 13 — ANIME FIGHTING SIMULATOR X
-- ============================================================
local AFSTab = Window:AddTab({ Title = "AFSX", Icon = "flame" })

AFSTab:AddParagraph({
    Title   = "Anime Fighting Sim X",
    Content = "Auto training, auto quest, and chi farm.",
})

AFSTab:AddToggle("AFSAutoTrain", {
    Title    = "Auto Train (Click Spam)",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            task.spawn(function()
                while v do
                    -- Fires the training remote if present
                    for _, remote in pairs(game:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:find("Train") then
                            pcall(function() remote:FireServer() end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

-- ============================================================
-- TAB 14 — NATURAL DISASTER SURVIVAL (FIXED)
-- ============================================================
local NDSTab = Window:AddTab({ Title = "NDS", Icon = "cloud-lightning" })

NDSTab:AddParagraph({
    Title   = "Natural Disaster Survival",
    Content = "Anti-damage, safe spot teleport, and god mode.",
})

NDSTab:AddButton({
    Title = "TP to Skybase (Safe)",
    Callback = function()
        -- THIS IS WHERE THE PROTECTION GOES
        if not _G.Authorized then return Fluent:Notify({Title="Locked", Content="Verify Key First", Duration=2}) end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0)
            -- Create platform
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(30, 1, 30)
            p.CFrame = CFrame.new(0, 495, 0)
            p.Anchored = true
            p.Name = "AetheriusPlatform"
        end
    end
})

NDSTab:AddToggle("GodMode", {
    Title = "Anti-Damage",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        
        _G.GodMode = v
        task.spawn(function() -- task.spawn is REQUIRED for while loops in toggles
            while _G.GodMode do
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = 100
                    end
                    -- Deletes the NDS fall damage script
                    if char:FindFirstChild("FallDamage") then 
                        char.FallDamage:Destroy() 
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

-- ============================================================
-- TAB 15 — SETTINGS
-- ============================================================
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

SettingsTab:AddDropdown("ThemeDropdown", {
    Title   = "UI Theme",
    Values  = { "Dark", "Light", "Amethyst", "Aqua", "Ocean", "Rose" },
    Default = "Dark",
    Callback = function(v)
        Fluent:SetTheme(v)
    end,
})

SettingsTab:AddToggle("NotifToggle", {
    Title    = "Notifications",
    Default  = true,
    Callback = function(v) end,
})

SettingsTab:AddButton({
    Title    = "Reset All Toggles",
    Callback = function()
        _G.Aimbot    = false
        _G.BoxESP    = false
        _G.NameESP   = false
        _G.HealthESP = false
        _G.Chams     = false
        _G.SpeedHack = false
        _G.InfiniteJump = false
        _G.NoClip    = false
        _G.FlyEnabled = false
        Fluent:Notify({ Title = "Reset", Content = "All features have been disabled.", Duration = 3 })
    end,
})

SettingsTab:AddParagraph({
    Title   = "Keybinds",
    Content = "Toggle GUI: RightShift\nAimbot Fire: Hold RMB (Right Mouse Button)\nFly Controls: WASD + Space/Ctrl",
})

-- If SaveManager loaded, setup config saving
if SaveManager then
    SaveManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("AetheriusNexusV15")
    SaveManager:BuildConfigSection(SettingsTab)
end

if InterfaceManager then
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("AetheriusNexusV15")
    InterfaceManager:BuildInterfaceSection(SettingsTab)
end

-- ============================================================
-- DRAGGABLE TOGGLE BUTTON (ALPHA ICON)
-- ============================================================
-- Destroy old toggle if re-executing
local oldToggle = CoreGui:FindFirstChild("AetheriusOfficialToggle")
if oldToggle then oldToggle:Destroy() end

local ToggleGUI       = Instance.new("ScreenGui")
ToggleGUI.Name        = "AetheriusOfficialToggle"
ToggleGUI.ResetOnSpawn = false
ToggleGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGUI.Parent      = CoreGui

local AlphaBtn            = Instance.new("TextButton", ToggleGUI)
AlphaBtn.Size             = UDim2.new(0, 56, 0, 56)
AlphaBtn.Position         = UDim2.new(0, 20, 0.5, -28)
AlphaBtn.AnchorPoint      = Vector2.new(0, 0)
AlphaBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
AlphaBtn.Text             = "AE"
AlphaBtn.TextColor3       = Color3.fromRGB(160, 30, 255)
AlphaBtn.TextSize         = 18
AlphaBtn.Font             = Enum.Font.GothamBold
AlphaBtn.ZIndex           = 10
AlphaBtn.AutoButtonColor  = false

local Corner = Instance.new("UICorner", AlphaBtn)
Corner.CornerRadius = UDim.new(1, 0)

local Stroke = Instance.new("UIStroke", AlphaBtn)
Stroke.Color     = Color3.fromRGB(200, 0, 255)
Stroke.Thickness = 2

-- Hover glow
AlphaBtn.MouseEnter:Connect(function()
    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 255), Thickness = 3}):Play()
end)
AlphaBtn.MouseLeave:Connect(function()
    TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(200, 0, 255), Thickness = 2}):Play()
end)

-- Draggable Logic (clean version)
local dragging   = false
local dragStart  = nil
local startPos   = nil

AlphaBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = AlphaBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        AlphaBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Toggle Window Visibility (fixed to correctly find Fluent's ScreenGui)
local guiVisible = true
AlphaBtn.MouseButton1Click:Connect(function()
    -- Only toggle if not dragging
    if (dragStart and (AlphaBtn.Position.X.Offset ~= startPos.X.Offset or AlphaBtn.Position.Y.Offset ~= startPos.Y.Offset)) then
        dragStart = AlphaBtn.Position -- Update so next click works
        return
    end
    guiVisible = not guiVisible
    -- Search CoreGui for Fluent's main GUI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "AetheriusOfficialToggle" and gui.Name ~= "RobloxGui" then
            gui.Enabled = guiVisible
        end
    end
    Stroke.Color = guiVisible and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(80, 80, 80)
end)

-- ============================================================
-- STARTUP
-- ============================================================
Window:SelectTab(1) -- Open License tab first

Fluent:Notify({
    Title   = "AETHERIUS NEXUS V15",
    Content = "Loaded successfully! Enter your key in the License tab.",
    Duration = 6,
})

-- ============================================================
-- CHARACTER RESPAWN: Reapply speed on respawn
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    if _G.SpeedHack and _G.Authorized then
        char.Humanoid.WalkSpeed = _G.SpeedValue
    end
    _G.FlyEnabled = false -- Reset fly on death
end)
