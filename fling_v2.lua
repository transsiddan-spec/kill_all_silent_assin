-- Delta Executor: Red Curved Menu + Safe Teleport Fix Void Drop
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local DropdownBtn = Instance.new("TextButton")
local DropdownList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local FlingBtn = Instance.new("TextButton")
local FlingAllBtn = Instance.new("TextButton")
local AntiFlingBtn = Instance.new("TextButton")

local function ApplyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

ScreenGui.Name = "DeltaRedFlingHubFixed"
ScreenGui.Parent = game.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Khung Main Menu màu Đỏ Bo Cong
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 210)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
ApplyCorner(MainFrame, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(220, 30, 30)
MainStroke.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -35, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
Title.Text = "  🔴 RED FLING HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
ApplyCorner(Title, 8)

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(1, -30, 0, 2.5)
ToggleBtn.Size = UDim2.new(0, 28, 0, 28)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ApplyCorner(ToggleBtn, 6)

DropdownBtn.Parent = MainFrame
DropdownBtn.Position = UDim2.new(0, 10, 0, 45)
DropdownBtn.Size = UDim2.new(0, 220, 0, 30)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
DropdownBtn.Text = "▼ Chọn người chơi..."
DropdownBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
DropdownBtn.Font = Enum.Font.SourceSans
ApplyCorner(DropdownBtn, 6)

DropdownList.Parent = MainFrame
DropdownList.Position = UDim2.new(0, 10, 0, 78)
DropdownList.Size = UDim2.new(0, 220, 0, 110)
DropdownList.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
DropdownList.Visible = false
DropdownList.ZIndex = 5
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
ApplyCorner(DropdownList, 6)

UIListLayout.Parent = DropdownList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

FlingBtn.Parent = MainFrame
FlingBtn.Position = UDim2.new(0, 10, 0, 85)
FlingBtn.Size = UDim2.new(0, 220, 0, 32)
FlingBtn.BackgroundColor3 = Color3.fromRGB(190, 30, 30)
FlingBtn.Text = "🚀 FLING NGƯỜI ĐƯỢC CHỌN"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.Font = Enum.Font.SourceSansBold
ApplyCorner(FlingBtn, 6)

FlingAllBtn.Parent = MainFrame
FlingAllBtn.Position = UDim2.new(0, 10, 0, 125)
FlingAllBtn.Size = UDim2.new(0, 220, 0, 32)
FlingAllBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 20)
FlingAllBtn.Text = "💥 FLING TẤT CẢ (FLING ALL)"
FlingAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingAllBtn.Font = Enum.Font.SourceSansBold
ApplyCorner(FlingAllBtn, 6)

AntiFlingBtn.Parent = MainFrame
AntiFlingBtn.Position = UDim2.new(0, 10, 0, 165)
AntiFlingBtn.Size = UDim2.new(0, 220, 0, 32)
AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(30, 130, 40)
AntiFlingBtn.Text = "🛡️ Anti Fling: BẬT"
AntiFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiFlingBtn.Font = Enum.Font.SourceSansBold
ApplyCorner(AntiFlingBtn, 6)

local SelectedPlayer = nil
local LocalPlayer = game.Players.LocalPlayer
local IsCollapsed = false
local AntiFlingEnabled = true
local SteppedConnection = nil
local IsFlinging = false

-- ANTI FLING SYSTEM
local function StartAntiFling()
    if SteppedConnection then SteppedConnection:Disconnect() end
    SteppedConnection = game:GetService("RunService").Stepped:Connect(function()
        if not AntiFlingEnabled or IsFlinging then return end
        local Char = LocalPlayer.Character
        if Char then
            for _, part in pairs(Char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            local HRP = Char:FindFirstChild("HumanoidRootPart")
            if HRP and (HRP.Velocity.Magnitude > 100 or HRP.RotVelocity.Magnitude > 100) then
                HRP.Velocity = Vector3.new(0, 0, 0)
                HRP.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end
StartAntiFling()

AntiFlingBtn.MouseButton1Click:Connect(function()
    AntiFlingEnabled = not AntiFlingEnabled
    if AntiFlingEnabled then
        AntiFlingBtn.Text = "🛡️ Anti Fling: BẬT"
        AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(30, 130, 40)
    else
        AntiFlingBtn.Text = "🛡️ Anti Fling: TẮT"
        AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    IsCollapsed = not IsCollapsed
    if IsCollapsed then
        MainFrame.Size = UDim2.new(0, 240, 0, 35)
        DropdownBtn.Visible = false
        DropdownList.Visible = false
        FlingBtn.Visible = false
        FlingAllBtn.Visible = false
        AntiFlingBtn.Visible = false
        ToggleBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 240, 0, 210)
        DropdownBtn.Visible = true
        FlingBtn.Visible = true
        FlingAllBtn.Visible = true
        AntiFlingBtn.Visible = true
        ToggleBtn.Text = "-"
    end
end)

local function RefreshDropdown()
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -4, 0, 26)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
            Btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            Btn.Font = Enum.Font.SourceSans
            Btn.ZIndex = 6
            Btn.Parent = DropdownList
            ApplyCorner(Btn, 4)
            
            Btn.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
                DropdownBtn.Text = "✔ " .. plr.DisplayName
                DropdownList.Visible = false
                FlingBtn.Position = UDim2.new(0, 10, 0, 85)
                FlingAllBtn.Position = UDim2.new(0, 10, 0, 125)
                AntiFlingBtn.Position = UDim2.new(0, 10, 0, 165)
            end)
        end
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

DropdownBtn.MouseButton1Click:Connect(function()
    RefreshDropdown()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        FlingBtn.Position = UDim2.new(0, 10, 0, 195)
        FlingAllBtn.Position = UDim2.new(0, 10, 0, 235)
        AntiFlingBtn.Position = UDim2.new(0, 10, 0, 275)
    else
        FlingBtn.Position = UDim2.new(0, 10, 0, 85)
        FlingAllBtn.Position = UDim2.new(0, 10, 0, 125)
        AntiFlingBtn.Position = UDim2.new(0, 10, 0, 165)
    end
end)

-- HÀM SỬA LỖI RƠI VOID / XUYÊN TƯỜNG KHI TELEPORT VỀ CŨ
local function SafeTeleportBack(OriginalCFrame)
    local Char = LocalPlayer.Character
    if not Char then return end
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    
    if HRP then
        -- 1. Triệt tiêu toàn bộ vận tốc cũ
        HRP.Velocity = Vector3.new(0, 0, 0)
        HRP.RotVelocity = Vector3.new(0, 0, 0)
        
        -- 2. Khôi phục trạng thái đứng yên cho nhân vật
        if Hum then Hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        
        -- 3. Đưa nhân vật về vị trí cũ (Nâng lên 1.5 stud để tránh bị lún vào sàn)
        HRP.CFrame = OriginalCFrame * CFrame.new(0, 1.5, 0)
        
        -- 4. Đóng băng (Anchor) tạm thời 0.2s để map kịp nhận diện va chạm
        HRP.Anchored = true
        task.wait(0.2)
        HRP.Anchored = false
        
        -- 5. Đảm bảo triệt tiêu lực lần cuối
        HRP.Velocity = Vector3.new(0, 0, 0)
    end
end

-- THUẬT TOÁN FLING
local function SingleFling(Target)
    if not Target or not Target.Character then return end
    local Char = LocalPlayer.Character
    local TargetChar = Target.Character
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    local THRP = TargetChar and TargetChar:FindFirstChild("HumanoidRootPart")
    
    if not HRP or not THRP then return end
    
    local Thrust = Instance.new("BodyVelocity")
    Thrust.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Thrust.Velocity = Vector3.new(99999, 99999, 99999)
    Thrust.Parent = HRP

    local Spin = Instance.new("BodyAngularVelocity")
    Spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    Spin.AngularVelocity = Vector3.new(99999, 99999, 99999)
    Spin.Parent = HRP

    local FlingLoop = game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(Char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end)

    local StartTime = tick()
    while tick() - StartTime < 1.5 do
        if not THRP or not HRP or not TargetChar then break end
        HRP.CFrame = THRP.CFrame * CFrame.new(math.random(-1,1), -1.5, math.random(-1,1))
        task.wait()
    end

    if FlingLoop then FlingLoop:Disconnect() end
    Thrust:Destroy()
    Spin:Destroy()
end

-- FLING NGƯỜI CHỌN
FlingBtn.MouseButton1Click:Connect(function()
    if SelectedPlayer and not IsFlinging then
        IsFlinging = true
        FlingBtn.Text = "⏳ Đang Fling..."
        
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local OriginalCFrame = HRP and HRP.CFrame
        
        SingleFling(SelectedPlayer)
        
        if OriginalCFrame then
            SafeTeleportBack(OriginalCFrame)
        end
        
        IsFlinging = false
        FlingBtn.Text = "🚀 FLING NGƯỜI ĐƯỢC CHỌN"
    end
end)

-- FLING TẤT CẢ (FLING ALL)
FlingAllBtn.MouseButton1Click:Connect(function()
    if not IsFlinging then
        IsFlinging = true
        FlingAllBtn.Text = "⏳ Đang Fling All..."
        
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local OriginalCFrame = HRP and HRP.CFrame
        
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                SingleFling(plr)
                task.wait(0.1)
            end
        end
        
        if OriginalCFrame then
            SafeTeleportBack(OriginalCFrame)
        end
        
        IsFlinging = false
        FlingAllBtn.Text = "💥 FLING TẤT CẢ (FLING ALL)"
    end
end)
