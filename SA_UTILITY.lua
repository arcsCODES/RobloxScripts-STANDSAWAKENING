-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Main = ReplicatedStorage:WaitForChild("Main")
local Input = Main:WaitForChild("Timestop")

-- The script to be triggered
local function triggerScript()
    local args = {
        [1] = 20,
        [2] = "jotaroova"
    }
    Input:FireServer(unpack(args))
end

-- Keybind setup (left Ctrl)
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed then  -- Check if the input was not processed by other input handlers
        if input.KeyCode == Enum.KeyCode.F3 then
            triggerScript()
        end
    end
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local isHolding = false -- Flag to track if the key is being held down

local function throwKnife()
    local targetPosition = mouse.Hit.p

    local args = {
        [1] = "Alternate",
        [2] = "Knife",
        [3] = targetPosition
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        if not isHolding then
            isHolding = true
            while isHolding do
                throwKnife()
                wait(0) -- Adjust this value for the delay between actions (0.5 seconds here)
            end
        end    
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        isHolding = false -- Stop the action when the key is released
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))();

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Ensure Main and Input are properly defined
local Main = ReplicatedStorage:WaitForChild("Main")
local Input = Main:WaitForChild("Input")

-- Function to trigger server event with specified arguments
local function triggerServerEvent()
    local args = {
        [1] = "Alternate",
        [2] = "RTZ",
        [3] = true
    }

    Input:FireServer(unpack(args)) -- Trigger the server event with the provided args
end

-- Keybind setup (F3) to trigger the server event
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed then  -- Check if the input was not processed by other input handlers
        if input.KeyCode == Enum.KeyCode.F then
            triggerServerEvent() -- Call the function when F3 is pressed
        end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function loadPlayerScript()
    local success, err = pcall(function()
        local args = {
            [1] = "Alternate",
            [2] = "STWRTZ",
            [3] = true,
            [4] = player:GetMouse().Hit
        }
        -- Fire the server function with given args
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
    end)

    if not success then
        warn("Error with loading: " .. err)
    end
end

local function onCharacterAdded(character)
    loadPlayerScript()

    -- Listen for character's death
    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            print(player.Name .. " has died!")
            wait(5)  -- Wait for 5 seconds before respawning
            loadPlayerScript()  -- Reload script after respawn
        end
    end)
end

-- Connect to the CharacterAdded event
player.CharacterAdded:Connect(onCharacterAdded)

-- If character already exists, call the function
if player.Character then
    onCharacterAdded(player.Character)
end


local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game:GetService("Players").LocalPlayer

-- Function to collect all parts in a given parent
local function collectParts(parent, partsToToggle)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("BasePart") then
            table.insert(partsToToggle, child)
        end
        collectParts(child, partsToToggle)
    end
end
-- Function to anchor or unanchor parts
local function anchorParts(parts, anchor)
    for _, part in ipairs(parts) do
        local args = {
            [1] = part,
            [2] = anchor
        }
        ReplicatedStorage:WaitForChild("Anchor"):FireServer(unpack(args))
    end
end

-- Function to handle the toggle action
local function toggleAnchor()
    if localPlayer then
        local character = localPlayer.Character
        if character then
            local partsToToggle = {}

            -- Collect parts in the character
            collectParts(character, partsToToggle)
            anchorParts(partsToToggle, false)

            local stand = character:FindFirstChild("Stand")
            if stand then
                local partsToAnchor = {}
                collectParts(stand, partsToAnchor)
                anchorParts(partsToAnchor, false)
            else
                warn("Stand object not found in character")
            end
        else
            warn("Character not found for LocalPlayer")
        end
    else
        warn("LocalPlayer not found")
    end
end

-- Connect the F3 key press to toggle functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
        toggleAnchor()
    end
end)

local UIS = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()


function GetCharacter()
   return game.Players.LocalPlayer.Character
end

function Teleport(pos)
   local Char = GetCharacter()
   if Char then
       Char:MoveTo(pos)
   end
end

game.UserInputService.InputBegan:Connect(function(ip, gpe)
    if not gpe then
        if ip.KeyCode == Enum.KeyCode.V then
            Teleport(Mouse.Hit.p)
        end
     end
end)

-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Main = ReplicatedStorage:WaitForChild("Main")
local Input = Main:WaitForChild("Timestop")

local isSpamming = false -- To track active spam state
local spamCoroutine -- To manage the coroutine for spamming

-- The script to be triggered
local function triggerScript()
    local args = {
        [1] = 20,
        [2] = "jotaroova"
    }
    Input:FireServer(unpack(args)) -- Sends the arguments to the server
end

-- Function to start spamming
local function startSpam()
    if not isSpamming then
        isSpamming = true
        spamCoroutine = coroutine.create(function()
            while isSpamming do
                triggerScript() -- Trigger the time stop effect
                wait(0.5) -- Wait for 0.5 seconds before triggering again
            end
        end)
        coroutine.resume(spamCoroutine) -- Start the coroutine for spamming
    end
end

-- Function to stop spamming
local function stopSpam()
    isSpamming = false -- Set spamming state to false
end

-- Keybind setup (F3 to toggle)
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed then -- Check if the input was not processed by other input handlers
        if input.KeyCode == Enum.KeyCode.F3 then
            if isSpamming then
                stopSpam() -- Stop spamming if it was already running
            else
                startSpam() -- Start spamming if it was not running
            end
        end
    end
end)

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local speaker = Players.LocalPlayer -- Assuming you want this to be local to the player
local humanoid
local grabtoolsFunc
local isPickingUp = false -- Flag to track if the item pickup is active
local pickupConnection -- To store the connection for the while loop

local function notify(title, message)
    print(title .. ": " .. message) -- Simple console output for debugging
end

local function equipTools()
    humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")

    for _, child in ipairs(workspace:GetChildren()) do
        if speaker.Character and child:IsA("BackpackItem") and child:FindFirstChild("Handle") then
            humanoid:EquipTool(child)
        end
    end

    if grabtoolsFunc then 
        grabtoolsFunc:Disconnect() 
    end

    grabtoolsFunc = workspace.ChildAdded:Connect(function(child)
        if speaker.Character and child:IsA("BackpackItem") and child:FindFirstChild("Handle") then
            humanoid:EquipTool(child)
        end
    end)

    notify("Grabtools", "Picking up any dropped tools")
end

local function startPickingUpTools()
    isPickingUp = true
    notify("Grabtools", "Started picking up tools every 4 seconds.")
    
    pickupConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if isPickingUp then
            game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-336, 468, -1513))
            equipTools() -- Call the existing equipTools function every 4 seconds
            wait(4) -- Wait for 4 seconds before next pickup
        end
    end)
end

local function transferTools()
    -- Move tools from Backpack to Character
    for _, tool in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = Players.LocalPlayer.Character
        end
    end

    wait() -- Optional wait; it may not be needed

    -- Move tools from Character to Workspace
    for _, tool in pairs(Players.LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = workspace
        end
    end
    wait(0.3)
    equipTools()
end

local function stopPickingUpTools()
    isPickingUp = false
    if pickupConnection then
        pickupConnection:Disconnect() -- Stop the item pickup loop
        pickupConnection = nil
        notify("Grabtools", "Stopped picking up tools.")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.F1 then
            if isPickingUp then
                stopPickingUpTools()
            else
                startPickingUpTools()
            end
        elseif input.KeyCode == Enum.KeyCode.F2 then
            transferTools() -- Assuming the transferTools function remains from the previous version
        end
    end
end)
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local holdingF = false
local moveName = "RiftSlice" 
local args = {
    [1] = "Alternate", 
}

-- Function to trigger the move
local function triggerMove()
    while holdingF do
        args[2] = moveName
        ReplicatedStorage:WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
        wait(0.1)
    end
end

-- Detect when F key is pressed
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.F then
        holdingF = true
        triggerMove()
    end
end)

-- Detect when F key is released
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        holdingF = false 
    end
end)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")

local function onInputBegan(input)
    if input.KeyCode == Enum.KeyCode.F3 then
        local args1 = {
            [1] = "Alternate",
            [2] = "Throw2"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args1))

        -- Adding a short wait before firing the second action
        wait(0.1)  -- Adjust the wait time as needed

        local args2 = {
            [1] = "Alternate",
            [2] = "Throw"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args2))
    end
end

UserInputService.InputBegan:Connect(onInputBegan)