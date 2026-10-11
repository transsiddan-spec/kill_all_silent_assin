-- Delta Mobile: Moon Z Hub (Full Background Edition)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local USER_IMAGE_ID = "rbxassetid://96788060790426"
local ATTACK_MULTIPLIER = 3

_G.AutoRoll = false
_G.AutoFarm = false
_G.AntiLag = false

local uiParent = (gethui and gethui()) or CoreGui

if uiParent:FindFirstChild("MoonZ_NewMenu") then
    uiParent:FindFirstChild("MoonZ_NewMenu"):Destroy()
end

-- ==========================================
-- 1. KHỞI TẠO GIAO DIỆN UI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonZ_NewMenu"
ScreenGui.Parent = uiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- LỚP OVERLAY GIẢM LAG
local GrayOverlay = Instance.new("Frame")
GrayOverlay.Name = "GrayOverlay"
GrayOverlay.Parent = ScreenGui
GrayOverlay.Size = UDim2.new(1, 0, 1, 0)
GrayOverlay.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GrayOverlay.BorderSizePixel = 0
GrayOverlay.Visible = false
GrayOverlay.ZIndex = 1

-- NÚT MỞ MENU (CHỈ CÓ ICON MOON Z)
local OpenIconBtn = Instance.new("ImageButton")
OpenIconBtn.Name = "OpenIconBtn"
OpenIconBtn.Parent = ScreenGui
OpenIconBtn.Size = UDim2.new(0, 50, 0, 50)
OpenIconBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
OpenIconBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
OpenIconBtn.Image = USER_IMAGE_ID
OpenIconBtn.Draggable = true
OpenIconBtn.Active = true
OpenIconBtn.ZIndex = 9999

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenIconBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenIconBtn
OpenStroke.Color = Color3.fromRGB(150, 0, 255)
OpenStroke.Thickness = 2

-- KHUNG MENU CHÍNH
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 340, 0, 260)
MainWindow.Position = UDim2.new(0.5, -170, 0.5, -130)
MainWindow.BackgroundColor3 = Color3.fromRGB(16, 10, 24)
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true -- Giúp ảnh nền ôm sát góc bo tròn của Menu
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Visible = true
MainWindow.ZIndex = 100

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainWindow
MainStroke.Color = Color3.fromRGB(130, 0, 230)
MainStroke.Thickness = 1.5

-- 🌌 FULL BACKGROUND ẢNH MOON Z TRONG MENU
local MenuBackground = Instance.new("ImageLabel")
MenuBackground.Name = "MenuBackground"
MenuBackground.Parent = MainWindow
MenuBackground.Size = UDim2.new(1, 0, 1, 0)
MenuBackground.Position = UDim2.new(0, 0, 0, 0)
MenuBackground.BackgroundTransparency = 1
MenuBackground.Image = USER_IMAGE_ID
MenuBackground.ImageTransparency = 0.6 -- Độ mờ nền (có thể chỉnh từ 0.5 đến 0.7)
MenuBackground.ScaleType = Enum.ScaleType.Crop
MenuBackground.ZIndex = 100

-- TIÊU ĐỀ
local Header = Instance.new("Frame")
Header.Parent = MainWindow
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(28, 16, 42)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.ZIndex = 101

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Parent = Header
HeaderLogo.Size = UDim2.new(0, 24, 0, 24)
HeaderLogo.Position = UDim2.new(0, 8, 0, 7)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = USER_IMAGE_ID
HeaderLogo.ZIndex = 102

local HeaderText = Instance.new("TextLabel")
HeaderText.Parent = Header
HeaderText.Size = UDim2.new(1, -40, 1, 0)
HeaderText.Position = UDim2.new(0, 38, 0, 0)
HeaderText.BackgroundTransparency = 1
HeaderText.TextColor3 = Color3.fromRGB(200, 120, 255)
HeaderText.Text = "MOON Z HUB"
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextSize = 15
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.ZIndex = 102

-- KHU VỰC CHUYỂN TAB (SIDEBAR)
local TabBar = Instance.new("Frame")
TabBar.Parent = MainWindow
TabBar.Size = UDim2.new(0, 95, 1, -38)
TabBar.Position = UDim2.new(0, 0, 0, 38)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 14, 32)
TabBar.BackgroundTransparency = 0.4
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 101

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Parent = TabBar
MainTabBtn.Size = UDim2.new(1, -10, 0, 34)
MainTabBtn.Position = UDim2.new(0, 5, 0, 10)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.Text = "Main"
MainTabBtn.Font = Enum.Font.SourceSansBold
MainTabBtn.TextSize = 13
MainTabBtn.ZIndex = 102

local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 6)
MainTabCorner.Parent = MainTabBtn

local RandomTabBtn = Instance.new("TextButton")
RandomTabBtn.Parent = TabBar
RandomTabBtn.Size = UDim2.new(1, -10, 0, 34)
RandomTabBtn.Position = UDim2.new(0, 5, 0, 50)
RandomTabBtn.BackgroundColor3 = Color3.fromRGB(35, 22, 50)
RandomTabBtn.BackgroundTransparency = 0.3
RandomTabBtn.TextColor3 = Color3.fromRGB(170, 140, 200)
RandomTabBtn.Text = "Random"
RandomTabBtn.Font = Enum.Font.SourceSansBold
RandomTabBtn.TextSize = 13
RandomTabBtn.ZIndex = 102

local RandomTabCorner = Instance.new("UICorner")
RandomTabCorner.CornerRadius = UDim.new(0, 6)
RandomTabCorner.Parent = RandomTabBtn

-- NỘI DUNG TAB MAIN
local MainContainer = Instance.new("Frame")
MainContainer.Parent = MainWindow
MainContainer.Size = UDim2.new(1, -105, 1, -48)
MainContainer.Position = UDim2.new(0, 100, 0, 42)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.ZIndex = 101

-- Hàm tạo hàng công tắc (Toggle Row)
local function createToggleRow(parent, text, pos, callback)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.Size = UDim2.new(1, -10, 0, 36)
    row.Position = pos
    row.BackgroundColor3 = Color3.fromRGB(28, 18, 42)
    row.BackgroundTransparency = 0.3
    row.ZIndex = 102

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 103

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = row
    toggleBtn.Size = UDim2.new(0, 60, 0, 24)
    toggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 12
    toggleBtn.ZIndex = 103

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
            toggleBtn.Text = "OFF"
        end
        callback(state)
    end)
    return row
end

-- TẠO CÁC NÚT TÍNH NĂNG
createToggleRow(MainContainer, "Auto Farm", UDim2.new(0, 5, 0, 5), function(val)
    _G.AutoFarm = val
end)

createToggleRow(MainContainer, "Giảm Lag", UDim2.new(0, 5, 0, 46), function(val)
    _G.AntiLag = val
    if val then
        GrayOverlay.Visible = true
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        GrayOverlay.Visible = false
    end
end)

-- BẢNG KILLS & WINS
local StatsBox = Instance.new("Frame")
StatsBox.Parent = MainContainer
StatsBox.Size = UDim2.new(1, -10, 0, 115)
StatsBox.Position = UDim2.new(0, 5, 0, 88)
StatsBox.BackgroundColor3 = Color3.fromRGB(24, 15, 38)
StatsBox.BackgroundTransparency = 0.4
StatsBox.ZIndex = 102

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 6)
StatsCorner.Parent = StatsBox

local StatsStroke = Instance.new("UIStroke")
StatsStroke.Parent = StatsBox
StatsStroke.Color = Color3.fromRGB(100, 0, 180)

local KillsLabel = Instance.new("TextLabel")
KillsLabel.Parent = StatsBox
KillsLabel.Size = UDim2.new(1, -10, 0, 40)
KillsLabel.Position = UDim2.new(0, 10, 0, 10)
KillsLabel.BackgroundTransparency = 1
KillsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
KillsLabel.Text = "KILLS: 0"
KillsLabel.Font = Enum.Font.SourceSansBold
KillsLabel.TextSize = 15
KillsLabel.TextXAlignment = Enum.TextXAlignment.Left
KillsLabel.ZIndex = 103

local WinsLabel = Instance.new("TextLabel")
WinsLabel.Parent = StatsBox
WinsLabel.Size = UDim2.new(1, -10, 0, 40)
WinsLabel.Position = UDim2.new(0, 10, 0, 55)
WinsLabel.BackgroundTransparency = 1
WinsLabel.TextColor3 = Color3.fromRGB(180, 100, 255)
WinsLabel.Text = "WINS: 0"
WinsLabel.Font = Enum.Font.SourceSansBold
WinsLabel.TextSize = 15
WinsLabel.TextXAlignment = Enum.TextXAlignment.Left
WinsLabel.ZIndex = 103

-- NỘI DUNG TAB RANDOM
local RandomContainer = Instance.new("Frame")
RandomContainer.Parent = MainWindow
RandomContainer.Size = UDim2.new(1, -105, 1, -48)
RandomContainer.Position = UDim2.new(0, 100, 0, 42)
RandomContainer.BackgroundTransparency = 1
RandomContainer.Visible = false
RandomContainer.ZIndex = 101

createToggleRow(RandomContainer, "Auto Roll", UDim2.new(0, 5, 0, 5), function(val)
    _G.AutoRoll = val
end)

-- ==========================================
-- 2. SỰ KIỆN MỞ MENU & CHUYỂN TAB
-- ==========================================
OpenIconBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = not MainWindow.Visible
end)

MainTabBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = true
    RandomContainer.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RandomTabBtn.BackgroundColor3 = Color3.fromRGB(35, 22, 50)
    RandomTabBtn.TextColor3 = Color3.fromRGB(170, 140, 200)
end)

RandomTabBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = false
    RandomContainer.Visible = true
    RandomTabBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
    RandomTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 22, 50)
    MainTabBtn.TextColor3 = Color3.fromRGB(170, 140, 200)
end)

-- CẬP NHẬT KILLS / WINS
task.spawn(function()
    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 5)
    if leaderstats then
        local kills = leaderstats:FindFirstChild("Kills") or leaderstats:FindFirstChild("Kill")
        local wins = leaderstats:FindFirstChild("Wins") or leaderstats:FindFirstChild("Win")
        
        if kills then
            KillsLabel.Text = "KILLS: " .. tostring(kills.Value)
            kills.Changed:Connect(function(v) KillsLabel.Text = "KILLS: " .. tostring(v) end)
        end
        if wins then
            WinsLabel.Text = "WINS: " .. tostring(wins.Value)
            wins.Changed:Connect(function(v) WinsLabel.Text = "WINS: " .. tostring(v) end)
        end
    end
end)

-- ==========================================
-- 3. CHỨC NĂNG GAME (AUTO FARM & ROLL)
-- ==========================================
local function getRemote()
    if ReplicatedStorage:FindFirstChild("Events") then
        return ReplicatedStorage.Events:FindFirstChild("GameRemoteFunction")
    end
    return nil
end

local function equipTool()
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

task.spawn(function()
    local gachaArgs = { [1] = "AttemptRollGachaChest", [2] = "Divine" }
    while true do
        if _G.AutoRoll then
            local r = getRemote()
            if r then pcall(function() r:InvokeServer(unpack(gachaArgs)) end) end
        end
        task.wait(0.01)
    end
end)

RunService.Heartbeat:Connect(function()
    if not _G.AutoFarm then return end
    local r = getRemote()
    if not r then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        local weapon = equipTool()
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
                                    ["attackCycleData"] = { ["lungeMult"] = 0, ["slowMult"] = 0, ["attackTime"] = 0, ["knockbackMult"] = 0, ["slowTime"] = 0 },
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
                                        ["attackCycle"] = { ["1"] = {["knockbackMul"] = 0, ["slowMult"] = 0, ["attackTime"] = 0, ["lungeMul"] = 0, ["slowTime"] = 0} },
                                        ["attackOrder"] = {[1] = "1"}
                                    },
                                    ["tool"] = weapon,
                                    ["slowTime"] = 0
                                },
                                [3] = {
                                    [1] = { ["knockback"] = 0, ["isClosestEnemy"] = true, ["origin"] = myHrp.Position, ["enemyModel"] = player.Character, ["distance"] = 0, ["direction"] = Vector3.new(0, 0, 0) }
                                }
                            }
                            task.spawn(function() r:InvokeServer(unpack(attackArgs)) end)
                        end
                    end
                end
            end
        end
    end)
end)
