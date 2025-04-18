local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrimeFruitGui"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 90)
mainFrame.Position = UDim2.new(0, 30, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 6)
frameCorner.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
topBar.BorderSizePixel = 0
topBar.ZIndex = 11
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 6)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Prime Piece"
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 12
titleLabel.Parent = topBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "▼"
minimizeButton.Font = Enum.Font.Code
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 12
minimizeButton.Parent = topBar

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 60)
buttonContainer.Position = UDim2.new(0, 0, 0, 30)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ZIndex = 10
buttonContainer.Parent = mainFrame

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    buttonContainer.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 90)
    minimizeButton.Text = minimized and "◀" or "▼"
end)

-- Botão Auto Collect Fruit
local label = Instance.new("TextLabel")
label.Text = "Auto Collect Fruit"
label.Font = Enum.Font.Code
label.TextSize = 18
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Size = UDim2.new(1, -40, 0, 30)
label.Position = UDim2.new(0, 10, 0, 0)
label.TextXAlignment = Enum.TextXAlignment.Left
label.ZIndex = 11
label.Parent = buttonContainer

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 25, 0, 25)
toggleButton.Position = UDim2.new(1, -30, 0, 2)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = ""
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 11
toggleButton.Parent = buttonContainer

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = toggleButton

local collecting = false
local function collectFruits()
    while collecting do
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            task.wait()
            continue
        end
        local root = character.HumanoidRootPart
        local originalCFrame = root.CFrame
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Model") and item.Name:lower():find("fruit") and item:FindFirstChild("Handle") then
                local handle = item.Handle
                root.CFrame = CFrame.new(handle.Position + Vector3.new(0, 3, 0), root.Position)
                task.wait(0.1)
                root.CFrame = originalCFrame
            end
        end
        task.wait(0.2)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    collecting = not collecting
    if collecting then
        toggleButton.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
        toggleButton.Text = "✔"
        toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        task.spawn(collectFruits)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggleButton.Text = ""
    end
end)

local killButton = Instance.new("TextButton")
killButton.Text = "Kill All Mobs (G) Off"
killButton.Font = Enum.Font.Code
killButton.TextSize = 18
killButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killButton.Size = UDim2.new(1, -20, 0, 25)
killButton.Position = UDim2.new(0, 10, 0, 30)
killButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
killButton.BorderSizePixel = 0
killButton.ZIndex = 11
killButton.Parent = buttonContainer

local killToggle = false

killButton.MouseButton1Click:Connect(function()
    killToggle = not killToggle
    killButton.Text = "Kill All Mobs (G) " .. (killToggle and "On" or "Off")
end)

local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        killToggle = not killToggle
        killButton.Text = "Kill All Mobs (G) " .. (killToggle and "On" or "Off")
    end
end)

RunService.RenderStepped:Connect(function()
    if killToggle then
        local character = player.Character
        local enemies = {}
        for _,v in workspace.EnemyNpc:GetDescendants() do
            if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                table.insert(enemies, v)
            end
        end
        game:GetService("ReplicatedStorage").Remotes.Input:FireServer({
            ["Module"] = "Melee",
            ["Character"] = character,
            ["Input"] = "M1",
            ["Enemies"] = enemies,
            ["M1String"] = 2,
            ["Damage"] = {
                ["Value"] = 1000000,
                ["ScaleType"] = "Strength",
                ["Scale"] = 100
            }
        })
    end
end)
