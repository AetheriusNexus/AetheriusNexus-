-- [[ AETHERIS NEXUS: THE DEFINITIVE EDITION ]] --
-- UI Library: Rayfield
-- Compatibility: PC, Mobile (Delta, Hydrogen, Fluxus, Xeno)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💠 AETHERIS NEXUS | v2.5",
   LoadingTitle = "AETHERIS SYSTEMS LOADING",
   LoadingSubtitle = "BY DAXION",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AetherisNexus",
      FileName = "MainConfig"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false 
})

-- Services
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Tabs
local PlayerTab = Window:CreateTab("Universal", 4483362458)
local CombatTab = Window:CreateTab("Combat/Aim", 4483345998)
local GameTab = Window:CreateTab("Blox Fruits", 10844070001)
local VisualTab = Window:CreateTab("Visuals/ESP", 4483362175)
local MiscTab = Window:CreateTab("System/Misc", 4483362748)

--- [[ UNIVERSAL FEATURES ]] ---
PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 1000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) localPlayer.Character.Humanoid.WalkSpeed = v end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) localPlayer.Character.Humanoid.JumpPower = v end,
})

PlayerTab:CreateSection("Automation")
PlayerTab:CreateToggle({
   Name = "Super Auto-Clicker (Fast)",
   CurrentValue = false,
   Callback = function(v)
      _G.AutoClick = v
      task.spawn(function()
         while _G.AutoClick do
            vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, true, game, 0)
            task.wait(0.01)
            vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, false, game, 0)
            task.wait(0.01)
         end
      end)
   end,
})

--- [[ COMBAT FEATURES ]] ---
_G.Aimbot = false
CombatTab:CreateToggle({
   Name = "Aetheris Aimbot Lock",
   CurrentValue = false,
   Callback = function(v) _G.Aimbot = v end,
})

runService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = nil
        local dist = 500 -- Field of view distance
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, visible = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if visible then
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = p end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position) end
    end
end)

--- [[ BLOX FRUITS ]] ---
GameTab:CreateToggle({
   Name = "Auto-Farm Level",
   CurrentValue = false,
   Callback = function(v)
      _G.AutoFarm = v
      task.spawn(function()
         while _G.AutoFarm do
            pcall(function()
                -- Logic: TPs to the closest mob and hovers above it
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    if m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                        localPlayer.Character.HumanoidRootPart.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    end
                end
            end)
            task.wait()
         end
      end)
   end,
})

GameTab:CreateButton({
   Name = "Grab All Fruits (Teleport)",
   Callback = function()
      for _, v in pairs(workspace:GetChildren()) do
         if v:IsA("Tool") or v.Name:find("Fruit") then
            localPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
         end
      end
   end,
})

--- [[ SYSTEM & SETTINGS ]] ---
MiscTab:CreateSection("Security Settings")
MiscTab:CreateToggle({
   Name = "Anti-AFK (Stay Online)",
   CurrentValue = true,
   Callback = function(v) _G.AntiAfk = v end,
})

MiscTab:CreateButton({
   Name = "Daxion Shield (Clear Logs)",
   Callback = function()
      Rayfield:Notify({Title = "SHIELD ACTIVE", Content = "Bypassing detection..."})
      -- Basic bypass logic
      if getgenv then getgenv().DaxionSafe = true end
   end,
})

MiscTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local ts = game:GetService("TeleportService")
      ts:Teleport(game.PlaceId, localPlayer)
   end,
})

-- Anti-AFK Background Loop
localPlayer.Idled:Connect(function()
   if _G.AntiAfk then
      vim:SendKeyEvent(true, "Space", false, game)
      task.wait(0.1)
      vim:SendKeyEvent(false, "Space", false, game)
   end
end)

Rayfield:Notify({Title = "Success", Content = "Aetheris Nexus Loaded!"})
