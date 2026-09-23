-- Dead Rails Mobile Freecam (Top Right Fixed Icon & High Sensitivity)
-- Compatible with Delta Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return end

-- Xóa GUI cũ nếu đã tồn tại để tránh trùng lặp
if PlayerGui:FindFirstChild("DeadRailsUltimateFreecam") then
    PlayerGui.DeadRailsUltimateFreecam:Destroy()
end

local freecamEnabled = false
local cameraSpeed = 1.2
local moveStates = {W = 0, S = 0, A = 0, D = 0, Up = 0, Down = 0}

-- GUI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsUltimateFreecam"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 -- Đảm bảo luôn nằm trên cùng mọi UI khác
ScreenGui.Parent = PlayerGui

-- Khung cảm ứng xoay Camera (Touch Canvas)
local TouchCanvas = Instance.new("Frame")
TouchCanvas.Name = "TouchCanvas"
TouchCanvas.Size = UDim2.new(1, 0, 1, 0)
TouchCanvas.BackgroundTransparency = 1
TouchCanvas.Visible = false
TouchCanvas.ZIndex = 1
TouchCanvas.Parent = ScreenGui

-- Icon Con Mắt (Nút Bật/Tắt - Cố định ở GÓC TRÊN BÊN PHẢI)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "EyeToggleBtn"
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(1, -60, 0, 10) -- Cố định ở góc trên bên phải
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Image = "rbxassetid://6031075931"
ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ZIndex = 100
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 255, 150)
BtnStroke.Thickness = 2
BtnStroke.Parent = ToggleBtn

-- Khung chứa phím di chuyển
local LeftFrame = Instance.new("Frame")
LeftFrame.Size = UDim2.new(0, 160, 0, 160)
LeftFrame.Position = UDim2.new(0.03, 0, 1, -180)
LeftFrame.BackgroundTransparency = 1
LeftFrame.Visible = false
LeftFrame.ZIndex = 50
LeftFrame.Parent = ScreenGui

local RightFrame = Instance.new("Frame")
RightFrame.Size = UDim2.new(0, 80, 0, 160)
RightFrame.Position = UDim2.new(1, -100, 1, -180)
RightFrame.BackgroundTransparency = 1
RightFrame.Visible = false
RightFrame.ZIndex = 50
RightFrame.Parent = ScreenGui

local function createButton(parent, text, pos, size, stateKey)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.ZIndex = 51
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            moveStates[stateKey] = 1
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            moveStates[stateKey] = 0
        end
    end)

    return btn
end

createButton(LeftFrame, "W", UDim2.new(0.35, 0, 0, 0), UDim2.new(0, 50, 0, 50), "W")
createButton(LeftFrame, "S", UDim2.new(0.35, 0, 0.65, 0), UDim2.new(0, 50, 0, 50), "S")
createButton(LeftFrame, "A", UDim2.new(0, 0, 0.325, 0), UDim2.new(0, 50, 0, 50), "A")
createButton(LeftFrame, "D", UDim2.new(0.7, 0, 0.325, 0), UDim2.new(0, 50, 0, 50), "D")

createButton(RightFrame, "▲", UDim2.new(0.15, 0, 0, 0), UDim2.new(0, 55, 0, 55), "Up")
createButton(RightFrame, "▼", UDim2.new(0.15, 0, 0.6, 0), UDim2.new(0, 55, 0, 55), "Down")

-- Xử lý xoay Camera
local camX, camY = 0, 0
local activeTouch = nil
local lastTouchPos = nil

TouchCanvas.InputBegan:Connect(function(input)
    if not freecamEnabled then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        if not activeTouch then
            activeTouch = input
            lastTouchPos = input.Position
        end
    end
end)

TouchCanvas.InputChanged:Connect(function(input)
    if not freecamEnabled or input ~= activeTouch then return end
    if input.UserInputType == Enum.UserInputType.Touch and lastTouchPos then
        local delta = input.Position - lastTouchPos
        lastTouchPos = input.Position
        
        local sensitivity = 0.008 -- Độ nhạy xoay camera
        camY = camY - (delta.X * sensitivity)
        camX = math.clamp(camX - (delta.Y * sensitivity), -math.rad(85), math.rad(85))
    end
end)

TouchCanvas.InputEnded:Connect(function(input)
    if input == activeTouch then
        activeTouch = nil
        lastTouchPos = nil
    end
end)

-- Loop Freecam
local currentCamCFrame = CFrame.new()

local function toggleFreecam()
    freecamEnabled = not freecamEnabled
    for k in pairs(moveStates) do moveStates[k] = 0 end
    
    if freecamEnabled then
        ToggleBtn.ImageColor3 = Color3.fromRGB(0, 255, 120)
        BtnStroke.Color = Color3.fromRGB(0, 255, 120)
        LeftFrame.Visible = true
        RightFrame.Visible = true
        TouchCanvas.Visible = true
        
        local cam = workspace.CurrentCamera
        currentCamCFrame = cam.CFrame
        local x, y, z = currentCamCFrame:ToOrientation()
        camX, camY = x, y
        
        RunService:BindToRenderStep("DeadRailsFreecamOverride", Enum.RenderPriority.Camera.Value + 100, function(dt)
            if not freecamEnabled then return end
            
            cam.CameraType = Enum.CameraType.Scriptable
            
            local rotation = CFrame.Angles(0, camY, 0) * CFrame.Angles(camX, 0, 0)
            
            local rightVec = rotation.RightVector
            local lookVec = rotation.LookVector
            local upVec = Vector3.new(0, 1, 0)
            
            local moveX = moveStates.D - moveStates.A
            local moveZ = moveStates.W - moveStates.S
            local moveY = moveStates.Up - moveStates.Down
            
            local dir = (rightVec * moveX) + (lookVec * moveZ) + (upVec * moveY)
            if dir.Magnitude > 0 then
                dir = dir.Unit
            end
            
            currentCamCFrame = CFrame.new(currentCamCFrame.Position + (dir * cameraSpeed)) * rotation
            cam.CFrame = currentCamCFrame
        end)
    else
        ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        BtnStroke.Color = Color3.fromRGB(0, 255, 150)
        LeftFrame.Visible = false
        RightFrame.Visible = false
        TouchCanvas.Visible = false
        
        RunService:UnbindFromRenderStep("DeadRailsFreecamOverride")
        
        activeTouch = nil
        lastTouchPos = nil
        
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(toggleFreecam)
