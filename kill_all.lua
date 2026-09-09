-- Delta Mobile Script: Menu Kỳ Tuất (Super Fast Speed)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local RemoteFunction = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameRemoteFunction")

_G.AutoRoll = false
_G.AutoFarm = false

-- CẤU HÌNH TỐC ĐỘ (Số đòn đánh gửi trong 1 frame)
local ATTACK_MULTIPLIER = 3 

-- 1. TẠO GIAO DIỆN MENU MOBILE - KỲ TUẤT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyTuatMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 70, 0, 50)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenBtn.Text = "KỲ TUẤT"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 14
OpenBtn.Draggable = true
OpenBtn.Active = true

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "MENU KỲ TUẤT (FAST)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15

local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = MainFrame
FarmBtn.Size = UDim2.new(0, 190, 0, 40)
FarmBtn.Position = UDim2.new(0, 15, 0, 50)
FarmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Text = "Auto Farm Speed: OFF"
FarmBtn.Font = Enum.Font.SourceSans
FarmBtn.TextSize = 14

local RollBtn = Instance.new("TextButton")
RollBtn.Parent = MainFrame
RollBtn.Size = UDim2.new(0, 190, 0, 40)
RollBtn.Position = UDim2.new(0, 15, 0, 105)
RollBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
RollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RollBtn.Text = "Auto Roll Divine: OFF"
RollBtn.Font = Enum.Font.SourceSans
RollBtn.TextSize = 14

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
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

-- 2. TỰ ĐỘNG CẦM VŨ KHÍ
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

-- 3. THREAD AUTO ROLL DIVINE
task.spawn(function()
    local gachaArgs = { [1] = "AttemptRollGachaChest", [2] = "Divine" }
    while true do
        if _G.AutoRoll then
            pcall(function()
                RemoteFunction:InvokeServer(unpack(gachaArgs))
            end)
        end
        task.wait(0.01) -- Đã giảm thời gian chờ mở rương
    end
end)

-- 4. VÒNG LẶP AUTO FARM PHIÊN BẢN SIÊU TỐC ĐỘ (HEARTBEAT LOOP)
RunService.Heartbeat:Connect(function()
    if not _G.AutoFarm then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        local weapon = equipAnyWeapon()
        
        if weapon and char and char:FindFirstChild("HumanoidRootPart") then
            local myHrp = char.HumanoidRootPart
            
            -- Lặp đa tầng để nhân bản tốc độ đánh
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
                                        ["attackTime"] = 0, -- Triệt tiêu animation delay
                                        ["knockbackMult"] = 0,
                                        ["slowTime"] = 0
                                    },
                                    ["knockback"] = 0,
                                    ["shouldLock"] = false,
                                    ["shouldLunge"] = false,
                                    ["hitboxOffset"] = Vector3.new(0, 0, 0),
                                    ["isCritical"] = true,
                                    ["shouldSlow"] = false,
                                    ["attackCooldown"] = 0, -- Ép cooldown về 0
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
                            -- Gửi đòn đánh lập tức không cần đợi
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
