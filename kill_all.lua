-- Delta Mobile Script: Menu Bảo Tuất (Kill/Win Tracker & Anti-Lag)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local RemoteFunction = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameRemoteFunction")

_G.AutoRoll = false
_G.AutoFarm = false
_G.AntiLag = false

local ATTACK_MULTIPLIER = 3 

-- ==========================================
-- 1. TẠO GIAO DIỆN UI (MENU BẢO TUẤT)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaoTuatMenu_V8"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Phủ tràn 100% màn hình

-- LỚP MÀN HÌNH XÁM (FLASH OVERLAY)
local GrayFlashFrame = Instance.new("Frame")
GrayFlashFrame.Name = "GrayFlashOverlay"
GrayFlashFrame.Parent = ScreenGui
GrayFlashFrame.Size = UDim2.new(1, 0, 1, 0)
GrayFlashFrame.Position = UDim2.new(0, 0, 0, 0)
GrayFlashFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GrayFlashFrame.BorderSizePixel = 0
GrayFlashFrame.Visible = false
GrayFlashFrame.ZIndex = 1

-- Nút mở/ẩn Menu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 85, 0, 45)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenBtn.Text = "BẢO TUẤT"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 14
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.ZIndex = 10

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 8)
OpenBtnCorner.Parent = OpenBtn

-- Khung chính Menu
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 330, 0, 260) -- Mở rộng chiều cao để chứa điểm Kill/Win
MainFrame.Position = UDim2.new(0.5, -165, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Text = "MENU BẢO TUẤT (SUPER FAST)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.ZIndex = 11

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Sidebar Chuyển Tab
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Parent = MainFrame
SidebarFrame.Size = UDim2.new(0, 85, 1, -35)
SidebarFrame.Position = UDim2.new(0, 0, 0, 35)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.ZIndex = 11

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Parent = SidebarFrame
MainTabBtn.Size = UDim2.new(1, -10, 0, 35)
MainTabBtn.Position = UDim2.new(0, 5, 0, 10)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.Text = "Main"
MainTabBtn.Font = Enum.Font.SourceSansBold
MainTabBtn.TextSize = 14
MainTabBtn.ZIndex = 12

local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 5)
MainTabCorner.Parent = MainTabBtn

local RandomTabBtn = Instance.new("TextButton")
RandomTabBtn.Parent = SidebarFrame
RandomTabBtn.Size = UDim2.new(1, -10, 0, 35)
RandomTabBtn.Position = UDim2.new(0, 5, 0, 50)
RandomTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RandomTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
RandomTabBtn.Text = "Random"
RandomTabBtn.Font = Enum.Font.SourceSansBold
RandomTabBtn.TextSize = 14
RandomTabBtn.ZIndex = 12

local RandomTabCorner = Instance.new("UICorner")
RandomTabCorner.CornerRadius = UDim.new(0, 5)
RandomTabCorner.Parent = RandomTabBtn

-- ------------------------------------------
-- Nội dung Tab Main
-- ------------------------------------------
local MainContent = Instance.new("Frame")
MainContent.Parent = MainFrame
MainContent.Size = UDim2.new(1, -95, 1, -45)
MainContent.Position = UDim2.new(0, 90, 0, 40)
MainContent.BackgroundTransparency = 1
MainContent.Visible = true
MainContent.ZIndex = 11

-- Nút Auto Farm
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = MainContent
FarmBtn.Size = UDim2.new(1, -10, 0, 35)
FarmBtn.Position = UDim2.new(0, 5, 0, 5)
FarmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Text = "Auto Farm Speed: OFF"
FarmBtn.Font = Enum.Font.SourceSansBold
FarmBtn.TextSize = 13
FarmBtn.ZIndex = 12

local FarmBtnCorner = Instance.new("UICorner")
FarmBtnCorner.CornerRadius = UDim.new(0, 6)
FarmBtnCorner.Parent = FarmBtn

-- Nút Giảm Lag
local LagBtn = Instance.new("TextButton")
LagBtn.Parent = MainContent
LagBtn.Size = UDim2.new(1, -10, 0, 35)
LagBtn.Position = UDim2.new(0, 5, 0, 45)
LagBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
LagBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LagBtn.Text = "Giảm Lag (Flash Xám): OFF"
LagBtn.Font = Enum.Font.SourceSansBold
LagBtn.TextSize = 13
LagBtn.ZIndex = 12

local LagBtnCorner = Instance.new("UICorner")
LagBtnCorner.CornerRadius = UDim.new(0, 6)
LagBtnCorner.Parent = LagBtn

-- BẢNG ĐẾM KILLS & WINS
local StatsFrame = Instance.new("Frame")
StatsFrame.Parent = MainContent
StatsFrame.Size = UDim2.new(1, -10, 0, 115)
StatsFrame.Position = UDim2.new(0, 5, 0, 85)
StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StatsFrame.BorderSizePixel = 0
StatsFrame.ZIndex = 12

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 6)
StatsCorner.Parent = StatsFrame

local KillsLabel = Instance.new("TextLabel")
KillsLabel.Parent = StatsFrame
KillsLabel.Size = UDim2.new(1, -10, 0, 50)
KillsLabel.Position = UDim2.new(0, 5, 0, 5)
KillsLabel.BackgroundTransparency = 1
KillsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
KillsLabel.Text = "KILLS: 0"
KillsLabel.Font = Enum.Font.SourceSansBold
KillsLabel.TextSize = 18
KillsLabel.ZIndex = 13

local WinsLabel = Instance.new("TextLabel")
WinsLabel.Parent = StatsFrame
WinsLabel.Size = UDim2.new(1, -10, 0, 50)
WinsLabel.Position = UDim2.new(0, 5, 0, 55)
WinsLabel.BackgroundTransparency = 1
WinsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
WinsLabel.Text = "WINS: 0"
WinsLabel.Font = Enum.Font.SourceSansBold
WinsLabel.TextSize = 18
WinsLabel.ZIndex = 13

-- ------------------------------------------
-- Nội dung Tab Random
-- ------------------------------------------
local RandomContent = Instance.new("Frame")
RandomContent.Parent = MainFrame
RandomContent.Size = UDim2.new(1, -95, 1, -45)
RandomContent.Position = UDim2.new(0, 90, 0, 40)
RandomContent.BackgroundTransparency = 1
RandomContent.Visible = false
RandomContent.ZIndex = 11

local RollBtn = Instance.new("TextButton")
RollBtn.Parent = RandomContent
RollBtn.Size = UDim2.new(1, -10, 0, 40)
RollBtn.Position = UDim2.new(0, 5, 0, 10)
RollBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
RollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RollBtn.Text = "Auto Roll Divine: OFF"
RollBtn.Font = Enum.Font.SourceSansBold
RollBtn.TextSize = 14
RollBtn.ZIndex = 12

local RollBtnCorner = Instance.new("UICorner")
RollBtnCorner.CornerRadius = UDim.new(0, 6)
RollBtnCorner.Parent = RollBtn

-- ==========================================
-- 2. TÍNH NĂNG XÓA HÌNH ẢNH BLOCK & FLASH XÁM
-- ==========================================
local function removeTextures()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
        end
    end
end

local function toggleAntiLag(enable)
    if enable then
        GrayFlashFrame.Visible = true
        removeTextures()
    else
        GrayFlashFrame.Visible = false
    end
end

-- ==========================================
-- 3. TỰ ĐỘNG CẬP NHẬT ĐIỂM KILL & WIN
-- ==========================================
local function updateStats()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local kills = leaderstats:FindFirstChild("Kills") or leaderstats:FindFirstChild("Kill") or leaderstats:FindFirstChild("Kills Count")
        local wins = leaderstats:FindFirstChild("Wins") or leaderstats:FindFirstChild("Win") or leaderstats:FindFirstChild("Wins Count")
        
        if kills then
            KillsLabel.Text = "KILLS: " .. tostring(kills.Value)
            kills.Changed:Connect(function(newVal)
                KillsLabel.Text = "KILLS: " .. tostring(newVal)
            end)
        end
        
        if wins then
            WinsLabel.Text = "WINS: " .. tostring(wins.Value)
            wins.Changed:Connect(function(newVal)
                WinsLabel.Text = "WINS: " .. tostring(newVal)
            end)
        end
    end
end

task.spawn(updateStats)

-- ==========================================
-- 4. XỬ LÝ SỰ KIỆN NÚT BẤM & TAB
-- ==========================================
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    RandomContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RandomTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    RandomTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

RandomTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    RandomContent.Visible = true
    RandomTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    RandomTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

FarmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        FarmBtn.Text = "Auto Farm Speed: ON"
    else
        FarmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        FarmBtn.Text = "Auto Farm Speed: OFF"
    end
end)

LagBtn.MouseButton1Click:Connect(function()
    _G.AntiLag = not _G.AntiLag
    if _G.AntiLag then
        LagBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        LagBtn.Text = "Giảm Lag (Flash Xám): ON"
        toggleAntiLag(true)
    else
        LagBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        LagBtn.Text = "Giảm Lag (Flash Xám): OFF"
        toggleAntiLag(false)
    end
end)

RollBtn.MouseButton1Click:Connect(function()
    _G.AutoRoll = not _G.AutoRoll
    if _G.AutoRoll then
        RollBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        RollBtn.Text = "Auto Roll Divine: ON"
    else
        RollBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        RollBtn.Text = "Auto Roll Divine: OFF"
    end
end)

-- ==========================================
-- 5. TỰ ĐỘNG CẦM VŨ KHÍ
-- ==========================================
local function equipAnyWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then return item end
    end
    
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            item.Parent = char
            return item
        end
    end
    return nil
end

-- ==========================================
-- 6. AUTO ROLL DIVINE (TAB RANDOM)
-- ==========================================
task.spawn(function()
    local gachaArgs = { [1] = "AttemptRollGachaChest", [2] = "Divine" }
    while true do
        if _G.AutoRoll then
            pcall(function()
                RemoteFunction:InvokeServer(unpack(gachaArgs))
            end)
        end
        task.wait(0.01)
    end
end)

-- ==========================================
-- 7. AUTO FARM SIÊU TỐC ĐỘ (TAB MAIN)
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoFarm then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        local weapon = equipAnyWeapon()
        
        if weapon and char and char:FindFirstChild("HumanoidRootPart") then
            local myHrp = char.HumanoidRootPart
            
            for i = 1, ATTACK_MULTIPLIER do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = player.Character:FindFirstChild("Humanoid")
                        
                        if targetHrp and targetHum and targetHum.Health > 0 then
                            local attackArgs = {
                                [1] = "AttemptWeaponHit",
                                [2] = {
                                    ["attackCycleData"] = {
                                        ["lungeMult"] = 0,
                                        ["slowMult"] = 0,
                                        ["attackTime"] = 0,
                                        ["knockbackMult"] = 0,
                                        ["slowTime"] = 0
                                    },
                                    ["knockback"] = 0,
                                    ["shouldLock"] = false,
                                    ["shouldLunge"] = false,
                                    ["hitboxOffset"] = Vector3.new(0, 0, 0),
                                    ["isCritical"] = true,
                                    ["shouldSlow"] = false,
                                    ["attackCooldown"] = 0,
                                    ["damage"] = 100,
                                    ["lungeKnockback"] = 0,
                                    ["cycleIndex"] = 1,
                                    ["hitboxSize"] = Vector3.new(9999, 9999, 9999),
                                    ["weaponDefinition"] = {
                                        ["attackCycle"] = {
                                            ["1"] = {["knockbackMul"] = 0, ["slowMult"] = 0, ["attackTime"] = 0, ["lungeMul"] = 0, ["slowTime"] = 0}
                                        },
                                        ["attackOrder"] = {[1] = "1"}
                                    },
                                    ["tool"] = weapon,
                                    ["slowTime"] = 0
                                },
                                [3] = {
                                    [1] = {
                                        ["knockback"] = 0,
                                        ["isClosestEnemy"] = true,
                                        ["origin"] = myHrp.Position,
                                        ["enemyModel"] = player.Character,
                                        ["distance"] = 0,
                                        ["direction"] = Vector3.new(0, 0, 0)
                                    }
                                }
                            }
                            task.spawn(function()
                                RemoteFunction:InvokeServer(unpack(attackArgs))
                            end)
                        end
                    end
                end
            end
        end
    end)
end)
