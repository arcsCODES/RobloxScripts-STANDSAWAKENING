local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.Two
})

local Tabs = {
    Script = Window:AddTab({ Title = "Scripts", Icon = "align-center" }),
    TsSounds = Window:AddTab({ Title = "TS sounds", Icon = "speaker" }),
    Sound = Window:AddTab({ Title = "Sounds", Icon = "file-audio" }),
    Maps = Window:AddTab({ Title = "Maps", Icon = "map" }),
    OtherScripts = Window:AddTab({ Title = "Other scripts", Icon = "anchor" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "bell" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    -- Add Toggle for keybind timestop
    local TimestopToggle = Tabs.Script:AddToggle("TimestopToggle", {
        Title = "15s TS", 
        Description = "Press [LCTRL] to activate",
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

    -- TS MOVE
    local MoveToggle = Tabs.Script:AddToggle("MoveToggle", {
        Title = "MOVE IN TS", 
        Description = "Able to move in timestop",
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

    -- STW H
    local AttackToggle = Tabs.Script:AddToggle("AttackToggle", {
        Title = "STW H", 
        Description = "H Forever",
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
        Title = "D4C Clones", 
        Description = "Hold [F2] and [F3] to activate",
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
        Description = "Block glitch",
        Default = false 
    })

    BlockToggle:OnChanged(function(state)
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "Block")
        print(state and "Blocking enabled" or "Blocking disabled")
    end)

    local EmeraldToggle = Tabs.Script:AddToggle("EmeraldToggle", {
    Title = "HG EMERALD SPLASH WIDE", 
    Description = "Hold [LCTRL] to activate wide splash loop",
    Default = false 
})

local emeraldSplashActive = false
local emeraldSplashConnection
local loopConnection

EmeraldToggle:OnChanged(function(state)
    local function startEmeraldLoop()
        if loopConnection then return end
        
        emeraldSplashActive = true
        loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if emeraldSplashActive then
                -- Create wide spread of emeralds by firing multiple projectiles at different angles
                local mouseHit = game.Players.LocalPlayer:GetMouse().Hit
                local basePosition = mouseHit.Position
                
                for angle = 0, 359, 36 do -- 10 projectiles in a circular pattern
                    local rad = math.rad(angle)
                    local offset = Vector3.new(math.cos(rad) * 5, 0, math.sin(rad) * 5)
                    local targetPosition = CFrame.new(basePosition + offset)
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, targetPosition)
                end
                
                -- Add some random emeralds for extra coverage
                for i = 1, 5 do
                    local randomOffset = Vector3.new(math.random(-10, 10), math.random(-2, 2), math.random(-10, 10))
                    local targetPosition = CFrame.new(basePosition + randomOffset)
                    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, targetPosition)
                end
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
        print("Wide Emerald Splash enabled - Hold LCTRL to activate")
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
        print("Wide Emerald Splash disabled")
    end
end)

    -- SANS STAMINA VIEWER
    local StaminaToggle = Tabs.Script:AddToggle("StaminaToggle", {
        Title = "SANS STAMINA", 
        Description = "View sans stamina",
        Default = false 
    })

    local staminaConnection

    StaminaToggle:OnChanged(function(state)
        local function createOrUpdateStaminaGui(player, staminaValue)
            local playerGui = player:FindFirstChild("PlayerGui")
            if not playerGui then return end
            
            local screenGui = playerGui:FindFirstChild("StaminaGui") or Instance.new("ScreenGui")
            screenGui.Name = "StaminaGui"
            screenGui.Parent = playerGui
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            
            local frame = screenGui:FindFirstChild("StaminaFrame") or Instance.new("Frame")
            frame.Name = "StaminaFrame"
            frame.Size = UDim2.new(0, 200, 0, 30)
            frame.Position = UDim2.new(0.5, -100, 0, 10)
            frame.BackgroundTransparency = 0.5
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.BorderSizePixel = 0
            frame.Parent = screenGui
            
            local nameLabel = frame:FindFirstChild("NameLabel") or Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.Text = player.Name
            nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextYAlignment = Enum.TextYAlignment.Center
            nameLabel.Parent = frame
            
            local valueLabel = frame:FindFirstChild("ValueLabel") or Instance.new("TextLabel")
            valueLabel.Name = "ValueLabel"
            valueLabel.Text = tostring(math.floor(staminaValue)) .. "%"
            valueLabel.Size = UDim2.new(1, 0, 0.4, 0)
            valueLabel.Position = UDim2.new(0, 0, 0.6, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.TextYAlignment = Enum.TextYAlignment.Center
            valueLabel.Parent = frame
            
            local barContainer = frame:FindFirstChild("BarContainer") or Instance.new("Frame")
            barContainer.Name = "BarContainer"
            barContainer.Size = UDim2.new(1, -10, 0.4, 0)
            barContainer.Position = UDim2.new(0, 5, 0.4, 0)
            barContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            barContainer.BorderSizePixel = 0
            barContainer.Parent = frame
            
            local bar = barContainer:FindFirstChild("StaminaBar") or Instance.new("Frame")
            bar.Name = "StaminaBar"
            
            local barColor
            if staminaValue > 70 then
                barColor = Color3.fromRGB(0, 255, 0)
            elseif staminaValue > 30 then
                barColor = Color3.fromRGB(255, 255, 0)
            else
                barColor = Color3.fromRGB(255, 0, 0)
            end
            
            bar.BackgroundColor3 = barColor
            bar.Size = UDim2.new(staminaValue/100, 0, 1, 0)
            bar.BorderSizePixel = 0
            bar.Parent = barContainer
        end

        local function getPlayerStamina(player)
            if not player then return end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid", 5)
            
            local staminaValue = 100
            
            if humanoid and humanoid:FindFirstChild("Stamina") then
                staminaValue = humanoid.Stamina.Value
            elseif player:FindFirstChild("leaderstats") then
                local stats = player.leaderstats
                if stats:FindFirstChild("Stamina") then
                    staminaValue = stats.Stamina.Value
                end
            else
                local playerPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                if playerPart then
                    local maxStamina = playerPart:FindFirstChild("MaxStamina")
                    if maxStamina then
                        local stamina = maxStamina:FindFirstChild("Stamina")
                        if stamina then
                            staminaValue = stamina.Value
                        end
                    end
                end
            end
            
            createOrUpdateStaminaGui(player, staminaValue)
            return staminaValue
        end

        local function updateStaminaGuis()
            for _, player in pairs(game.Players:GetPlayers()) do
                coroutine.wrap(function()
                    pcall(getPlayerStamina, player)
                end)()
            end
        end

        if state then
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    getPlayerStamina(player)
                end)
                
                if player.Character then
                    getPlayerStamina(player)
                end
            end)
            
            staminaConnection = game:GetService("RunService").RenderStepped:Connect(function()
                updateStaminaGuis()
            end)
            
            task.wait(1)
            updateStaminaGuis()
            print("Stamina viewer enabled")
        else
            if staminaConnection then
                staminaConnection:Disconnect()
                staminaConnection = nil
            end
            
            for _, player in pairs(game.Players:GetPlayers()) do
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui and playerGui:FindFirstChild("StaminaGui") then
                    playerGui.StaminaGui:Destroy()
                end
            end
            print("Stamina viewer disabled")
        end
    end)

    -- RIFT SLICE
    local riftSliceConnection
    local riftSliceActive = false

    local RiftSliceToggle = Tabs.Script:AddToggle("RiftSliceToggle", {
        Title = "REAVER RIFT SLICE", 
        Description = "Toggle rift slice with [F]",
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
        Description = "Gives you alot of frames by using [C]",
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
        Description = "When timestops, by spamming [1] to throw alot of knives",
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
        Description = "Makes your stand invisible",
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
        Description = "Counter forever",
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
        Description = "Press [B] to activate",
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
        Description = "Work until you die",
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
        Description = "Shows HP bar",
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
        Description = "Toggle the sounds",
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
        Description = "Number of sounds to play at once",
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
        Title = "Map Locations",
        Description = "Select a location to teleport to",
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
            Content = "Successfully teleported!",
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

    -- OTHER SCRIPTS

    Tabs.OtherScripts:AddButton({
        Title = "SAMURAI HBE",
        Description = "Activates samurai HBE script",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/samurai_hbe.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "MOOVE CHECKER",
        Description = "Activates moove checker script",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kroutaz/Move/refs/heads/main/codelearner.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "GET COORDINATES",
        Description = "Activates coordinates script",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/GetCoordinatesScript.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "PLAYER TELEPORTATION",
        Description = "Clicking any user will get you tp'ed by their location",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/PlayerTeleportation.lua"))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "CHAT BYPASSER",
        Description = "Bypass tags words",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AnnaRoblox/AnnaBypasser/refs/heads/main/AnnaBypasser.lua",true))()
        end
    })

    Tabs.OtherScripts:AddButton({
        Title = "INF YIELD",
        Description = "Activate inf yield",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
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
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()