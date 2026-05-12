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
-- KEY VALIDATION SYSTEM WITH WEBSITE INTEGRATION
-- ============================================================
local HttpService = game:GetService("HttpService")

-- Hardcoded premium keys (permanent)
local PREMIUM_KEYS = {
    ["A3TH3R1USN3XUS77821X902L"]        = true,
    ["AETHERIUS-NEXUS-FREE-2025"]        = true,
    ["NEXUS-VANGUARD-ELITE-X99"]         = true,
    ["AETHERKEY-UNLOCK-0001"]            = true,
}

-- Website URL for key validation
local GATEWAY_URL = "https://6e36ccc6-1ba9-4d32-acc1-c77212944542-00-1sweu4pulyk66.picard.replit.dev"

-- Function to validate key from website
local function validateWebsiteKey(key)
    local success, response = pcall(function()
        local url = GATEWAY_URL .. "/validate?key=" .. HttpService:UrlEncode(key)
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        return data.valid == true
    end
    
    return false
end

-- Function to check if key is valid (premium or website)
local function isValidKey(key)
    -- Check premium keys first
    if PREMIUM_KEYS[key] then
        return true, "premium"
    end
    
    -- Check website keys
    if validateWebsiteKey(key) then
        return true, "website"
    end
    
    return false, "invalid"
end

-- Key validation function for your script
local function validateKey(inputKey)
    local valid, keyType = isValidKey(inputKey)
    
    if valid then
        if keyType == "premium" then
            print("✅ Premium key accepted - Unlimited access")
        else
            print("✅ Website key accepted - 24hr access")
        end
        return true
    else
        print("❌ Invalid key - Please try again")
        return false
    end
end

-- Example usage in your key input system:
--[[
local userKey = "USER_INPUT_HERE"
if validateKey(userKey) then
    -- Proceed with script execution
    print("Access granted!")
else
    -- Deny access
    print("Access denied!")
end
--]]

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
-- STORE FLUENT GUI REFERENCE FOR TOGGLE
-- ============================================================
local FluentScreenGui = nil
-- Find the Fluent ScreenGui that was just created
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
        FluentScreenGui = gui
        break
    end
end

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
-- TAB 5 — BLOX FRUITS (QUANTUM HUB)
-- ============================================================
local BloxTab = Window:AddTab({ Title = "Blox Fruits", Icon = "swords" })

BloxTab:AddParagraph({
    Title   = "Quantum Hub",
    Content = "Click the button below to launch Quantum Hub script for Blox Fruits.",
})

-- Quantum Hub Button
BloxTab:AddButton({
    Title = "Quantum Hub",
    Description = "Launch Quantum Hub script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
    end
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
    Title    = "Auto Coin Farm (Fixed)",
    Description = "Vacuums Coin_Server models to you",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.CoinFarm = v
        task.spawn(function()
            while _G.CoinFarm do
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Based on your Dex screenshot: Look for Coin_Server models
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name == "Coin_Server" and obj:IsA("Model") then
                            -- Teleport the actual coin part to you
                            local coinPart = obj:FindFirstChild("CoinVisual") and obj.CoinVisual:FindFirstChild("MainCoin") 
                                             or obj.PrimaryPart 
                                             or obj:FindFirstChildOfClass("BasePart")
                            
                            if coinPart then
                                coinPart.CFrame = root.CFrame
                                task.wait(0.01) -- Quick snap
                            end
                        end
                    end
                end
                task.wait(0.3) -- Loop delay to prevent lag
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
-- TAB 14 — ANIME FIGHTING SIM X (GOD MODE UPGRADE)
-- ============================================================
local AFSTab = Window:AddTab({ Title = "AFS (W.I.P)", Icon = "flame" })

AFSTab:AddToggle("UniversalTrain", {
    Title = "Auto Train (Physical Fix)",
    Description = "Bypasses 'Remote Failed' by clicking tools",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.AFSTrain = v
        task.spawn(function()
            while _G.AFSTrain do
                -- 1. Tries the Remote
                local train = game:GetService("ReplicatedStorage"):FindFirstChild("Train", true)
                if train then pcall(function() train:FireServer() end) end
                
                -- 2. Physical Click Fallback (Bypasses NPC distance check)
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate() -- Physically uses the tool in your hand
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- FIXED GACHA: Uses InvokeServer as seen in AFSX scripts
AFSTab:AddButton({
    Title = "Remote Spin (Invoke Fix)",
    Callback = function()
        if not _G.Authorized then return end
        local gacha = game:GetService("ReplicatedStorage"):FindFirstChild("Spin", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Roll", true)
        if gacha then
            -- AFSX Gacha usually requires an 'Invoke' rather than a 'Fire'
            local success = gacha:InvokeServer(SelectedPower)
            if success then Fluent:Notify({Title = "Gacha", Content = "Spin Successful!"}) end
        end
    end
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
-- TAB: 99 Nights In the Forest
-- ============================================================
local ForestTab = Window:AddTab({ Title = "99 Nights", Icon = "trees" })

ForestTab:AddParagraph({
    Title   = "Forest Survival Utilities",
    Content = "Advanced item spawner and resource generators using Dex-verified remotes.",
})

-- 1. THE ITEM SELECTOR & GRABBER
local SelectedItem = "Old Axe"
local ItemList = {
    -- Sacks
    "Good Sack", "Infernal Sack", "Giant Sack",
    -- Axes
    "Old Axe", "Good Axe", "Ice Axe", "Strong Axe", "Chainsaw",
    -- Fishing
    "Old Rod", "Good Rod", "Strong Rod",
    -- Taming
    "Old Taming Flute", "Good Taming Flute", "Strong Taming Flute",
    -- Food
    "Carrot", "Corn", "Pumpkin", "Berry", "Apple", "Morsek", "Morsel", 
    "Cooked Morsel", "Steak", "Cooked Steak", "Ribs", "Cooked Ribs", 
    "Cake", "Chili", "Stew", "Meat Sandwich", "Steak Dinner", "Carrot cake", "Jar o' Jelly",
    -- Seeds
    "Chili Seeds", "Flower Seeds", "Berry Seeds", "Firefly Seeds", "Moonflower Seeds", "Mandrake Seeds",
    -- Weapons
    "Spear", "Morningstar", "Katana", "Laser Sword", "Scythe", "Poison Claws",
    -- Guns & Ammo
    "Revolver", "Rifle", "Tactical Shotgun", "Flamethrower", 
    "Revolver Ammo", "Rifle Ammo", "Shotgun Ammo", "Fuel Canister", "Oil Barrel",
    -- Armor
    "Leather Body", "Poison Body", "Iron Body", "Thorn Body", "Riot Shield", "Obsidiron Body"
}

ForestTab:AddDropdown("ItemSelector", {
    Title = "Select Item to Spawn",
    Values = ItemList,
    Default = "Old Axe",
    Callback = function(v)
        if not _G.Authorized then return end
        SelectedItem = v
    end,
})

ForestTab:AddButton({
    Title = "Grab Selected Item",
    Description = "Uses RequestOpenItemChest and UpdateMapCells from your Dex logs",
    Callback = function()
        if not _G.Authorized then return end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- Attempt 1: The Chest Remote Spoofer (High Success Rate)
        local chestRemote = game:GetService("ReplicatedStorage"):FindFirstChild("RequestOpenItemChest", true)
        -- Attempt 2: The Map Cell Update (Force Spawn)
        local mapRemote = game:GetService("ReplicatedStorage"):FindFirstChild("UpdateMapCells", true)

        if chestRemote then
            pcall(function()
                chestRemote:FireServer(SelectedItem)
            end)
            Fluent:Notify({Title = "Spawn Attempted", Content = "Using Chest-Path for " .. SelectedItem})
        elseif mapRemote then
            pcall(function()
                mapRemote:FireServer(SelectedItem, root.Position + root.CFrame.LookVector * 5)
            end)
            Fluent:Notify({Title = "Spawn Attempted", Content = "Using Map-Path for " .. SelectedItem})
        else
            Fluent:Notify({Title = "Remote Error", Content = "Open a chest/interact with a resource to reveal remotes!"})
        end
    end
})

-- 2. AUTOMATED CHEST & SCRAP (DEX SYNCED)
ForestTab:AddSection("Auto-Farm")

ForestTab:AddToggle("AutoChest", {
    Title = "Auto Open All Chests",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.ForestChest = v
        task.spawn(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RequestOpenItemChest", true)
            while _G.ForestChest do
                if remote then
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name:find("Chest") or obj.Name:find("Supply") then
                            remote:FireServer(obj)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

ForestTab:AddToggle("AutoScrap", {
    Title = "Auto Scrap All Items",
    Description = "Uses ScrapItem to clear backpack",
    Default = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.ForestScrap = v
        task.spawn(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ScrapItem", true)
            while _G.ForestScrap do
                if remote then
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        remote:FireServer(item)
                    end
                end
                task.wait(2)
            end
        end)
    end
})

-- 3. RESOURCE SPAWNING
ForestTab:AddSection("Resources")

ForestTab:AddButton({
    Title = "Spawn Wood Bundle",
    Callback = function()
        if not _G.Authorized then return end
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("UpdateMapCells", true)
        if remote then
            remote:FireServer("Wood", LocalPlayer.Character.HumanoidRootPart.Position)
        end
    end
})

ForestTab:AddButton({
    Title = "Spawn Coal Stack",
    Callback = function()
        if not _G.Authorized then return end
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("UpdateMapCells", true)
        if remote then
            remote:FireServer("Coal", LocalPlayer.Character.HumanoidRootPart.Position)
        end
    end
})


-- ============================================================
-- TAB: LUCKYBLOCK (REPLACEMENT & UI FIX)
-- ============================================================
local LuckyTab = Window:AddTab({ Title = "LuckyBlock", Icon = "box" })

-- FIXED AUTO SELL: Clicks the UI button at the top
LuckyTab:AddToggle("AutoSellLucky", {
    Title    = "Auto Sell (UI Click)",
    Default  = false,
    Callback = function(v)
        if not _G.Authorized then return end
        _G.AutoSell = v
        task.spawn(function()
            while _G.AutoSell do
                -- Locates the 'Sell' button from your UI screenshot
                local sellBtn = LocalPlayer.PlayerGui:FindFirstChild("Sell", true) or LocalPlayer.PlayerGui:FindFirstChild("SellBtn", true)
                if sellBtn and sellBtn:IsA("GuiButton") then
                    -- Simulates a physical click on the button
                    firesignal(sellBtn.MouseButton1Click)
                end
                task.wait(1)
            end
        end)
    end,
})

-- FIXED TELEPORT: TPs to your own base instead of a safe zone
LuckyTab:AddButton({
    Title    = "Teleport to My Base",
    Callback = function()
        if not _G.Authorized then return end
        for _, base in pairs(workspace:FindFirstChild("Bases"):GetChildren()) do
            if base:FindFirstChild("Owner") and base.Owner.Value == LocalPlayer.Name then
                LocalPlayer.Character.HumanoidRootPart.CFrame = base.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                Fluent:Notify({Title = "Success", Content = "Arrived at Base!"})
                return
            end
        end
        Fluent:Notify({Title = "Error", Content = "Could not find your base!"})
    end,
})

--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║           AETHERIUS — CLIENT ADMIN PANEL v4.0               ║
    ║           Aetherius Nexus | Client-Side Only                ║
    ║           LocalScript → StarterPlayerScripts               ║
    ╚══════════════════════════════════════════════════════════════╝
    
    
    GAMEPASS ID: 1808462490 with your actual gamepass ID
    for premium detection to work.
    
    NOTE: All commands are CLIENT-SIDE only. They affect only what
    YOU see and how YOUR character behaves. Server-side things like
    other players' health are not touched.
--]]

-- ============================================================
--  SERVICES
-- ============================================================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local Lighting           = game:GetService("Lighting")
local SoundService       = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService        = game:GetService("HttpService")
local StarterGui         = game:GetService("StarterGui")

-- ============================================================
--  CORE REFERENCES
-- ============================================================
local LP      = Players.LocalPlayer
local Char    = LP.Character or LP.CharacterAdded:Wait()
local Root    = Char:WaitForChild("HumanoidRootPart")
local Hum     = Char:WaitForChild("Humanoid")
local Camera  = workspace.CurrentCamera
local Mouse   = LP:GetMouse()

-- ============================================================
--  CONFIG
-- ============================================================
local CONFIG = {
    TOGGLE_KEY     = Enum.KeyCode.Semicolon,  -- ; to open/close
    CMD_PREFIX     = ";",
    PANEL_TITLE    = "AETHERIUS",
    VERSION        = "4.0",
    GAMEPASS_ID    = 1808462490,  -- ← Replace with your Gamepass ID (number)
    THEME = {
        BG          = Color3.fromRGB(8,  0,  12),
        SURFACE     = Color3.fromRGB(18, 0,  24),
        SURFACE2    = Color3.fromRGB(26, 0,  34),
        BORDER      = Color3.fromRGB(80, 0, 100),
        RED         = Color3.fromRGB(192, 57, 43),
        RED_BRIGHT  = Color3.fromRGB(231, 76, 60),
        PURPLE      = Color3.fromRGB(108, 43, 179),
        PURPLE_LT   = Color3.fromRGB(155, 89, 182),
        GOLD        = Color3.fromRGB(243, 156, 18),
        TEXT        = Color3.fromRGB(232, 212, 240),
        TEXT2       = Color3.fromRGB(180, 158, 200),
        TEXT3       = Color3.fromRGB(120,  90, 140),
        GREEN       = Color3.fromRGB(46, 204, 113),
        CYAN        = Color3.fromRGB(0, 212, 255),
    },
}

-- ============================================================
--  STATE
-- ============================================================
local State = {
    PanelOpen      = false,
    Flying         = false,
    Noclip         = false,
    GodMode        = false,
    InfJump        = false,
    AutoHeal       = false,
    SpeedMult      = 1,
    FlySpeed       = 60,
    Frozen         = false,
    AntiAFK        = false,
    ESPEnabled     = false,
    AutoFarm       = false,
    SpinEnabled    = false,
    RainbowBody    = false,
    NeonAura       = false,
    CurrentTab     = "movement",
    Connections    = {},
    ESPObjects     = {},
    Premium        = false,
    SpinSpeed      = 10,
    FlyBody        = nil,
    FlyGyro        = nil,
    AutoFarmConn   = nil,
}

-- ============================================================
--  PREMIUM CHECK
-- ============================================================
local function CheckPremium()
    if CONFIG.GAMEPASS_ID == 0 then
        State.Premium = false
        return
    end
    local ok, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(LP.UserId, CONFIG.GAMEPASS_ID)
    end)
    State.Premium = ok and owns or false
end
pcall(CheckPremium)

-- ============================================================
--  UTILITY
-- ============================================================
local function Notify(title, body, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = "⬡ " .. title,
            Text     = body,
            Duration = duration,
        })
    end)
end

local function GetCharParts()
    Char = LP.Character
    if not Char then return nil, nil, nil end
    Root = Char:FindFirstChild("HumanoidRootPart")
    Hum  = Char:FindFirstChildOfClass("Humanoid")
    return Char, Root, Hum
end

local function Disconnect(name)
    if State.Connections[name] then
        State.Connections[name]:Disconnect()
        State.Connections[name] = nil
    end
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

-- ============================================================
--  CHARACTER REFRESH
-- ============================================================
LP.CharacterAdded:Connect(function(newChar)
    Char = newChar
    Root = newChar:WaitForChild("HumanoidRootPart")
    Hum  = newChar:WaitForChild("Humanoid")
    -- Re-apply persistent states
    task.wait(0.5)
    if State.GodMode then Hum.MaxHealth = math.huge; Hum.Health = math.huge end
    if State.InfJump then
        State.Connections["infjump"] = UserInputService.JumpRequest:Connect(function()
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
    if State.AntiAFK then
        local vrs = LP:FindFirstChild("VirtualUser") or Instance.new("VirtualUser", LP)
        vrs:Button2Down(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- ============================================================
--                    COMMAND IMPLEMENTATIONS
-- ============================================================

-- ── MOVEMENT ──────────────────────────────────────────────

local function CMD_Fly()
    local c, r, h = GetCharParts()
    if not r then return end
    if State.Flying then
        State.Flying = false
        Disconnect("fly")
        if State.FlyBody   then State.FlyBody:Destroy()   end
        if State.FlyGyro   then State.FlyGyro:Destroy()   end
        h.PlatformStand = false
        Notify("Fly", "Disabled")
        return
    end
    State.Flying = true
    h.PlatformStand = true

    local bp = Instance.new("BodyPosition", r)
    bp.MaxForce = Vector3.new(1e6,1e6,1e6)
    bp.P = 5e4; bp.D = 2000
    bp.Position = r.Position
    State.FlyBody = bp

    local bg = Instance.new("BodyGyro", r)
    bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
    bg.CFrame = r.CFrame
    State.FlyGyro = bg

    State.Connections["fly"] = RunService.RenderStepped:Connect(function()
        if not State.Flying then return end
        local speed = State.FlySpeed
        local cf = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        bp.Position = bp.Position + dir.Unit * (dir.Magnitude > 0 and speed * 0.05 or 0)
        bg.CFrame = cf
    end)
    Notify("Fly", "Enabled — WASD + Space/Shift")
end

local function CMD_Noclip()
    State.Noclip = not State.Noclip
    if State.Noclip then
        State.Connections["noclip"] = RunService.Stepped:Connect(function()
            if LP.Character then
                for _, p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
        Notify("NoClip", "Enabled — walk through walls")
    else
        Disconnect("noclip")
        Notify("NoClip", "Disabled")
    end
end

local function CMD_SetSpeed(mult)
    local _, _, h = GetCharParts()
    if not h then return end
    State.SpeedMult = mult
    h.WalkSpeed = 16 * mult
    Notify("Speed", "x" .. mult .. " (" .. (16 * mult) .. " studs/s)")
end

local function CMD_InfJump()
    State.InfJump = not State.InfJump
    if State.InfJump then
        State.Connections["infjump"] = UserInputService.JumpRequest:Connect(function()
            local _, _, h = GetCharParts()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        Notify("Infinite Jump", "Enabled")
    else
        Disconnect("infjump")
        Notify("Infinite Jump", "Disabled")
    end
end

local function CMD_MoonGravity()
    workspace.Gravity = 20
    Notify("Moon Gravity", "Gravity set to 20")
end

local function CMD_ZeroGravity()
    workspace.Gravity = 0
    Notify("Zero Gravity", "Gravity set to 0")
end

local function CMD_NormalGravity()
    workspace.Gravity = 196.2
    Notify("Normal Gravity", "Restored")
end

local function CMD_SuperJump(power)
    local _, _, h = GetCharParts()
    if not h then return end
    h.JumpPower = power or 200
    Notify("Jump Power", "Set to " .. (power or 200))
end

local function CMD_Teleport(pos)
    local _, r = GetCharParts()
    if r then r.CFrame = CFrame.new(pos) end
end

local function CMD_BunnyHop()
    State.Connections["bhop"] = UserInputService.JumpRequest:Connect(function()
        task.wait(0.05)
        local _, _, h = GetCharParts()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    Notify("BunnyHop", "Active — keep jumping!")
end

local function CMD_Dash()
    local _, r, h = GetCharParts()
    if not r or not h then return end
    local cf = Camera.CFrame
    local impulse = cf.LookVector * 120
    local bv = Instance.new("BodyVelocity", r)
    bv.Velocity = impulse; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    game:GetService("Debris"):AddItem(bv, 0.15)
    Notify("Dash", "Forward dash!")
end

-- ── CHARACTER ─────────────────────────────────────────────

local function CMD_GodMode()
    State.GodMode = not State.GodMode
    local _, _, h = GetCharParts()
    if not h then return end
    if State.GodMode then
        h.MaxHealth = math.huge
        h.Health    = math.huge
        State.Connections["godmode"] = RunService.Heartbeat:Connect(function()
            local _, _, hh = GetCharParts()
            if hh then hh.Health = math.huge end
        end)
        Notify("God Mode", "ENABLED — immortal")
    else
        h.MaxHealth = 100
        h.Health    = 100
        Disconnect("godmode")
        Notify("God Mode", "Disabled")
    end
end

local function CMD_Scale(s)
    local c = LP.Character
    if not c then return end
    for _, desc in ipairs(c:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.Size = desc.Size * s
        end
    end
    Notify("Scale", "Applied x" .. s)
end

local function CMD_Spin()
    State.SpinEnabled = not State.SpinEnabled
    if State.SpinEnabled then
        State.Connections["spin"] = RunService.Heartbeat:Connect(function()
            local _, r = GetCharParts()
            if r then
                r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0)
            end
        end)
        Notify("Spin", "Spinning at speed " .. State.SpinSpeed)
    else
        Disconnect("spin")
        Notify("Spin", "Stopped")
    end
end

local function CMD_Freeze()
    State.Frozen = not State.Frozen
    local _, r, h = GetCharParts()
    if not r then return end
    if State.Frozen then
        r.Anchored = true
        Notify("Freeze", "You are frozen in place")
    else
        r.Anchored = false
        Notify("Freeze", "Unfrozen")
    end
end

local function CMD_Ragdoll()
    local c, _, h = GetCharParts()
    if not c or not h then return end
    h:ChangeState(Enum.HumanoidStateType.Ragdoll)
    Notify("Ragdoll", "Ragdolled!")
end

local function CMD_Invisible()
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then
            p.Transparency = 1
        end
    end
    Notify("Invisible", "You are now invisible (client-side)")
end

local function CMD_Visible()
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 0
        elseif p:IsA("Decal") then
            p.Transparency = 0
        end
    end
    Notify("Visible", "Restored visibility")
end

-- ── VISUAL FX ─────────────────────────────────────────────

local function CMD_RainbowBody()
    State.RainbowBody = not State.RainbowBody
    if State.RainbowBody then
        State.Connections["rainbow"] = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local t = tick()
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = Color3.fromHSV((t * 0.3 + p.Position.X * 0.01) % 1, 1, 1)
                end
            end
        end)
        Notify("Rainbow Body", "Enabled")
    else
        Disconnect("rainbow")
        Notify("Rainbow Body", "Disabled")
    end
end

local function CMD_NeonAura()
    State.NeonAura = not State.NeonAura
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    if State.NeonAura then
        local sel = Instance.new("SelectionBox", workspace)
        sel.Adornee = c
        sel.Color3 = CONFIG.THEME.PURPLE_LT
        sel.LineThickness = 0.08
        sel.Name = "_AethNeonAura"
        Notify("Neon Aura", "Enabled")
    else
        local found = workspace:FindFirstChild("_AethNeonAura")
        if found then found:Destroy() end
        Notify("Neon Aura", "Disabled")
    end
end

local function CMD_FireEffect()
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local existing = r:FindFirstChild("_AethFire")
    if existing then existing:Destroy(); Notify("Fire FX", "Removed"); return end
    local fire = Instance.new("Fire", r)
    fire.Name = "_AethFire"
    fire.Size = 6; fire.Heat = 12
    fire.Color = Color3.fromRGB(192,57,43)
    fire.SecondaryColor = Color3.fromRGB(108,43,179)
    Notify("Fire FX", "Blazing!")
end

local function CMD_SparkleEffect()
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local existing = r:FindFirstChild("_AethSparkle")
    if existing then existing:Destroy(); Notify("Sparkle FX", "Removed"); return end
    local sp = Instance.new("Sparkles", r)
    sp.Name = "_AethSparkle"
    sp.SparkleColor = CONFIG.THEME.PURPLE_LT
    Notify("Sparkle FX", "Enabled")
end

local function CMD_SmokeAura()
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local existing = r:FindFirstChild("_AethSmoke")
    if existing then existing:Destroy(); Notify("Smoke Aura", "Removed"); return end
    local s = Instance.new("Smoke", r)
    s.Name = "_AethSmoke"
    s.Size = 4; s.Opacity = 0.4
    s.Color = Color3.fromRGB(50,0,70)
    Notify("Smoke Aura", "Enabled")
end

local function CMD_GlowSkin(color)
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = Enum.Material.Neon
            p.Color = color or CONFIG.THEME.PURPLE_LT
        end
    end
    Notify("Glow Skin", "Neon material applied")
end

local function CMD_NormalSkin()
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = Enum.Material.SmoothPlastic
        end
    end
    Notify("Skin Reset", "Normal material restored")
end

local function CMD_GlitchEffect()
    State.Connections["glitch"] = RunService.Heartbeat:Connect(function()
        local _, r = GetCharParts()
        if r then
            r.CFrame = r.CFrame * CFrame.new(
                math.random(-10,10)/30,
                math.random(-5,5)/30,
                math.random(-10,10)/30
            )
        end
    end)
    task.delay(3, function()
        Disconnect("glitch")
        Notify("Glitch FX", "Effect ended")
    end)
    Notify("Glitch FX", "3 seconds of chaos!")
end

-- ── WORLD / ENVIRONMENT ───────────────────────────────────

local function CMD_TimeOfDay(hour)
    Lighting.TimeOfDay = string.format("%02d:00:00", hour)
    Notify("Time", "Set to " .. hour .. ":00")
end

local function CMD_Ambient(color)
    Lighting.Ambient = color
    Lighting.OutdoorAmbient = color
end

local function CMD_Brightness(val)
    Lighting.Brightness = val
    Notify("Brightness", "Set to " .. val)
end

local function CMD_FogRange(near, far)
    Lighting.FogStart = near
    Lighting.FogEnd   = far
    Notify("Fog", "near=" .. near .. " far=" .. far)
end

local function CMD_ClearFog()
    Lighting.FogEnd = 100000
    Lighting.FogStart = 99999
    Notify("Fog", "Cleared")
end

local function CMD_NightVision()
    Lighting.Brightness = 3
    Lighting.Ambient = Color3.fromRGB(100, 200, 100)
    Lighting.OutdoorAmbient = Color3.fromRGB(80, 180, 80)
    Notify("Night Vision", "Green vision enabled")
end

local function CMD_InvertColors()
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "_AethInvert"
    cc.Brightness = -1
    cc.Saturation = -2
    cc.TintColor = Color3.fromRGB(255,255,255)
    task.delay(5, function() cc:Destroy() end)
    Notify("Invert Colors", "5 seconds")
end

local function CMD_BloodMoon()
    Lighting.TimeOfDay = "00:00:00"
    Lighting.Ambient = Color3.fromRGB(80,0,0)
    Lighting.OutdoorAmbient = Color3.fromRGB(60,0,0)
    Lighting.FogColor = Color3.fromRGB(100,0,0)
    Lighting.FogEnd = 300
    Lighting.FogStart = 50
    Notify("Blood Moon", "The sky bleeds...")
end

local function CMD_ResetLighting()
    Lighting.TimeOfDay = "14:00:00"
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(70,70,70)
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 99999
    Notify("Lighting", "Reset to default")
end

-- ── CAMERA ────────────────────────────────────────────────

local function CMD_FreeCam()
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    local pos = cam.CFrame
    State.Connections["freecam"] = RunService.RenderStepped:Connect(function()
        local speed = 1
        local cf = cam.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then pos = pos * CFrame.new(0,0,-speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then pos = pos * CFrame.new(0,0,speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then pos = pos * CFrame.new(-speed,0,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then pos = pos * CFrame.new(speed,0,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then pos = pos * CFrame.new(0,speed,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then pos = pos * CFrame.new(0,-speed,0) end
        cam.CFrame = pos
    end)

-- ============================================================
-- AETHERIUS NEXUS - GLOBAL SETTINGS & SHIELD SYSTEM
-- ============================================================

-- 1. GAME IDENTIFICATION DATA
local GameIDs = {
    ["MM2"]            = {142823291, 335132309}, 
    ["Arsenal"]        = 286090429,              
    ["Blox Fruits"]    = {2753915549, 4442272183, 7449925065}, 
    ["99 Nights"]      = 13865613310,            
    ["AFS"]            = 130247632398296,
    ["Pet Sim"]        = 15992815145,
    ["Doors"]          = 6516141723,
    ["NDS"]            = 18884496,
    ["BrookHaven"]   = 4924922222,
    [ "Be A Lucky Block"] = 124473577469410,
    ["Lumber Tycoon 2"] = 13822889
}

-- 2. THE GLOBAL SHIELD (Invisible Protection)
_G.GameLock = true
_G.isGame = function(target)
    local currentId = game.PlaceId
    if type(target) == "table" then
        for _, id in pairs(target) do if currentId == id then return true end end
    elseif currentId == target then
        return true
    end
    return false
end

-- 3. SETTINGS TAB UI
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

SettingsTab:AddSection("Appearance")

-- Fixed theme dropdown with proper default detection
local currentTheme = "Dark" -- Set your actual default theme here
SettingsTab:AddDropdown("ThemeDropdown", {
    Title   = "UI Theme",
    Values  = { "Dark", "Light", "Amethyst", "Aqua", "Ocean", "Rose", "Gold", "Emerald" },
    Default = currentTheme, -- Now shows correct default
    Callback = function(v)
        if (v == "Gold" or v == "Emerald") then
            if not _G.Authorized then
                Fluent:Notify({
                    Title = "Premium Required", 
                    Content = "Please verify your license to unlock " .. v .. "!",
                    Duration = 5
                })
                -- Reset dropdown to previous theme
                return
            end
            
            -- Fixed Premium Color Logic
            local premiumColor = (v == "Gold") and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(50, 205, 50)
            
            -- Properly apply custom theme
            Fluent:SetTheme("Dark") -- Base theme
            task.wait(0.1) -- Let base theme load
            
            -- Override accent colors
            if Fluent.Theme then
                Fluent.Theme.AccentColor = premiumColor
                Fluent.Theme.AccentColorDark = premiumColor
            end
            
            Fluent:Notify({
                Title = "Premium Theme Applied", 
                Content = v .. " theme is now active!",
                Duration = 3
            })
        else
            -- Apply standard themes
            Fluent:SetTheme(v)
            currentTheme = v
        end
    end,
})

SettingsTab:AddSection("Server Management")

-- SERVER HOP MOVED TO SETTINGS
SettingsTab:AddButton({
    Title = "Server Hop",
    Description = "Join a different server instance",
    Callback = function()
        if not _G.Authorized then 
            Fluent:Notify({
                Title = "Premium Feature", 
                Content = "Server hopping requires premium access!",
                Duration = 4
            })
            return 
        end
        
        Fluent:Notify({
            Title = "Server Hop", 
            Content = "Finding new server...",
            Duration = 2
        })
        
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        
        -- Add error handling
        local success, errorMsg = pcall(function()
            TeleportService:Teleport(PlaceId, game.Players.LocalPlayer)
        end)
        
        if not success then
            Fluent:Notify({
                Title = "Server Hop Failed", 
                Content = "Could not find available servers",
                Duration = 3
            })
        end
    end,
})

SettingsTab:AddSection("Safety & Performance")

SettingsTab:AddToggle("GameLockToggle", {
    Title    = "Global Game-Lock",
    Description = "Blocks features if you are in the wrong game",
    Default  = true,
    Callback = function(v) 
        _G.GameLock = v 
        Fluent:Notify({
            Title = "Game-Lock", 
            Content = "Protection is now " .. (v and "Enabled" or "Disabled"),
            Duration = 3
        })
    end,
})

SettingsTab:AddButton({
    Title    = "Reset All Toggles",
    Description = "Emergency stop for all features",
    Callback = function()
        -- Reset common globals
        _G.Aimbot = false
        _G.BoxESP = false
        _G.FlyEnabled = false
        _G.CoinFarm = false
        _G.SilentAim = false
        _G.BHopEnabled = false

       Fluent:Notify({ Title = "System Reset", Content = "All hub features have been disabled.", Duration = 3 })
    end,
})


SettingsTab:AddSection("Information")

SettingsTab:AddParagraph({
    Title   = "System Status",
    Content = "Place ID: " .. game.PlaceId .. "\nAccount: " .. (_G.Authorized and "Premium User" or "Free User") .. "\nVersion: V15.4 (2026 Stable)"
})

SettingsTab:AddParagraph({
    Title   = "Keybinds",
    Content = "Menu Toggle: RightShift\nFly: WASD + Space/Ctrl\nNoclip: Automatic when enabled"
})

-- Configuration Management
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

-- 4. APPLY AUTOMATIC DETECTION TO ALL TABS
-- This small loop checks every tab you created and injects the "You are not in this game" check.
task.spawn(function()
    task.wait(1) -- Wait for tabs to initialize
    for _, Tab in pairs(Window.Tabs) do
        local gameData = GameIDs[Tab.Title]
        if gameData then
            for _, Element in pairs(Tab.Elements) do
                if Element.Type == "Toggle" or Element.Type == "Button" then
                    local originalCallback = Element.Callback
                    Element.Callback = function(v)
                        if _G.GameLock and not _G.isGame(gameData) then
                            Fluent:Notify({
                                Title = "Action Blocked",
                                Content = "You are not in " .. Tab.Title .. "!",
                                Duration = 4
                            })
                            return
                        end
                        originalCallback(v)
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- DRAGGABLE TOGGLE BUTTON (ALPHA ICON) - FIXED VERSION
-- ============================================================
-- Destroy old toggle if re-executing
local oldToggle = CoreGui:FindFirstChild("AetheriusOfficialToggle")
if oldToggle then oldToggle:Destroy() end

local ToggleGUI = Instance.new("ScreenGui")
ToggleGUI.Name = "AetheriusOfficialToggle"
ToggleGUI.ResetOnSpawn = false
ToggleGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGUI.Parent = CoreGui

local AlphaBtn = Instance.new("ImageButton", ToggleGUI)
AlphaBtn.Size = UDim2.new(0, 56, 0, 56)
AlphaBtn.Position = UDim2.new(0, 20, 0.5, -28)
AlphaBtn.AnchorPoint = Vector2.new(0, 0)
AlphaBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
AlphaBtn.Image = "rbxassetid://98931289479698"
AlphaBtn.ImageColor3 = Color3.fromRGB(160, 30, 255)

local Corner = Instance.new("UICorner", AlphaBtn)
Corner.CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", AlphaBtn)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(200, 0, 255)

-- Dragging variables
local dragging = false
local dragStart = nil
local startPos = nil

-- Make draggable
AlphaBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = AlphaBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

AlphaBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        AlphaBtn.Position = newPosition
    end
end)

-- Toggle Window Visibility (Simulates LeftControl press)
local guiVisible = true
AlphaBtn.MouseButton1Click:Connect(function()
    -- Only toggle if not dragging
    if (dragStart and (AlphaBtn.Position.X.Offset ~= startPos.X.Offset or AlphaBtn.Position.Y.Offset ~= startPos.Y.Offset)) then
        dragStart = AlphaBtn.Position
        return
    end
    
    guiVisible = not guiVisible
    
    -- Simulate LeftControl key press to trigger Fluent's built-in toggle
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    
    -- Update button appearance
    Stroke.Color = guiVisible and Color3.fromRGB(200, 0, 255) or Color3.fromRGB(80, 80, 80)
    AlphaBtn.ImageColor3 = guiVisible and Color3.fromRGB(160, 30, 255) or Color3.fromRGB(100, 100, 100)
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
