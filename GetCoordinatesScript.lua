local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordinatesGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Create the Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Make the Frame Draggable
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Create the TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.33, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextScaled = true
textLabel.Text = "Coordinates: Loading..."
textLabel.Parent = frame

-- Create the Copy Button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, 0, 0.22, 0)
copyButton.Position = UDim2.new(0, 0, 0.33, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Font = Enum.Font.SourceSansBold
copyButton.TextScaled = true
copyButton.Text = "Copy Coordinates"
copyButton.Parent = frame

copyButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local position = LocalPlayer.Character.HumanoidRootPart.Position
        setclipboard(string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z))
        copyButton.Text = "Copied!"
        task.wait(1)
        copyButton.Text = "Copy Coordinates"
    end
end)

-- Create the Show/Hide Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0.22, 0)
toggleButton.Position = UDim2.new(0, 0, 0.55, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "Hide"
toggleButton.Parent = frame

local isVisible = true
toggleButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    textLabel.Visible = isVisible
    copyButton.Visible = isVisible
    teleportButton.Visible = isVisible
    inputBox.Visible = isVisible
    toggleButton.Text = isVisible and "Hide" or "Show"
end)

-- Create the Input Box for Entering Coordinates
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0.22, 0)
inputBox.Position = UDim2.new(0, 0, 0.77, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Font = Enum.Font.SourceSansBold
inputBox.TextScaled = true
inputBox.PlaceholderText = "Enter X, Y, Z"
inputBox.Text = ""
inputBox.Parent = frame

-- Create the Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, 0, 0.22, 0)
teleportButton.Position = UDim2.new(0, 0, 0.99, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextScaled = true
teleportButton.Text = "Teleport"
teleportButton.Parent = frame

teleportButton.MouseButton1Click:Connect(function()
    local input = inputBox.Text
    local coords = {}
    for value in string.gmatch(input, "[^,]+") do
        table.insert(coords, tonumber(value))
    end

    if #coords == 3 then
        local teleportCoords = Vector3.new(coords[1], coords[2], coords[3])
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(teleportCoords)
            print("Teleported to:", teleportCoords)
        end
    else
        print("Invalid coordinates. Please enter X, Y, Z separated by commas.")
    end
end)

-- Update the coordinates in real-time
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local position = character.HumanoidRootPart.Position
        textLabel.Text = string.format("Coordinates: X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
    else
        textLabel.Text = "Coordinates: Not Available"
    end
end)