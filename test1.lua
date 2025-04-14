local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fedz Hub main | Stands Awakening " .. Fluent.Version,
    SubTitle = "by Fedul2009",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.Two
})

-- MGA TABS
local Tabs = {
    Script = Window:AddTab({ Title = "Scripts", Icon = "align-center" }),
    TsSounds = Window:AddTab({ Title = "TS sounds", Icon = "speaker" }),
    Sound = Window:AddTab({ Title = "Sounds", Icon = "file-audio" }),
    Maps = Window:AddTab({ Title = "Maps", Icon = "map" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "crosshair" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    OtherScripts = Window:AddTab({ Title = "Other scripts", Icon = "anchor" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "bell" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    -- KEYBIND SA TIMESTOP
    local TimestopToggle = Tabs.Script:AddToggle("TimestopToggle", {
        Title = "15 SECONDS NA TIMESTOP", 
        Description = "I-click ang [LCTRL] para mugana",
        Default = false 
    })

    local timestopConnection

    TimestopToggle:OnChanged(function(state)
        local function onInputBegan(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
                local args = {15, "jotaroova"}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
            end
        end

        if state then
            timestopConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
            print("Timestop enabled - Press Left Control to activate")
        else
            if timestopConnection then
                timestopConnection:Disconnect()
                timestopConnection = nil
            end
            print("Timestop disabled")
        end
    end)

    -- TOGGLE SA MAKA LIHOK SA TIMESTOP
    local MoveToggle = Tabs.Script:AddToggle("MoveToggle", {
        Title = "LIHOK SA TIMESTOP", 
        Description = "Maka lihok sa timestop",
        Default = false 
    })

    local moveConnection

    MoveToggle:OnChanged(function(state)
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
            while moveConnection do
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
                task.wait(1)
            end
        end
    
        if state then
            if moveConnection then
                moveConnection:Disconnect()
            end
            moveConnection = coroutine.wrap(toggleMovementLoop)
            moveConnection()
            print("Movement enabled in timestops")
        else
            if moveConnection then
                moveConnection:Disconnect()
                moveConnection = nil
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
    end)

    -- COUNTER SA STW
    local AttackToggle = Tabs.Script:AddToggle("AttackToggle", {
        Title = "COUNTER SA STW", 
        Description = "H pirmi",
        Default = false 
    })

    local attackConnection

    AttackToggle:OnChanged(function(state)
        local function attackLoop()
            while attackConnection do
                local args = {"Alternate", "STWRTZ", true}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                task.wait(1)
            end
        end
    
        if state then
            if attackConnection then
                attackConnection:Disconnect()
            end
            attackConnection = coroutine.wrap(attackLoop)
            attackConnection()
            print("Attack enabled")
        else
            if attackConnection then
                attackConnection:Disconnect()
                attackConnection = nil
            end
            print("Attack disabled")
        end
    end)

    -- D4C toggle
    local D4CToggle = Tabs.Script:AddToggle("D4CToggle", {
        Title = "CLONES SA D4C", 
        Description = "pislita ang [F2] ug [F3] para mugana",
        Default = false 
    })

    local f2Connection, f3Connection
    local isHoldingF3, isHoldingF2 = false, false

    D4CToggle:OnChanged(function(state)
        local function bindKeys()
            f3Connection = game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
                if not isProcessed and input.KeyCode == Enum.KeyCode.F3 then
                    if not isHoldingF3 then
                        isHoldingF3 = true
                        while isHoldingF3 do
                            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Death"):FireServer("Alternate", "Death")
                            task.wait(0)
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
                            task.wait(0.1)
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

        if state then
            bindKeys()
            print("D4C clones and death activated")
        else
            unbindKeys()
            print("D4C clones and death deactivated")
        end
    end)

    -- Block glitch
    local BlockToggle = Tabs.Script:AddToggle("BlockToggle", {
        Title = "BLOCK GLITCH", 
        Description = "Mahimo imong block ma glitch",
        Default = false 
    })

    BlockToggle:OnChanged(function(state)
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "Block")
        print(state and "Blocking enabled" or "Blocking disabled")
    end)

    -- HG emerald splash
    local EmeraldToggle = Tabs.Script:AddToggle("EmeraldToggle", {
        Title = "HG EMERALD SPLASH WIDE", 
        Description = "Hold [LCTRL] to activate wide splash loop",
        Default = false 
    })
    
    local emeraldSplashActive = false
    local emeraldSplashConnection
    local emeraldReleaseConnection
    local loopConnection
    local cooldown = false
    local cooldownTime = 0.05 -- Faster firing rate (20 emeralds per second)
    
    -- Configuration options
    local SPLASH_RADIUS = 15       -- Wider spread radius
    local PROJECTILE_COUNT = 18    -- More projectiles for fuller coverage
    local PREDICTION_STRENGTH = 1.2 -- How much to lead targets based on their velocity
    local MAX_TARGET_DISTANCE = 100 -- Maximum targeting distance
    local AUTO_TARGET = true       -- Automatically target nearby players
    local EMERALD_BURST_COUNT = 15 -- Number of emeralds to fire at each detected player
    local NORMAL_SPREAD_COUNT = 5  -- Random emeralds when no players detected
    local PLAYER_DETECTED_SPREAD_COUNT = 12 -- Random emeralds when players detected
    
    EmeraldToggle:OnChanged(function(state)
        local function predictPlayerPosition(player)
            if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                return nil
            end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid then return nil end
            
            local rootPart = player.Character.HumanoidRootPart
            local velocity = rootPart.Velocity
            
            -- Calculate predicted position based on velocity
            local predictedPosition = rootPart.Position + (velocity * PREDICTION_STRENGTH)
            return predictedPosition
        end
        
        local function getTargetPlayers()
            local targets = {}
            local localPlayer = game.Players.LocalPlayer
            
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    local distance = (rootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance <= MAX_TARGET_DISTANCE then
                        local predictedPos = predictPlayerPosition(player)
                        if predictedPos then
                            table.insert(targets, {
                                player = player,
                                position = predictedPos,
                                distance = distance
                            })
                        end
                    end
                end
            end
            
            -- Sort by distance (closest first)
            table.sort(targets, function(a, b)
                return a.distance < b.distance
            end)
            
            return targets
        end
        
        local function fireEmeraldSplash()
            if cooldown then return end
            
            cooldown = true
            
            -- Create base position (either mouse position or player position)
            local basePosition
            local localPlayer = game.Players.LocalPlayer
            local mouseHit = localPlayer:GetMouse().Hit
            basePosition = mouseHit.Position
            
            -- Get nearby players
            local targets = getTargetPlayers()
            local playersDetected = #targets > 0
            
            -- Target mode - target players in the server
            if AUTO_TARGET and playersDetected then
                -- Target nearby players with MASSIVE emerald bursts
                for _, targetData in ipairs(targets) do
                    -- Fire directly at predicted player position with multiple emeralds (concentrated burst)
                    for i = 1, EMERALD_BURST_COUNT do
                        -- Slight variation for better hit chance
                        local smallOffset = Vector3.new(
                            math.random(-2, 2), 
                            math.random(-1, 1), 
                            math.random(-2, 2)
                        )
                        local targetPosition = CFrame.new(targetData.position + smallOffset)
                        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, targetPosition)
                    end
                    
                    -- Create a circular pattern around the target
                    for angle = 0, 360 - 36, 36 do -- 10 projectiles around each player
                        local rad = math.rad(angle)
                        local circleRadius = 5 -- 5 studs around player
                        local offset = Vector3.new(math.cos(rad) * circleRadius, 0, math.sin(rad) * circleRadius)
                        local circlePosition = CFrame.new(targetData.position + offset)
                        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, circlePosition)
                    end
                end
            end
            
            -- Wide spread pattern (independent of targeting)
            for angle = 0, 360 - (360/PROJECTILE_COUNT), 360/PROJECTILE_COUNT do
                local rad = math.rad(angle)
                local offset = Vector3.new(math.cos(rad) * SPLASH_RADIUS, 0, math.sin(rad) * SPLASH_RADIUS)
                local targetPosition = CFrame.new(basePosition + offset)
                
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, targetPosition)
            end
            
            -- Fill gaps with random emeralds - more if players are detected
            local randomCount = playersDetected and PLAYER_DETECTED_SPREAD_COUNT or NORMAL_SPREAD_COUNT
            for i = 1, randomCount do
                local randomOffset = Vector3.new(
                    math.random(-SPLASH_RADIUS, SPLASH_RADIUS),
                    math.random(-3, 3),
                    math.random(-SPLASH_RADIUS, SPLASH_RADIUS)
                )
                local targetPosition = CFrame.new(basePosition + randomOffset)
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, targetPosition)
            end
            
            -- If players detected, add an extra barrage in a grid pattern for better area coverage
            if playersDetected then
                for x = -SPLASH_RADIUS, SPLASH_RADIUS, SPLASH_RADIUS/2 do
                    for z = -SPLASH_RADIUS, SPLASH_RADIUS, SPLASH_RADIUS/2 do
                        if math.random() < 0.7 then -- 70% chance to fire at each grid point for some randomness
                            local gridOffset = Vector3.new(x, 0, z)
                            local gridPosition = CFrame.new(basePosition + gridOffset)
                            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, gridPosition)
                        end
                    end
                end
            end
            
            -- Reset cooldown
            task.delay(cooldownTime, function()
                cooldown = false
            end)
        end
        
        local function startEmeraldLoop()
            if loopConnection then return end
            
            emeraldSplashActive = true
            loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if emeraldSplashActive then
                    fireEmeraldSplash()
                end
            end)
        end
        
        local function stopEmeraldLoop()
            emeraldSplashActive = false
            if loopConnection then
                loopConnection:Disconnect()
                loopConnection = nil
            end
        end
        
        local function onInputBegan(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl and not emeraldSplashActive then
                startEmeraldLoop()
            end
        end
        
        local function onInputEnded(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl then
                stopEmeraldLoop()
            end
        end
        
        if state then
            -- Connect input events
            emeraldSplashConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
            emeraldReleaseConnection = game:GetService("UserInputService").InputEnded:Connect(onInputEnded)
            print("Enhanced Emerald Splash enabled - Hold LCTRL to activate")
        else
            -- Disconnect everything
            if emeraldSplashConnection then
                emeraldSplashConnection:Disconnect()
                emeraldSplashConnection = nil
            end
            
            if emeraldReleaseConnection then
                emeraldReleaseConnection:Disconnect()
                emeraldReleaseConnection = nil
            end
            
            stopEmeraldLoop()
            print("Enhanced Emerald Splash disabled")
        end
    end)

    -- SANS STAMINA VIEWER
    local StaminaToggle = Tabs.Script:AddToggle("StaminaToggle", {
        Title = "MA TAN-AW ANG SANS STAMINA", 
        Description = "Maka tan-aw sa sans stamina",
        Default = false 
    })
    
    local staminaConnection
    
    StaminaToggle:OnChanged(function(state)
        local function createOrUpdateStaminaGui(player, staminaValue)
            local character = player.Character
            if not character then return end
        
            local head = character:FindFirstChild("Head")
            if not head then return end
        
            -- Check if the player already has a BillboardGui
            local existingGui = character:FindFirstChild("StaminaGui")
            if existingGui then
                -- Update the existing GUI
                local textLabel = existingGui:FindFirstChild("TextLabel")
                if textLabel then
                    textLabel.Text = "Stamina: " .. staminaValue
                end
            else
                -- Create a new BillboardGui
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "StaminaGui"
                billboardGui.Adornee = head
                billboardGui.Size = UDim2.new(0, 150, 0, 50)
                billboardGui.StudsOffset = Vector3.new(0, 8, 0)
                billboardGui.MaxDistance = 150
                billboardGui.AlwaysOnTop = true
        
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 0
                textLabel.BackgroundColor3 = Color3.new(0, 0, 1)
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextScaled = true
                textLabel.Text = "Stamina: " .. staminaValue
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.Parent = billboardGui
        
                billboardGui.Parent = character
            end
        end
    end)

    local function createOrUpdateStaminaGui(player, staminaValue)
        -- Implement your GUI update logic here
        -- Example: Update a TextLabel or ProgressBar with the stamina value
    end
    
    -- Function to get and update a single player's stamina
    local function getPlayerStamina(player)
        -- Wait for the character to exist if it doesn't yet
        if not player.Character then return end
        
        -- Find the part named after the player in the Workspace
        local playerPart = player.Character:FindFirstChild(player.Name)
        
        if playerPart then
            -- Find the MaxStamina group
            local maxStamina = playerPart:FindFirstChild("MaxStamina")
            
            if maxStamina then
                -- Find the Stamina value inside MaxStamina
                local stamina = maxStamina:FindFirstChild("Stamina")
                
                if stamina then
                    -- Update GUI with the stamina value
                    createOrUpdateStaminaGui(player, stamina.Value)
                end
            end
        end
    end
    
    -- Function to update all players' stamina GUIs
    local function updateStaminaGuis()
        for _, player in ipairs(game.Players:GetPlayers()) do
            getPlayerStamina(player)
        end
    end
    
    -- Handle new players joining
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            -- Use a proper wait method that won't yield indefinitely
            character:WaitForChild(player.Name, 5) -- Wait up to 5 seconds for the part
            getPlayerStamina(player)
        end)
    end)
    
    -- Update stamina GUIs continuously
    task.spawn(function()
        while true do
            updateStaminaGuis()
            task.wait(0.6) -- Consider adjusting this based on your needs
        end
    end)
    
    -- Attack toggle system
    local toggleConnection = nil
    local attackState = false -- More descriptive variable name
    
    local function attackLoop()
        while attackState do
            -- Implement your attack behavior here
            task.wait(0.1) -- Using task.wait() is better than wait()
        end
    end
    
    local function toggleAttack()
        attackState = not attackState
        
        if attackState then
            if toggleConnection then
                toggleConnection:Disconnect()
            end
            toggleConnection = task.spawn(attackLoop) -- Using task.spawn instead of coroutine.wrap
            print("Attack enabled")
        else
            attackState = false -- Ensure state is false when toggling off
            print("Attack disabled")
        end
    end

    -- RIFT SLICE
    local riftSliceConnection
    local riftSliceActive = false

    local RiftSliceToggle = Tabs.Script:AddToggle("RiftSliceToggle", {
        Title = "REAVER RIFT SLICE", 
        Description = "Pislita ang [F] para mugana",
        Default = false 
    })

    RiftSliceToggle:OnChanged(function(state)
        local function onInputBegan(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.F and not riftSliceActive then
                riftSliceActive = true
                while riftSliceActive and state do
                    local args = {"Alternate", "RiftSlice"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                    task.wait(0.05)
                end
            end
        end
    
        local function onInputEnded(input)
            if input.KeyCode == Enum.KeyCode.F then
                riftSliceActive = false
            end
        end
    
        if state then
            riftSliceConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
            game:GetService("UserInputService").InputEnded:Connect(onInputEnded)
            print("Rift Slice enabled")
        else
            if riftSliceConnection then
                riftSliceConnection:Disconnect()
                riftSliceConnection = nil
            end
            riftSliceActive = false
            print("Rift Slice disabled")
        end
    end)

    -- ONI GODMODE
    local godModeCoroutine
    local isGodModeActive = false

    local GodModeToggle = Tabs.Script:AddToggle("GodModeToggle", {
        Title = "ONI GODMODE", 
        Description = "Tagaan ka ug daghan na frames kung pisliton nimo ang [C]",
        Default = false 
    })

    GodModeToggle:OnChanged(function(state)
        isGodModeActive = state
    
        local function godModeLoop()
            while isGodModeActive do
                local args = {"Alternate", "Dodge"}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                task.wait(0.5)
            end
        end
    
        if state then
            godModeCoroutine = coroutine.create(godModeLoop)
            coroutine.resume(godModeCoroutine)
            print("Godmode enabled")
        else
            if godModeCoroutine then
                coroutine.close(godModeCoroutine)
                godModeCoroutine = nil
            end
            print("Godmode disabled")
        end
    end)

    -- VTW KNIFE
    local knifeBeganConnection
    local knifeEndedConnection
    local holdingKnifeConnection
    local isHolding = false
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local KnifeToggle = Tabs.Script:AddToggle("KnifeToggle", {
        Title = "VTW KNIFE", 
        Description = "Kung timestop, spam ug [1] para daghan ug kalabay ang mga kutsilyo",
        Default = false 
    })

    KnifeToggle:OnChanged(function(state)
        local function throwKnife()
            local targetPosition = mouse.Hit.Position
            local args = {
                [1] = "Alternate",
                [2] = "Knife",
                [3] = targetPosition
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
        end

        if state then
            knifeBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.One then
                    if not isHolding then
                        isHolding = true
                        holdingKnifeConnection = RunService.Heartbeat:Connect(function()
                            if isHolding then
                                throwKnife()
                            end
                        end)
                    end
                end
            end)
            
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
    end)

    -- STAND INVISIBLE
    local InvisibleToggle = Tabs.Script:AddToggle("InvisibleToggle", {
        Title = "INVISIBLE STAND", 
        Description = "Mahimo imong stand ma invisible",
        Default = false 
    })

    InvisibleToggle:OnChanged(function(state)
        local args = {"Alternate", "Appear", tostring(not state)}
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
        print(state and "Stand made invisible" or "Stand made visible")
    end)

    -- STANDLESS COUNTER
    local counterCoroutine

    local CounterToggle = Tabs.Script:AddToggle("CounterToggle", {
        Title = "STANDLESS COUNTER", 
        Description = "Counter pirmi",
        Default = false 
    })

    CounterToggle:OnChanged(function(state)
        local args = {"Alternate", "Counter"}
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local main = replicatedStorage:WaitForChild("Main")
        local input = main:WaitForChild("Input")

        local function counterLoop()
            while state do
                input:FireServer(unpack(args))
                task.wait(0.5)
            end
        end

        if state then
            if counterCoroutine then
                coroutine.close(counterCoroutine)
            end
            counterCoroutine = coroutine.create(counterLoop)
            coroutine.resume(counterCoroutine)
            print("Counter attack of Standless enabled")
        else
            if counterCoroutine then
                coroutine.close(counterCoroutine)
                counterCoroutine = nil
            end
            print("Counter attack of Standless disabled")
        end
    end)

    -- GER RTZ
    local triggerConnection

    local GERRTZToggle = Tabs.Script:AddToggle("GERRTZToggle", {
        Title = "GER RTZ", 
        Description = "Pislita ang [B] para mugana",
        Default = false 
    })

    GERRTZToggle:OnChanged(function(state)
        local function triggerServerEvent()
            local args = {
                [1] = "Alternate",
                [2] = "RTZ",
                [3] = true
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
        end

        if state then
            triggerConnection = UserInputService.InputBegan:Connect(function(input, isProcessed)
                if not isProcessed and input.KeyCode == Enum.KeyCode.B then
                    triggerServerEvent()
                end
            end)
            print("RTZ event trigger enabled")
        else
            if triggerConnection then
                triggerConnection:Disconnect()
                triggerConnection = nil
            end
            print("RTZ event trigger disabled")
        end
    end)

    -- REAPER SPAM SCYTHE
    local reaperConnection

    local ScytheSpamToggle = Tabs.Script:AddToggle("ScytheSpamToggle", {
        Title = "REAPER SPAM SCYTHE", 
        Description = "Mugana hantud mamatay ang player",
        Default = false 
    })

    ScytheSpamToggle:OnChanged(function(state)
        if state then
            reaperConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then
                        local args1 = {"Alternate", "Throw2"}
                        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args1))
                        
                        local args2 = {"Alternate", "Throw"}
                        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args2))
                    end
                end
                task.wait(0.4)
            end)
            print("Reaper scythe spam enabled")
        else
            if reaperConnection then
                reaperConnection:Disconnect()
                reaperConnection = nil
            end
            print("Reaper scythe spam disabled")
        end
    end)

    -- HEALTH BAR GUI
    local healthGui = nil
    local toggleConnection = nil
    local updateHealthThread = nil

    local HealthBarToggle = Tabs.Script:AddToggle("HealthBarToggle", {
        Title = "HEALTH BAR GUI", 
        Description = "Nagpakita imong HP bar",
        Default = false 
    })

    local function createHealthBar()
        if healthGui then
            healthGui:Destroy()
            healthGui = nil
        end
        
        local character = player.Character or player.CharacterAdded:Wait()
        if not character then return end
        
        local head = character:WaitForChild("Head")
        
        healthGui = Instance.new("BillboardGui")
        healthGui.Name = "PlayerHealthBar"
        healthGui.Adornee = head
        healthGui.Size = UDim2.new(0, 200, 0, 40)
        healthGui.StudsOffset = Vector3.new(0, 3, 0)
        healthGui.AlwaysOnTop = true
        healthGui.ResetOnSpawn = false
        healthGui.LightInfluence = 0

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
        healthText.Position = UDim2.new(0, 0, 0.5, 0)
        healthText.BackgroundTransparency = 1
        healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthText.Font = Enum.Font.SourceSansBold
        healthText.TextScaled = true
        healthText.TextStrokeTransparency = 0.5
        healthText.Text = "100%"
        healthText.Parent = healthGui

        healthGui.Parent = character

        local function updateHealthColorAndText(healthPercent)
            local redValue = math.clamp(255 * (1 - healthPercent), 0, 255)
            local greenValue = math.clamp(255 * healthPercent, 0, 255)
            
            healthFill.BackgroundColor3 = Color3.fromRGB(redValue, greenValue, 0)

            local percentHealth = math.floor(healthPercent * 100)
            healthText.Text = percentHealth .. "%"
        end

        local function updateHealth()
            while healthGui and healthGui.Parent do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    local healthPercent = humanoid.Health / humanoid.MaxHealth

                    healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                    updateHealthColorAndText(healthPercent)
                end
                task.wait(0.1)
            end
        end

        if updateHealthThread then
            coroutine.close(updateHealthThread)
        end
        
        updateHealthThread = coroutine.create(updateHealth)
        coroutine.resume(updateHealthThread)
    end

    HealthBarToggle:OnChanged(function(state)
        if state then
            toggleConnection = player.CharacterAdded:Connect(createHealthBar)
            
            if player.Character then
                createHealthBar()
            end
            print("Health bar enabled")
        else
            if updateHealthThread then
                coroutine.close(updateHealthThread)
                updateHealthThread = nil
            end
            
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
    end)

    -- TS SOUNDS

    Tabs.TsSounds:AddButton({
        Title = "(OLD) TW OVA",
        Description = "Retro TW OVA Timestop",
        Callback = function()
            local args = {15, "dioova"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "(OLD) JOTARO OVA TS",
        Description = "Retro SP OVA Timestop",
        Callback = function()
            local args = {15, "jotaroova"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "JSP TS",
        Description = "JSP Timestop",
        Callback = function()
            local args = {15, "jotaro"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "SPTW TS",
        Description = "SPTW Timestop",
        Callback = function()
            local args = {15, "P4"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "TWOH TS",
        Description = "TWOH Timestop",
        Callback = function()
            local args = {15, "diooh"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "STW TS",
        Description = "STW Timestop",
        Callback = function()
            local args = {15, "shadowdio"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "TW TS",
        Description = "TW Newgen Timestop",
        Callback = function()
            local args = {15, "theworldnew"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    Tabs.TsSounds:AddButton({
        Title = "TWAU TS",
        Description = "TWAU Timestop",
        Callback = function()
            local args = {15, "diego"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    })

    -- SOUNDS

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

    local SoundsToggle = Tabs.Sound:AddToggle("SoundsToggle", {
        Title = "SOUNDS", 
        Description = "I-Toggle para mugana",
        Default = false 
    })

    SoundsToggle:OnChanged(function(state)
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
    end)

    local Slider = Tabs.Sound:AddSlider("SoundSlider", {
        Title = "Sound Count",
        Description = "Kung pila ka number mao na i-i play",
        Default = 2,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            soundCount = Value
        end
    })

    -- MAPS

    local MapDropdown = Tabs.Maps:AddDropdown("MapDropdown", {
        Title = "TP MAP",
        Description = "Pilia ang mga location para ma tp ka",
        Values = {
            "MIDDLE",
            "FARMING ZONE",
            "TOP TREE",
            "MIDDLE ROADS",
            "BOSS GATE",
            "TOP POST",
            "D4C PLACE"
        },
        Multi = false,
        Default = 1,
    })

    -- Teleport function
    local function teleportPlayer(position)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        humanoidRootPart.CFrame = CFrame.new(position)
        Fluent:Notify({
            Title = "Teleport",
            Content = "Successful ang tp!",
            Duration = 3
        })
    end

    -- Handle dropdown selection
    MapDropdown:OnChanged(function(Value)
        local locations = {
            ["MIDDLE"] = Vector3.new(1345, 623, -506),
            ["FARMING ZONE"] = Vector3.new(-285, 511, -1486),
            ["TOP TREE"] = Vector3.new(1114, 515, -550),
            ["MIDDLE ROADS"] = Vector3.new(1133, 420, -638),
            ["BOSS GATE"] = Vector3.new(1485, 401, -631),
            ["TOP POST"] = Vector3.new(1159, 454, -596),
            ["D4C PLACE"] = Vector3.new(-3092, 500, -440)
        }
        
        if locations[Value] then
            teleportPlayer(locations[Value])
        end
    end)

    -- =============================================================
    -- SECTION: ESP
    -- =============================================================

    local ESPEnabled = false
    local ESPSettings = {
        ShowNames = true,
        ShowHealth = true,
        ShowDistance = true,
        BoxESP = true,
        TracerESP = false,
        MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 0, 0)
    }

    local ESPObjects = {}

    local function CreateESP(player)
        if player == game.Players.LocalPlayer then return end
        
        local esp = {}
        
        -- Create the BoxHandleAdornment for ESP box
        esp.Box = Instance.new("BoxHandleAdornment")
        esp.Box.Name = "ESPBox"
        esp.Box.Size = Vector3.new(4, 5, 2)
        esp.Box.Color3 = ESPSettings.BoxColor
        esp.Box.Transparency = 0.7
        esp.Box.ZIndex = 0
        esp.Box.AlwaysOnTop = true
        esp.Box.Visible = ESPSettings.BoxESP
        
        -- Create BillboardGui for player info
        esp.Billboard = Instance.new("BillboardGui")
        esp.Billboard.Name = "ESPBillboard"
        esp.Billboard.Size = UDim2.new(0, 200, 0, 50)
        esp.Billboard.AlwaysOnTop = true
        esp.Billboard.StudsOffset = Vector3.new(0, 2, 0)
        esp.Billboard.Adornee = nil
        esp.Billboard.Enabled = true
        
        -- Info Text Label
        esp.TextLabel = Instance.new("TextLabel")
        esp.TextLabel.BackgroundTransparency = 1
        esp.TextLabel.Size = UDim2.new(1, 0, 1, 0)
        esp.TextLabel.Font = Enum.Font.SourceSansBold
        esp.TextLabel.TextColor3 = ESPSettings.TextColor
        esp.TextLabel.TextStrokeTransparency = 0.3
        esp.TextLabel.TextSize = 14
        esp.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        esp.TextLabel.Parent = esp.Billboard
        
        -- Create the tracer
        esp.Tracer = Instance.new("LineHandleAdornment")
        esp.Tracer.Thickness = 1
        esp.Tracer.Color3 = ESPSettings.TracerColor
        esp.Tracer.AlwaysOnTop = true
        esp.Tracer.ZIndex = 1
        esp.Tracer.Transparency = 0.5
        esp.Tracer.Visible = ESPSettings.TracerESP
        
        -- Make sure to add these objects to safe places to avoid errors
        esp.Box.Parent = game.CoreGui
        esp.Billboard.Parent = game.CoreGui
        esp.Tracer.Parent = game.CoreGui
        
        ESPObjects[player] = esp
    end

    local function UpdateESP()
        for player, esp in pairs(ESPObjects) do
            -- Check if player is still valid
            if not player or not player.Parent then
                -- Clean up ESP objects if player left
                if esp.Box then esp.Box:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
                if esp.Tracer then esp.Tracer:Destroy() end
                ESPObjects[player] = nil
                continue
            end
            
            -- Check if character exists
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                local localPlayer = game.Players.LocalPlayer
                
                -- Check if local player character exists
                if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    esp.Box.Adornee = nil
                    esp.Billboard.Enabled = false
                    esp.Tracer.Adornee = nil
                    continue
                end
                
                local localCharacter = localPlayer.Character
                local distance = (localCharacter.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                
                -- Check distance
                if distance <= ESPSettings.MaxDistance then
                    -- Update box
                    esp.Box.Adornee = humanoidRootPart
                    esp.Box.Visible = ESPSettings.BoxESP and ESPEnabled
                    
                    -- Update billboard
                    esp.Billboard.Adornee = humanoidRootPart
                    esp.Billboard.Enabled = ESPEnabled
                    
                    -- Update text
                    local text = ""
                    if ESPSettings.ShowNames then
                        text = text .. player.Name .. "\n"
                    end
                    if ESPSettings.ShowHealth then
                        text = text .. "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "\n"
                    end
                    if ESPSettings.ShowDistance then
                        text = text .. "Distance: " .. math.floor(distance) .. "\n"
                    end
                    esp.TextLabel.Text = text
                    
                    -- Update tracer
                    esp.Tracer.Adornee = humanoidRootPart
                    esp.Tracer.Visible = ESPSettings.TracerESP and ESPEnabled
                    esp.Tracer.Length = distance
                    
                    -- Set proper CFrame for tracer - fixed direction
                    local from = CFrame.new(localCharacter.HumanoidRootPart.Position)
                    local to = CFrame.new(humanoidRootPart.Position)
                    esp.Tracer.CFrame = CFrame.lookAt(from.Position, to.Position)
                    
                    -- Ensure the tracer originates from local player
                    esp.Tracer.Adornee = localCharacter.HumanoidRootPart
                else
                    -- Hide ESP if outside max distance
                    esp.Box.Adornee = nil
                    esp.Billboard.Enabled = false
                    esp.Tracer.Adornee = nil
                end
            else
                -- Hide ESP if player character doesn't exist
                esp.Box.Adornee = nil
                esp.Billboard.Enabled = false
                esp.Tracer.Adornee = nil
            end
        end
    end

    local function PlayerRemoving(player)
        if ESPObjects[player] then
            local esp = ESPObjects[player]
            if esp.Box then esp.Box:Destroy() end
            if esp.Billboard then esp.Billboard:Destroy() end
            if esp.Tracer then esp.Tracer:Destroy() end
            ESPObjects[player] = nil
        end
    end

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            CreateESP(player)
        end
    end

    game.Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)

    game.Players.PlayerRemoving:Connect(PlayerRemoving)

    local espUpdateConnection = nil

    local function ToggleESP(enabled)
        ESPEnabled = enabled
        
        if ESPEnabled then
            -- Start updating ESP if not already running
            if not espUpdateConnection or not espUpdateConnection.Connected then
                espUpdateConnection = game:GetService("RunService").RenderStepped:Connect(UpdateESP)
            end
        else
            -- Stop updating ESP
            if espUpdateConnection and espUpdateConnection.Connected then
                espUpdateConnection:Disconnect()
                espUpdateConnection = nil -- Clear the variable
            end
            
            -- Hide all ESP elements
            for _, esp in pairs(ESPObjects) do
                if esp.Box then esp.Box.Adornee = nil end
                if esp.Billboard then esp.Billboard.Enabled = false end
                if esp.Tracer then esp.Tracer.Adornee = nil end
            end
        end
    end

    local ESPToggle = Tabs.ESP:AddToggle("ESPToggle", {
        Title = "ESP",
        Description = "I-ON ang ESP",
        Default = false,
        Callback = function(Value)
            ToggleESP(Value)
        end
    })
    
    local BoxToggle = Tabs.ESP:AddToggle("BoxESPToggle", {
        Title = "Box ESP",
        Default = true,
        Callback = function(Value)
            ESPSettings.BoxESP = Value
        end
    })
    
    local TracerToggle = Tabs.ESP:AddToggle("TracerESPToggle", {
        Title = "Tracer ESP",
        Default = false,
        Callback = function(Value)
            ESPSettings.TracerESP = Value
        end
    })
    
    local NameToggle = Tabs.ESP:AddToggle("NameESPToggle", {
        Title = "ESP Names",
        Default = true,
        Callback = function(Value)
            ESPSettings.ShowNames = Value
        end
    })
    
    local HealthToggle = Tabs.ESP:AddToggle("HealthESPToggle", {
        Title = "ESP Health",
        Default = true,
        Callback = function(Value)
            ESPSettings.ShowHealth = Value
        end
    })
    
    local DistanceToggle = Tabs.ESP:AddToggle("DistanceESPToggle", {
        Title = "ESP Distance",
        Default = true,
        Callback = function(Value)
            ESPSettings.ShowDistance = Value
        end
    })
    
    local DistanceSlider = Tabs.ESP:AddSlider("MaxDistanceSlider", {
        Title = "Max ESP Distance",
        Description = "Maximum distance to render ESP",
        Default = 2000,
        Min = 50,
        Max = 5000,
        Rounding = 0,
        Callback = function(Value)
            ESPSettings.MaxDistance = Value
        end
    })
    
    local BoxColorPicker = Tabs.ESP:AddColorpicker("BoxColor", {
        Title = "Box Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(Value)
            ESPSettings.BoxColor = Value
            for _, esp in pairs(ESPObjects) do
                if esp.Box then
                    esp.Box.Color3 = Value
                end
            end
        end
    })
    
    local TextColorPicker = Tabs.ESP:AddColorpicker("TextColor", {
        Title = "Text Color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(Value)
            ESPSettings.TextColor = Value
            for _, esp in pairs(ESPObjects) do
                if esp.TextLabel then
                    esp.TextLabel.TextColor3 = Value
                end
            end
        end
    })
    
    local TracerColorPicker = Tabs.ESP:AddColorpicker("TracerColor", {
        Title = "Tracer Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(Value)
            ESPSettings.TracerColor = Value
            for _, esp in pairs(ESPObjects) do
                if esp.Tracer then
                    esp.Tracer.Color3 = Value
                end
            end
        end
    })

    -- OTHER SCRIPTS

    Tabs.OtherScripts:AddButton({
        Title = "SAMURAI HBE",
        Description = "Pislita para mugana ang samurai HBE",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/samurai_hbe.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "MOOVE CHECKER",
        Description = "Pislita para mugana ang moove checker",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kroutaz/Move/refs/heads/main/codelearner.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "KWA-ON COORDINATES",
        Description = "Makuha ang coordinates",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/GetCoordinatesScript.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "PLAYER TELEPORTASYON",
        Description = "Kung imong pisliton ang mga user ma tp ka sa ilang destinasyon",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/PlayerTeleportation.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "CHAT BYPASSER",
        Description = "I bypass ang mga tags words",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AnnaRoblox/AnnaBypasser/refs/heads/main/AnnaBypasser.lua",true))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "INF YIELD",
        Description = "Mugana ang inf yield",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "VIEW PLAYER",
        Description = "Tan-awon ang player",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/ViewPlayer.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "FOLLOW PLAYER BACK",
        Description = "Ma tp ka sa ilang likod",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/FollowPlayersBack.lua",true))()
        end
    })

    -- ============================================================
    -- SECTION: PLAYER
    -- ============================================================
    ---------------------------------------------------------------
    -- Player: Variables
    ---------------------------------------------------------------
    local PlayerSettings = {
        SelectedPlayer = nil,
        Speed = 16,
        FlySpeed = 50,
        IsFlying = false
    }
    
    ---------------------------------------------------------------
    -- Player: Functions
    ---------------------------------------------------------------
    
    -- Function to get all players' names as dropdown options
    local function GetPlayerList()
        local playerList = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        return playerList
    end
    
    -- Function to teleport to selected player
    local function TeleportToPlayer(playerName)
        local localPlayer = game.Players.LocalPlayer
        local targetPlayer = game.Players:FindFirstChild(playerName)
        
        if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Fluent:Notify({
                Title = "Teleport Failed",
                Content = "Player doesn't exist or has no character!",
                Duration = 3
            })
            return
        end
        
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Fluent:Notify({
                Title = "Teleport Failed",
                Content = "Your character doesn't exist!",
                Duration = 3
            })
            return
        end
        
        -- Teleport
        localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        
        Fluent:Notify({
            Title = "Teleport Success",
            Content = "Teleported to " .. playerName,
            Duration = 3
        })
    end
    
    -- Function to spectate/view a player
    local function SpectatePlayer(playerName, enable)
        local localPlayer = game.Players.LocalPlayer
        local targetPlayer = game.Players:FindFirstChild(playerName)
        
        if not enable then
            -- Stop spectating
            if localPlayer.CameraMode ~= Enum.CameraMode.Classic then
                localPlayer.CameraMode = Enum.CameraMode.Classic
            end
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = localPlayer.Character
            end
            return
        end
        
        if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Humanoid") then
            Fluent:Notify({
                Title = "Spectate Failed",
                Content = "Player doesn't exist or has no character!",
                Duration = 3
            })
            return
        end
        
        -- Start spectating
        workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
        
        Fluent:Notify({
            Title = "Spectate Enabled",
            Content = "Now spectating " .. playerName,
            Duration = 3
        })
    end
    
    -- Function to enable/disable flying
    local flyConnection = nil
    local function ToggleFly(enable)
        local localPlayer = game.Players.LocalPlayer
        
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Fluent:Notify({
                Title = "Fly Failed",
                Content = "Your character doesn't exist!",
                Duration = 3
            })
            return
        end
        
        PlayerSettings.IsFlying = enable
        
        if enable then
            -- Create fly function
            local humanoidRootPart = localPlayer.Character.HumanoidRootPart
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            -- Disable jumping and keep character airborne
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            
            -- Enable flying with WASD and arrow keys
            if not flyConnection or not flyConnection.Connected then
                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not PlayerSettings.IsFlying then return end
                    
                    local camera = workspace.CurrentCamera
                    local moveDirection = Vector3.new(0, 0, 0)
                    
                    -- Forward and backward
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Up) then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Down) then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    
                    -- Left and right
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Left) then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Right) then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    
                    -- Up and down
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end
                    
                    -- Normalize and apply the movement
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit * PlayerSettings.FlySpeed
                        humanoidRootPart.Velocity = moveDirection
                    else
                        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    -- Prevent falling
                    humanoidRootPart.Anchored = (moveDirection.Magnitude == 0)
                end)
            end
            
            Fluent:Notify({
                Title = "Fly Enabled",
                Content = "Use WASD to move, Space to go up, Shift to go down",
                Duration = 5
            })
        else
            -- Disable flying
            if flyConnection and flyConnection.Connected then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = localPlayer.Character.HumanoidRootPart
            
            -- Re-enable normal character state
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            -- Unanchor character
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
            end
            
            Fluent:Notify({
                Title = "Fly Disabled",
                Content = "Flying has been disabled",
                Duration = 3
            })
        end
    end
    
    -- Function to set player speed
    local function SetSpeed(speed)
        local localPlayer = game.Players.LocalPlayer
        
        if not localPlayer.Character or not localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Fluent:Notify({
                Title = "Speed Failed",
                Content = "Your character or humanoid doesn't exist!",
                Duration = 3
            })
            return
        end
        
        localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
        
        Fluent:Notify({
            Title = "Speed Changed",
            Content = "Walk speed set to " .. speed,
            Duration = 3
        })
    end
    
    ---------------------------------------------------------------
    -- Player: UI Elements
    ---------------------------------------------------------------
    
    -- Section for Player Selection
    local PlayerSection = Tabs.Player:AddSection("Player Selection")
    
    -- Player Dropdown
    local PlayerDropdown = Tabs.Player:AddDropdown("PlayerDropdown", {
        Title = "Select Player",
        Description = "Choose a player to interact with",
        Values = GetPlayerList(),
        Default = 1,
        Callback = function(Value)
            PlayerSettings.SelectedPlayer = Value
        end
    })
    
    -- Refresh Player List Button
    local RefreshButton = Tabs.Player:AddButton({
        Title = "Refresh Player List",
        Description = "Update the player dropdown list",
        Callback = function()
            local newList = GetPlayerList()
            PlayerDropdown:SetValues(newList)
            
            Fluent:Notify({
                Title = "Player List Refreshed",
                Content = "Found " .. #newList .. " players",
                Duration = 3
            })
        end
    })
    
    -- Teleport Button
    local TeleportButton = Tabs.Player:AddButton({
        Title = "Teleport to Player",
        Description = "Teleport to the selected player",
        Callback = function()
            if PlayerSettings.SelectedPlayer then
                TeleportToPlayer(PlayerSettings.SelectedPlayer)
            else
                Fluent:Notify({
                    Title = "Teleport Failed",
                    Content = "No player selected!",
                    Duration = 3
                })
            end
        end
    })
    
    -- Spectate Toggle
    local SpectateToggle = Tabs.Player:AddToggle("SpectateToggle", {
        Title = "Spectate Player",
        Description = "View the selected player",
        Default = false,
        Callback = function(Value)
            if PlayerSettings.SelectedPlayer then
                SpectatePlayer(PlayerSettings.SelectedPlayer, Value)
            else
                Fluent:Notify({
                    Title = "Spectate Failed",
                    Content = "No player selected!",
                    Duration = 3
                })
                -- Reset the toggle if no player is selected
                SpectateToggle:Set(false)
            end
        end
    })
    
    -- Section for Local Player
    local LocalPlayerSection = Tabs.Player:AddSection("Local Player")
    
    -- Fly Toggle
    local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {
        Title = "Fly",
        Description = "Toggle flying mode",
        Default = false,
        Callback = function(Value)
            ToggleFly(Value)
        end
    })
    
    -- Fly Speed Slider
    local FlySpeedSlider = Tabs.Player:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed",
        Description = "Adjust flying speed",
        Default = 50,
        Min = 10,
        Max = 250,
        Rounding = 0,
        Callback = function(Value)
            PlayerSettings.FlySpeed = Value
        end
    })
    
    -- Walk Speed Slider
    local SpeedSlider = Tabs.Player:AddSlider("SpeedSlider", {
        Title = "Walk Speed",
        Description = "Adjust walking speed",
        Default = 16,
        Min = 16,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            PlayerSettings.Speed = Value
            SetSpeed(Value)
        end
    })
    
    -- Reset Character Button
    local ResetButton = Tabs.Player:AddButton({
        Title = "Reset Character",
        Description = "Reset your character to default state",
        Callback = function()
            local localPlayer = game.Players.LocalPlayer
            if localPlayer.Character then
                localPlayer.Character:BreakJoints()
                Fluent:Notify({
                    Title = "Character Reset",
                    Content = "Your character has been reset",
                    Duration = 3
                })
            end
        end
    })

    -- CREDITS

    Tabs.Credits:AddParagraph({
        Title = "Script Founder: greentownXVI (Prince)",
        Content = "Roblox: greentownXVI",
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "GREENTOWN HUB SA | MAIN",
    Content = "NA LOAD NA ANG SCRIPT.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()