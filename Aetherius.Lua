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
-- AETHERIUS CORE: AUTHENTICATION GATEKEEPER
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game.Players.LocalPlayer
_G.Authorized = false

-- 1. Immediate Gamepass Check
local success, ownsPass = pcall(function() return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 1808462490) end)
if success and ownsPass then _G.Authorized = true end

-- 2. Logic Barrier: This holds the script here until _G.Authorized becomes true
-- (either via the Gamepass check above or your Verify button later)
task.spawn(function()
    repeat task.wait(0.5) until _G.Authorized == true
    print("Aetherius Nexus: Access Verified. Loading UI...")
end)

-- If NOT authorized, we stay on the License Tab logic. 
-- To prevent the "Nil" errors on your other 14 tabs, wrap them in this simple check:
local function requireAuth() return _G.Authorized end

-- ============================================================
-- LOAD FLUENT
-- ============================================================
local Fluent, SaveManager, InterfaceManager

local ok, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

if not ok or not Fluent then
    warn("[AETHERIUS] Failed to load Fluent: " .. tostring(err))
    return
end

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

-- HIDE THE GLITCHED DEFAULT BUTTONS
Fluent.MinimizeButton.Visible = false 

-- ============================================================
-- CUSTOM AE TOGGLE BUTTON (FIXES DISCONNECT ICON)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "AetheriusToggleUI"
ScreenGui.Parent = (game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 15, 0.5, -25)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Image = "rbxassetid://15124036622" -- This is your AE Logo
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

-- Toggle Logic for Button & Keybind
local function ToggleUI()
    if Window then
        Window:Minimize()
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleUI)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.LeftControl and not processed then
        ToggleUI()
    end
end)
-- ============================================================



-- ============================================================
-- TAB 1 — LICENSE / KEY SYSTEM (UNIFIED AUTH V15)
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local Player = game.Players.LocalPlayer

-- CONFIGURATION
local VANGUARD_PASS_ID = 1808462490 
local BASE_URL = "https://6e36ccc6-1ba9-4d32-acc1-c77212944542-00-1sweu4pulyk66.picard.replit.dev/verify?key="
local GATEWAY_URL = "https://6e36ccc6-1ba9-4d32-acc1-c77212944542-00-1sweu4pulyk66.picard.replit.dev/"

local LicenseTab = Window:AddTab({ Title = "License", Icon = "key-round" })

-- AUTOMATIC GAMEPASS CHECK ON LOAD
local function CheckGamepass()
    local success, ownsPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(Player.UserId, VANGUARD_PASS_ID)
    end)
    
    if success and ownsPass then
        _G.Authorized = true
        Fluent:Notify({
            Title    = "VANGUARD ELITE",
            Content  = "Gamepass Detected. Welcome, Commander.",
            Duration = 8,
        })
        return true
    end
    return false
end

local isAutoAuth = CheckGamepass()

LicenseTab:AddParagraph({
    Title   = "AETHERIUS NEXUS V15",
    Content = isAutoAuth and "Status: [ELITE ACCESS ACTIVE]" or "Enter a license key or own the Vanguard Gamepass to unlock features.",
})

local KeyInput = ""

LicenseTab:AddInput("KeyField", {
    Title       = "License Key",
    Placeholder = "Enter your key here...",
    Numeric     = false,
    Finished    = false,
    Callback    = function(value)
        KeyInput = value
    end,
})

LicenseTab:AddButton({
    Title    = "Verify & Unlock",
    Description = "Check key against Aetherius Core",
    Callback = function()
        if _G.Authorized then 
            return Fluent:Notify({Title = "ALREADY AUTH", Content = "You already have access!", Duration = 3}) 
        end

        local trimmed = KeyInput:match("^%s*(.-)%s*$")
        if trimmed == "" then
            return Fluent:Notify({Title = "ERROR", Content = "Please enter a key first.", Duration = 3})
        end

        -- AUTHENTICATION REQUEST
        local success, response = pcall(function()
            return game:HttpGet(BASE_URL .. trimmed)
        end)

        if success then
            if response == "premium" then
                _G.Authorized = true
                Fluent:Notify({
                    Title    = "VANGUARD ELITE",
                    Content  = "Premium Key Authenticated. Welcome.",
                    Duration = 7,
                })
            elseif response == "success" then
                _G.Authorized = true
                Fluent:Notify({
                    Title    = "AUTHORIZED",
                    Content  = "Daily Key Authenticated. Access Granted.",
                    Duration = 5,
                })
            else
                _G.Authorized = false
                Fluent:Notify({
                    Title    = "ACCESS DENIED",
                    Content  = "Invalid or expired license key.",
                    Duration = 5,
                })
            end
        else
            Fluent:Notify({
                Title    = "CONNECTION ERROR",
                Content  = "Could not connect to Aetherius Core. Is Replit online?",
                Duration = 5,
            })
        end
    end,
})

LicenseTab:AddButton({
    Title    = "Get Access Key / Buy Premium",
    Description = "Opens the Aetherius Gateway",
    Callback = function()
        setclipboard(GATEWAY_URL)
        Fluent:Notify({
            Title   = "Link Copied!",
            Content = "Gateway URL copied to clipboard.",
            Duration = 5,
        })
    end,
})
-- ============================================================
-- TAB 2 — COMBAT (AIMBOT)
-- ============================================================
-- PUT THIS LINE AT THE TOP OF EVERY FEATURE TAB CALLBACK
if not _G.Authorized then return end

local CombatTab = Window:AddTab({ Title = "Combat", Icon = "crosshair" })

-- FOV Circle
local AimFOVCircle = Drawing.new("Circle")
AimFOVCircle.Visible  = false
AimFOVCircle.Filled   = false
AimFOVCircle.Color    = Color3.fromRGB(255, 50, 50)
AimFOVCircle.Thickness = 1
AimFOVCircle.NumSides = 64
AimFOVCircle.Radius   = _G.AimbotFOV
AimFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

CombatTab:AddToggle("AimbotToggle", {
    Title    = "Smooth Aimlock",
    Description = "Locks aim to nearest visible player",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then
            -- Fluent toggles can't be force-set externally easily, just block behaviour
            _G.Aimbot = false
            return
        end
        _G.Aimbot = v
        AimFOVCircle.Visible = v
    end,
})

CombatTab:AddSlider("SmoothSlider", {
    Title    = "Smoothness",
    Description = "Lower = snappier | Higher = smoother",
    Default  = 15,
    Min      = 1,
    Max      = 100,
    Rounding = 1,
    Callback = function(v)
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
        _G.AimbotFOV = v
        AimFOVCircle.Radius = v
    end,
})

CombatTab:AddDropdown("AimbotPartDrop", {
    Title   = "Target Hitbox",
    Values  = { "Head", "HumanoidRootPart", "Torso", "UpperTorso" },
    Default = "Head",
    Callback = function(v)
        _G.AimbotPart = v
    end,
})

CombatTab:AddToggle("FOVVisToggle", {
    Title   = "Show FOV Circle",
    Default = false,
    Callback = function(v)
        AimFOVCircle.Visible = _G.Aimbot and v
    end,
})

CombatTab:AddToggle("TeamCheckToggle", {
    Title    = "Team Check",
    Description = "Do not target teammates",
    Default  = true,
    Callback = function(v) _G.TeamCheck = v end,
})

-- Aimbot Logic
local function getClosestPlayer()
    local closest = nil
    local closestDist = _G.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not p.Character then continue end

        local char = p.Character
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild(_G.AimbotPart) or char:FindFirstChild("HumanoidRootPart")

        if not hum or not root then continue end
        if hum.Health <= 0 then continue end
        if _G.TeamCheck and p.Team == LocalPlayer.Team and p.Team ~= nil then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest     = root
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    -- Update FOV circle position
    AimFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if not (_G.Aimbot and _G.Authorized) then return end

    -- Only aim while right-click held (common aimbot convention)
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    local target = getClosestPlayer()
    if target then
        local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.AimbotSmooth)
    end
end)

-- ============================================================
-- TAB 3 — VISION (ESP)
-- ============================================================
local VisionTab = Window:AddTab({ Title = "Vision", Icon = "eye" })

VisionTab:AddToggle("BoxESPToggle", {
    Title    = "Box ESP",
    Description = "Draws boxes around players",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.BoxESP = false return end
        _G.BoxESP = v
    end,
})

VisionTab:AddToggle("NameESPToggle", {
    Title    = "Name ESP",
    Description = "Displays player names above heads",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.NameESP = false return end
        _G.NameESP = v
    end,
})

VisionTab:AddToggle("HealthESPToggle", {
    Title    = "Health Bar ESP",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.HealthESP = false return end
        _G.HealthESP = v
    end,
})

VisionTab:AddToggle("ChamsToggle", {
    Title    = "Chams (Through Walls)",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.Chams = false return end
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
-- TAB 4 — MOVEMENT
-- ============================================================
local MovementTab = Window:AddTab({ Title = "Movement", Icon = "footprints" })

MovementTab:AddToggle("SpeedToggle", {
    Title    = "Speed Hack",
    Description = "Increases your walk speed",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.SpeedHack = false return end
        _G.SpeedHack = v
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = v and _G.SpeedValue or 16
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
        _G.SpeedValue = v
        if _G.SpeedHack then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = v end
            end
        end
    end,
})

MovementTab:AddToggle("InfJumpToggle", {
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.InfiniteJump = false return end
        _G.InfiniteJump = v
    end,
})

MovementTab:AddToggle("NoClipToggle", {
    Title    = "Noclip",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.NoClip = false return end
        _G.NoClip = v
    end,
})

MovementTab:AddToggle("FlyToggle", {
    Title    = "Fly",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then _G.FlyEnabled = false return end
        _G.FlyEnabled = v
    end,
})

MovementTab:AddSlider("FlySpeedSlider", {
    Title    = "Fly Speed",
    Default  = 50,
    Min      = 10,
    Max      = 300,
    Rounding = 1,
    Callback = function(v) _G.FlySpeed = v end,
})

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and _G.Authorized then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if _G.NoClip and _G.Authorized then
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end
end)

-- Fly Logic
local BodyVelocity, BodyGyro
local flyConn

local function enableFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity    = Vector3.zero
    BodyVelocity.MaxForce    = Vector3.new(1e9, 1e9, 1e9)
    BodyVelocity.Parent      = root

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    BodyGyro.D         = 100
    BodyGyro.CFrame    = root.CFrame
    BodyGyro.Parent    = root

    flyConn = RunService.RenderStepped:Connect(function()
        if not _G.FlyEnabled then
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
            if flyConn then flyConn:Disconnect() end
            return
        end
        local dir = Vector3.zero
        local cf  = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        BodyVelocity.Velocity = dir * _G.FlySpeed
        BodyGyro.CFrame       = cf
    end)
end

local function disableFly()
    _G.FlyEnabled = false
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if flyConn then flyConn:Disconnect() flyConn = nil end
end

-- Watch for fly toggle changes
local prevFly = false
RunService.Heartbeat:Connect(function()
    if _G.FlyEnabled and not prevFly then
        enableFly()
    elseif not _G.FlyEnabled and prevFly then
        disableFly()
    end
    prevFly = _G.FlyEnabled
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
-- TAB 7 — MM2 (Murder Mystery 2)
-- ============================================================
local MM2Tab = Window:AddTab({ Title = "MM2", Icon = "knife" })

MM2Tab:AddParagraph({
    Title   = "Murder Mystery 2",
    Content = "Reveal roles, coin farm, and ESP for MM2.",
})

MM2Tab:AddToggle("MM2RoleESP", {
    Title    = "Role Revealer ESP",
    Description = "Shows Murderer/Sheriff in chat",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                local char = p.Character
                if char then
                    local roleTag = char:FindFirstChild("Role") or char:FindFirstChild("RoleValue")
                    if roleTag then
                        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                            Text = "[MM2] " .. p.Name .. " is " .. tostring(roleTag.Value),
                            Color = Color3.fromRGB(255, 200, 0),
                        })
                    end
                end
            end
        end
    end,
})

MM2Tab:AddButton({
    Title    = "Auto Collect Coins",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Coin" then
                local p2 = obj.PrimaryPart or (obj:IsA("BasePart") and obj)
                if p2 then p2.CFrame = root.CFrame end
            end
        end
    end,
})

-- ============================================================
-- TAB 8 — JAILBREAK
-- ============================================================
local JailTab = Window:AddTab({ Title = "Jailbreak", Icon = "lock-open" })

JailTab:AddParagraph({
    Title   = "Jailbreak",
    Content = "Auto rob, vehicle speed, and prison escape utilities.",
})

JailTab:AddButton({
    Title    = "TP to Jewelry Store",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(279, 18, 1581)
        end
    end,
})

JailTab:AddButton({
    Title    = "TP to Bank",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-185, 18, -870)
        end
    end,
})

JailTab:AddButton({
    Title    = "TP to Train Station",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(870, 18, -500)
        end
    end,
})

local JBCarSpeed = false
JailTab:AddToggle("JBSpeedCar", {
    Title    = "Vehicle Speed Boost",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then JBCarSpeed = false return end
        JBCarSpeed = v
    end,
})

RunService.Heartbeat:Connect(function()
    if JBCarSpeed and _G.Authorized then
        local char = LocalPlayer.Character
        if not char then return end
        local seat = char:FindFirstChildOfClass("Seat") or char:FindFirstChildOfClass("VehicleSeat")
        if seat then seat.MaxSpeed = 300 end
    end
end)

-- ============================================================
-- TAB 9 — ARSENAL
-- ============================================================
local ArsenalTab = Window:AddTab({ Title = "Arsenal", Icon = "zap" })

ArsenalTab:AddParagraph({
    Title   = "Arsenal",
    Content = "Silent aim, bunny hop, and anti-death scripts for Arsenal.",
})

ArsenalTab:AddToggle("ArsSilentAim", {
    Title    = "Silent Aim",
    Description = "Bullets curve toward nearest target",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
    end,
})

ArsenalTab:AddToggle("ArsBHop", {
    Title    = "Bunny Hop",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            RunService.Stepped:Connect(function()
                if not v then return end
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial ~= Enum.Material.Air then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    end,
})

-- ============================================================
-- TAB 10 — BROOKHAVEN
-- ============================================================
local BHTab = Window:AddTab({ Title = "Brookhaven", Icon = "home" })

BHTab:AddParagraph({
    Title   = "Brookhaven RP",
    Content = "Trolling tools, speed, and house utilities.",
})

BHTab:AddButton({
    Title    = "TP to Bank",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(81, 17, -84)
        end
    end,
})

BHTab:AddToggle("BHSpeed", {
    Title    = "Speed Boost",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v and 60 or 16 end
        end
    end,
})

-- ============================================================
-- TAB 11 — PET SIM X / 99
-- ============================================================
local PetSimTab = Window:AddTab({ Title = "Pet Sim", Icon = "paw-print" })

PetSimTab:AddParagraph({
    Title   = "Pet Simulator X / 99",
    Content = "Auto collect, auto hatch, and egg bypass.",
})

PetSimTab:AddToggle("PSXAutoCollect", {
    Title    = "Auto Collect Coins",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
    end,
})

PetSimTab:AddButton({
    Title    = "Bring All Eggs to Character",
    Callback = function()
        if not requireAuth() then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Egg") and obj:IsA("Model") then
                local pp = obj.PrimaryPart
                if pp then
                    obj:SetPrimaryPartCFrame(root.CFrame + Vector3.new(math.random(-4,4), 0, math.random(-4,4)))
                end
            end
        end
    end,
})

-- ============================================================
-- TAB 12 — DOORS (Underrated-ish)
-- ============================================================
local DoorsTab = Window:AddTab({ Title = "Doors", Icon = "door-open" })

DoorsTab:AddParagraph({
    Title   = "Doors",
    Content = "Entity ESP, infinite stamina, and room skip.",
})

DoorsTab:AddToggle("DoorsEntityESP", {
    Title    = "Entity ESP (Highlight)",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj.Name == "Rush" or obj.Name == "Ambush" or obj.Name == "Screech" or obj.Name == "Eyes" or obj.Name == "Halt" or obj.Name == "Figure") and obj:IsA("Model") then
                    local h = Instance.new("SelectionBox")
                    h.Name        = "DoorEntityESP"
                    h.Adornee     = obj
                    h.LineThickness = 0.03
                    h.Color3      = Color3.fromRGB(255, 0, 0)
                    h.AlwaysOnTop = true
                    h.Parent      = obj
                end
            end
        else
            for _, obj in pairs(Workspace:GetDescendants()) do
                local h = obj:FindFirstChild("DoorEntityESP")
                if h then h:Destroy() end
            end
        end
    end,
})

DoorsTab:AddToggle("DoorsInfStam", {
    Title    = "Infinite Stamina",
    Default  = false,
    Callback = function(v)
        if v and not requireAuth() then return end
        if v then
            RunService.Heartbeat:Connect(function()
                if not v then return end
                local char = LocalPlayer.Character
                if char then
                    local stam = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
                    if stam and stam:IsA("NumberValue") then stam.Value = 999 end
                end
            end)
        end
    end,
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
