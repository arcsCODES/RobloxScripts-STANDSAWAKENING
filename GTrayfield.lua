-- UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Greentown HUB | V1",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Rayfield UI",
    ConfigurationSaving = { Enabled = true }
})

-- Tabs
local MainTab = Window:CreateTab("Scripts")

-- Create Sections
local TimestopSection = MainTab:CreateSection("Scripts List")

-- Timestop Toggle
local timestopConnection
MainTab:CreateToggle({
    Name = "15s TS",
    CurrentValue = false,
    Callback = function(state)
        local function onInputBegan(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
                local args = {15, "jotaroova"}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
            end
        end

        if state then
            timestopConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
        else
            if timestopConnection then
                timestopConnection:Disconnect()
                timestopConnection = nil
            end
            print("Timestop disabled")
        end
    end
})

-- MOVE IN TS Toggle
local toggleConnection
MainTab:CreateToggle({
    Name = "MOVE IN TS",
    CurrentValue = false,
    Callback = function(state)
        local function collectParts(parent)
            local parts = {}
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("BasePart") then
                    table.insert(parts, child)
                end
                for _, grandChild in ipairs(child:GetChildren()) do
                    if grandChild:IsA("BasePart") then
                        table.insert(parts, grandChild)
                    end
                end
            end
            return parts
        end
    
        local function anchorParts(parts, anchor)
            for _, part in ipairs(parts) do
                game:GetService("ReplicatedStorage"):WaitForChild("Anchor"):FireServer(part, anchor)
            end
        end
    
        local function toggleMovementLoop()
            while state do
                local player = game:GetService("Players").LocalPlayer
                if player and player.Character then
                    local character = player.Character
                    local partsToToggle = collectParts(character)
                    anchorParts(partsToToggle, false)
    
                    local stand = character:FindFirstChild("Stand")
                    if stand then
                        local standPartsToToggle = collectParts(stand)
                        anchorParts(standPartsToToggle, false)
                    end
                end
                wait(1)
            end
        end
    
        if state then
            if toggleConnection then
                toggleConnection:Disconnect()
            end
            toggleConnection = coroutine.wrap(toggleMovementLoop)
            toggleConnection()
            print("Movement enabled in timestops")
        else
            if toggleConnection then
                toggleConnection:Disconnect()
                toggleConnection = nil
            end
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character then
                local character = player.Character
                local partsToToggle = collectParts(character)
                anchorParts(partsToToggle, true)
    
                local stand = character:FindFirstChild("Stand")
                if stand then
                    local standPartsToToggle = collectParts(stand)
                    anchorParts(standPartsToToggle, true)
                end
            end
            print("Movement disabled in timestops")
        end
    end
})

-- STW H Toggle
local toggleConnection2
MainTab:CreateToggle({
    Name = "STW H (forever)",
    CurrentValue = false,
    Callback = function(state)
        local function attackLoop()
            while state do
                local args = {"Alternate", "STWRTZ", true}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                wait(1)
            end
        end
    
        if state then
            if toggleConnection2 then
                toggleConnection2:Disconnect()
            end
            toggleConnection2 = coroutine.wrap(attackLoop)
            toggleConnection2()
            print("Attack enabled")
        else
            if toggleConnection2 then
                toggleConnection2:Disconnect()
                toggleConnection2 = nil
            end
            print("Attack disabled")
        end
    end
})

-- D4C CLONES Toggle
local f2Connection, f3Connection
local isHoldingF3, isHoldingF2 = false, false
local function bindKeys()
    f3Connection = game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == Enum.KeyCode.F3 then
            if not isHoldingF3 then
                isHoldingF3 = true
                while isHoldingF3 do
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Death"):FireServer("Alternate", "Death")
                    wait(0)
                end
            end
        end
    end)

    f2Connection = game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == Enum.KeyCode.F2 then
            if not isHoldingF2 then
                isHoldingF2 = true
                while isHoldingF2 do
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "Clone")
                    wait(0.1)
                end
            end
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F3 then isHoldingF3 = false
        elseif input.KeyCode == Enum.KeyCode.F2 then isHoldingF2 = false
        end
    end)
end

local function unbindKeys()
    if f3Connection then f3Connection:Disconnect() end
    if f2Connection then f2Connection:Disconnect() end
    isHoldingF3, isHoldingF2 = false, false
end

MainTab:CreateToggle({
    Name = "D4C CLONES",
    CurrentValue = false,
    Callback = function(state)
        if state then
            bindKeys()
            print("D4C clones and death activated")
        else
            unbindKeys()
            print("D4C clones and death deactivated")
        end
    end
})

-- BLOCK GLITCH Toggle
MainTab:CreateToggle({
    Name = "BLOCK GLITCH",
    CurrentValue = false,
    Callback = function(state)
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "Block")
        print(state and "Blocking enabled" or "Blocking disabled")
    end
})

-- HG EMERALD SPLASH Toggle
local emeraldSplashConnection
MainTab:CreateToggle({
    Name = "HG EMERALD SPLASH",
    CurrentValue = false,
    Callback = function(state)
        local function onInputBegan(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl then
                for i = 1, 50 do
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, game.Players.LocalPlayer:GetMouse().Hit)
                end
            end
        end
    
        if state then
            emeraldSplashConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
            print("Emerald Splash enabled")
        else
            if emeraldSplashConnection then
                emeraldSplashConnection:Disconnect()
                emeraldSplashConnection = nil
            end
            print("Emerald Splash disabled")
        end
    end
})

-- SANS STAMINA VIEWER Toggle
local staminaConnection
MainTab:CreateToggle({
    Name = "SANS STAMINA VIEWER",
    CurrentValue = false,
    Callback = function(state)
        local function createOrUpdateStaminaGui(player, staminaValue)
            local playerGui = player:FindFirstChild("PlayerGui")
            if not playerGui then return end
            
            local screenGui = playerGui:FindFirstChild("StaminaGui") or Instance.new("ScreenGui")
            screenGui.Name = "StaminaGui"
            screenGui.Parent = playerGui
            screenGui.ResetOnSpawn = false
            
            local frame = screenGui:FindFirstChild("StaminaFrame") or Instance.new("Frame")
            frame.Name = "StaminaFrame"
            frame.Size = UDim2.new(0, 200, 0, 20)
            frame.Position = UDim2.new(0.5, -100, 0, 10)
            frame.BackgroundTransparency = 0
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.Parent = screenGui
            
            local bar = frame:FindFirstChild("StaminaBar") or Instance.new("Frame")
            bar.Name = "StaminaBar"
            bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            bar.Size = UDim2.new(staminaValue/100, 0, 1, 0) -- Assuming stamina is 0-100
            bar.Parent = frame
        end

        local function getPlayerStamina(player)
            local playerPart = game.Workspace:FindFirstChild(player.Name)
            if playerPart then
                local maxStamina = playerPart:FindFirstChild("MaxStamina")
                if maxStamina then
                    local stamina = maxStamina:FindFirstChild("Stamina")
                    if stamina then
                        createOrUpdateStaminaGui(player, stamina.Value)
                    end
                end
            end
        end

        local function updateStaminaGuis()
            for _, player in pairs(game.Players:GetPlayers()) do
                getPlayerStamina(player)
            end
        end

        if state then
            -- Connect player added event
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    getPlayerStamina(player)
                end)
            end)
            
            -- Start update loop
            staminaConnection = game:GetService("RunService").Heartbeat:Connect(function()
                updateStaminaGuis()
            end)
            
            -- Initial update for existing players
            updateStaminaGuis()
            print("Stamina viewer enabled")
        else
            if staminaConnection then
                staminaConnection:Disconnect()
                staminaConnection = nil
            end
            -- Clean up GUIs
            for _, player in pairs(game.Players:GetPlayers()) do
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui and playerGui:FindFirstChild("StaminaGui") then
                    playerGui.StaminaGui:Destroy()
                end
            end
            print("Stamina viewer disabled")
        end
    end
})

local riftSliceConnection
local riftSliceActive = false -- Track the state of Rift Slice

MainTab:CreateToggle({
    Name = "REAVER RIFT SLICE",
    CurrentValue = false,
    Callback = function(state)
        local function onInputBegan(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.F and not riftSliceActive then
                riftSliceActive = true
                while riftSliceActive do
                    local args = {"Alternate", "RiftSlice"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                    wait(0.05) -- Adjust this delay as needed
                end
            end
        end
    
        local function onInputEnded(input)
            if input.KeyCode == Enum.KeyCode.F then
                riftSliceActive = false -- Stop firing Rift Slice
            end
        end
    
        -- If the toggle is on, connect the input handler
        if state then
            riftSliceConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
            game:GetService("UserInputService").InputEnded:Connect(onInputEnded) -- Stop when F is released
            print("Rift Slice enabled")
        else
            -- If the toggle is off, disconnect the input handler
            if riftSliceConnection then
                riftSliceConnection:Disconnect()
                riftSliceConnection = nil
            end
            print("Rift Slice disabled")
        end
    end
})

local godModeCoroutine
local isGodModeActive = false

MainTab:CreateToggle({
    Name = "ONI GODMODE",
    CurrentValue = false,
    Callback = function(state)
        if state then
            isGodModeActive = true
    
            local function godModeLoop()
                while isGodModeActive do
                    local args = {"Alternate", "Dodge"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                    wait(0.5)
                end
            end
    
            if not godModeCoroutine or coroutine.status(godModeCoroutine) == "dead" then
                godModeCoroutine = coroutine.create(godModeLoop)
                coroutine.resume(godModeCoroutine)
            end
    
            print("Godmode enabled")
        else
            isGodModeActive = false
            print("Godmode disabled")
        end
    end
})



local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local knifeBeganConnection -- For InputBegan
local knifeEndedConnection -- For InputEnded
local holdingKnifeConnection -- For Heartbeat
local isHolding = false -- Flag to track if the key is being held down

-- Function to throw the knife
local function throwKnife()
    local targetPosition = mouse.Hit.Position
    local args = {
        [1] = "Alternate",
        [2] = "Knife",
        [3] = targetPosition
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
end

MainTab:CreateToggle({
    Name = "VTW KNIFE",
    CurrentValue = false,
    Callback = function(state)
        if state then
            -- Input began connection
            knifeBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.One then
                    if not isHolding then
                        isHolding = true
                        -- Continuous knife throwing while holding the key "1"
                        holdingKnifeConnection = RunService.Heartbeat:Connect(function()
                            if isHolding then
                                throwKnife()
                            end
                        end)
                    end
                end
            end)
            
            -- Input ended connection to stop when key "1" is released
            knifeEndedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.One then
                    isHolding = false
                    if holdingKnifeConnection then
                        holdingKnifeConnection:Disconnect()
                        holdingKnifeConnection = nil
                    end
                end
            end)
    
            print("Knife throw enabled")
        else
            -- Disable knife throwing and clean up connections
            if knifeBeganConnection then
                knifeBeganConnection:Disconnect()
                knifeBeganConnection = nil
            end
            if knifeEndedConnection then
                knifeEndedConnection:Disconnect()
                knifeEndedConnection = nil
            end
            if holdingKnifeConnection then
                holdingKnifeConnection:Disconnect()
                holdingKnifeConnection = nil
            end
            isHolding = false
            print("Knife throw disabled")
        end
    end
})

local standInvisible = false

MainTab:CreateToggle({
    Name = "STAND INVISIBLE", -- Note: Name suggests knife, but functionality is for stand visibility
    CurrentValue = false,
    Callback = function(state)
        local args = {"Alternate", "Appear", tostring(not state)} -- Invert state for visibility
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
        print(state and "Stand made invisible" or "Stand made visible")
    end
})

local counterCoroutine

MainTab:CreateToggle({
    Name = "COUNTER STANDLESS",
    CurrentValue = false,
    Callback = function(state)
        local args = {"Alternate", "Counter"}
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local main = replicatedStorage:WaitForChild("Main")
        local input = main:WaitForChild("Input")

        local function counterLoop()
            while state do
                input:FireServer(unpack(args))
                wait(0.5)
            end
        end

        if state then
            if counterCoroutine then
                -- If a previous coroutine exists, we'll let it die naturally since state is now true
                counterCoroutine = nil
            end
            counterCoroutine = coroutine.create(counterLoop)
            coroutine.resume(counterCoroutine)
            print("Counter attack of Standless enabled")
        else
            -- No need to "cancel" the coroutine; just let it stop naturally when state becomes false
            counterCoroutine = nil
            print("Counter attack of Standless disabled")
        end
    end
})

local triggerConnection

-- Ensure Main and Input are properly defined
local Main = game:GetService("ReplicatedStorage"):WaitForChild("Main")
local Input = Main:WaitForChild("Input")
local UserInputService = game:GetService("UserInputService")

-- Function to trigger server event with specified arguments
local function triggerServerEvent()
    local args = {
        [1] = "Alternate",
        [2] = "RTZ",
        [3] = true
    }

    Input:FireServer(unpack(args)) -- Trigger the server event with the provided args
end

MainTab:CreateToggle({
    Name = "GER RTZ",
    CurrentValue = false,
    Callback = function(state)
        if state then
            -- Input began connection
            triggerConnection = UserInputService.InputBegan:Connect(function(input, isProcessed)
                if not isProcessed then -- Check if the input was not processed by other input handlers
                    if input.KeyCode == Enum.KeyCode.B then
                        triggerServerEvent() -- Call the function when B is pressed
                    end
                end
            end)
            print("RTZ event trigger enabled")
        else
            -- Disable event triggering
            if triggerConnection then
                triggerConnection:Disconnect()
                triggerConnection = nil
            end
            print("RTZ event trigger disabled")
        end
    end
})

local reaperConnection

MainTab:CreateToggle({
    Name = "REAPER SPAM SCYTHE",
    CurrentValue = false,
    Callback = function(state)
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local main = replicatedStorage:WaitForChild("Main")
        local input = main:WaitForChild("Input")
        local player = game.Players.LocalPlayer

        if state then
            reaperConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        local args1 = {"Alternate", "Throw2"}
                        input:FireServer(unpack(args1))
                        
                        local args2 = {"Alternate", "Throw"}
                        input:FireServer(unpack(args2))
                    end
                end
                task.wait(0.4) -- Use task.wait for better precision
            end)
            print("Reaper scythe spam enabled")
        else
            if reaperConnection then
                reaperConnection:Disconnect()
                reaperConnection = nil
            end
            print("Reaper scythe spam disabled")
        end
    end
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local healthGui = nil -- Store the health GUI here
local toggleConnection = nil -- To manage the connection

-- Function to create the health bar GUI
local function createHealthBar()
    local character = player.Character or player.CharacterAdded:Wait()

    healthGui = Instance.new("BillboardGui")
    healthGui.Adornee = character:WaitForChild("Head")
    healthGui.Size = UDim2.new(0, 200, 0, 40)
    healthGui.StudsOffset = Vector3.new(0, 3, 0)

    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 0.5, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = healthGui

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthFrame

    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0.5, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.Font = Enum.Font.SourceSansBold
    healthText.TextScaled = true
    healthText.TextStrokeTransparency = 0.5
    healthText.Parent = healthGui

    healthGui.Parent = character

    -- Update health bar color and text
    local function updateHealthColorAndText(healthPercent)
        local redValue = math.clamp(255 * (1 - healthPercent), 0, 255)
        local greenValue = math.clamp(255 * healthPercent, 0, 255)
        
        healthFill.BackgroundColor3 = Color3.fromRGB(redValue, greenValue, 0)

        local percentHealth = math.floor(healthPercent * 100)
        healthText.Text = percentHealth .. "%"
    end

    -- Update health bar size and color based on health percentage
    local function updateHealth()
        while healthGui do
            wait(0.1)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local healthPercent = humanoid.Health / humanoid.MaxHealth

                healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                updateHealthColorAndText(healthPercent)
            end
            wait(0.5)
        end
    end

    spawn(updateHealth) -- Run updateHealth in a separate thread
end

MainTab:CreateToggle({
    Name = "HEALTH BAR",
    CurrentValue = false,
    Callback = function(state)
        if state then
            -- Create health bar when the toggle is on
            toggleConnection = player.CharacterAdded:Connect(createHealthBar)
            
            if player.Character then
                createHealthBar() -- Create health bar immediately if character exists
            end
            print("Health bar enabled")
        else
            -- Destroy health bar and disconnect event when the toggle is off
            if healthGui then
                healthGui:Destroy()
                healthGui = nil
            end
    
            if toggleConnection then
                toggleConnection:Disconnect()
                toggleConnection = nil
            end
            print("Health bar disabled")
        end
    end
})

local TsSoundsTab = Window:CreateTab("TsSounds")

TsSoundsTab:CreateButton({
    Name = "(OLD) TW ova TS",
    Callback = function() -- Buttons typically don't use a state parameter
        local args = {15, "dioova"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "(OLD) JOTARO OVA TS",
    Callback = function()
        local args = {15, "jotaroova"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "JSP TS",
    Callback = function()
        local args = {15, "jotaro"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "SPTW TS",
    Callback = function()
        local args = {15, "P4"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "TWOH TS",
    Callback = function()
        local args = {15, "diooh"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "STW TS",
    Callback = function()
        local args = {15, "shadowdio"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "TW TS",
    Callback = function()
        local args = {15, "theworldnew"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

TsSoundsTab:CreateButton({
    Name = "TWAU TS",
    Callback = function()
        local args = {15, "diego"}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
    end
})

local SoundTab = Window:CreateTab("Sounds")

local sounds = {}
local lastPlayedSound
local soundLoopActive = false
local soundCount = 1
local soundLoopConnection

-- Function to recursively collect sounds
local function getSounds(loc)
    if loc:IsA("Sound") then
        table.insert(sounds, loc)
    end
    for _, obj in pairs(loc:GetChildren()) do
        getSounds(obj)
    end
end

-- Initial sound collection
getSounds(game)

-- Listen for new sounds being added
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("Sound") then
        table.insert(sounds, obj)
    end
end)

-- Function to get a random sound, avoiding the last played one
local function getRandomSound()
    if #sounds == 0 then return nil end

    local randomSound
    local attempt = 0
    repeat
        local randomIndex = math.random(1, #sounds)
        randomSound = sounds[randomIndex]
        attempt = attempt + 1
    until randomSound ~= lastPlayedSound or attempt > 10

    if attempt > 10 then return nil end
    lastPlayedSound = randomSound
    return randomSound
end

-- Toggle to control sound loop
SoundTab:CreateToggle({
    Name = "SOUNDS",
    CurrentValue = false,
    Callback = function(state)
        soundLoopActive = state
        
        if state then
            if not soundLoopConnection then
                soundLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if soundLoopActive and #sounds > 0 then
                        for i = 1, soundCount do
                            local soundToPlay = getRandomSound()
                            if soundToPlay then
                                pcall(function()
                                    soundToPlay:Stop()
                                    soundToPlay:Play()
                                end)
                            end
                        end
                    end
                end)
            end
            print("Sound loop enabled")
        else
            if soundLoopConnection then
                soundLoopConnection:Disconnect()
                soundLoopConnection = nil
            end
            print("Sound loop disabled")
        end
    end
})

-- Slider to control number of sounds played
SoundTab:CreateSlider({
    Name = "Sound Count",
    Range = {1, 100}, -- Adjusted min to 1 to avoid 0 sounds
    Increment = 1,
    Suffix = "Sounds",
    CurrentValue = 1, -- Starting with 1 sound
    Flag = "SoundCountSlider",
    Callback = function(Value) -- Capital 'V' matches Rayfield convention
        soundCount = Value
    end
})

local MapTab = Window:CreateTab("Maps")

MapTab:CreateButton({
    Name = "MIDDLE",
    Callback = function()
        -- Coordinates to teleport to (replace with your desired coordinates)
        local teleportCoords = Vector3.new(1345, 623, -506)

        -- Get the player's character and its HumanoidRootPart
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Teleport the character to the specified coordinates
        humanoidRootPart.CFrame = CFrame.new(teleportCoords)
    end
})

MapTab:CreateButton({
    Name = "FARMING ZONE",
    Callback = function()
        -- Coordinates to teleport to (replace with your desired coordinates)
        local teleportCoords = Vector3.new(-285, 511, -1486)

        -- Get the player's character and its HumanoidRootPart
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Teleport the character to the specified coordinates
        humanoidRootPart.CFrame = CFrame.new(teleportCoords)
    end
})

local OtherScriptsTab = Window:CreateTab("Other Scripts")

OtherScriptsTab:CreateButton({
    Name = "Samurai HBE",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/samurai_hbe.lua"))()
    end
})


-- Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateSection("Credits:")
CreditsTab:CreateLabel("Scripts Founder: greentownXVI (Prince)")
