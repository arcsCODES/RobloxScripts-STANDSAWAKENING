-- ====================================================================
-- SECTION 1: MAG HIMO UG UI
-- ====================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ====================================================================
-- SECTION 2: MAG HIMO UG WINDOW
-- ====================================================================
local Window = Library.CreateLib("green Hub | SA", "BloodTheme")

-- ---------------------------------------------
-- MAG CREATE UG TAB
-- ---------------------------------------------
local PlrTab = Window:NewTab("Scripts")

-- ====================================================================
-- SECTION 3: MAGHIMO UG MGA SCRIPT LIST (SCRIPT TAB) 
-- ====================================================================
local ScriptSection = PlrTab:NewSection("Mga Scripts")

-- ---------------------------------------------
-- ABRE/SIRADO ANG GUI
-- ---------------------------------------------
ScriptSection:NewKeybind("abre/sirado ang GUI", "Pislita ang F1 para mo abre/sirado ang GUI", Enum.KeyCode.F1, function()
    Library:ToggleUI()
end)

-- ====================================================================
-- SECTION 4: 15s BUTTON (SCRIPT TAB) 
-- ====================================================================
ScriptSection:NewToggle("15s TS", "Pislita ang [LEFT_CONTROL] para mo gana", function(state)
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

local toggleConnection

ScriptSection:NewToggle("LIHOK SA TIMESTOP", "I-toggle para mo gana", function(state)
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

local moveConnection

-- ====================================================================
-- SECTION 5: STW H (SCRIPT TAB) 
-- ====================================================================
local attackConnection

ScriptSection:NewToggle("STW H", "Pirmi ka ma counter kung naay mag hit", function(state)
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

-- ====================================================================
-- SECTION 6: D4C CLONE (SCRIPT TAB) 
-- ====================================================================
local f2Connection, f3Connection
local isHoldingF3, isHoldingF2 = false, false

ScriptSection:NewToggle("D4C CLONE", "Pislita ang [F2] para mo gana ug [F3] para da death clone", function(state)
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

-- ====================================================================
-- SECTION 7: BLOCK GLITCH (SCRIPT TAB) 
-- ====================================================================
ScriptSection:NewToggle("BLOCK GLITCH", "I-TOGGLE PARA MO GANA", function(state)
	local args = {"Alternate", "Block"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
    print(state and "Blocking enabled" or "Blocking disabled")
end)

-- ====================================================================
-- SECTION 8: HG EMERALD SPLASH (SCRIPT TAB) 
-- ====================================================================
local emeraldSplashConnection

ScriptSection:NewToggle("HG EMERALD SPLASH", "Pislita ang [LEFT_CONTROL] para mo gana", function(state)
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
end)

local stopLoop = false

ScriptSection:NewToggle("LOW HG EMERALD SPLASH", "I hold ang [LEFT_CONTROL] para mo gana", function(state)
	local userInputService = game:GetService("UserInputService")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local players = game:GetService("Players")
	local fireFunction = function()
		for i = 1, 5 do -- reduced to 5 emeralds to lessen lag
			replicatedStorage:WaitForChild("Main"):WaitForChild("Input"):FireServer("Alternate", "EmeraldProjectile2", false, players.LocalPlayer:GetMouse().Hit)
		end
	end

	local function onInputBegan(input, gameProcessedEvent)
		if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl then
			stopLoop = false
			task.spawn(function()
				while not stopLoop do
					fireFunction()
					task.wait(0.2) -- wait to reduce stress on your ping (adjust this if needed)
				end
			end)
		end
	end

	local function onInputEnded(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.LeftControl then
			stopLoop = true
		end
	end

	if state then
		emeraldSplashConnection = userInputService.InputBegan:Connect(onInputBegan)
		userInputService.InputEnded:Connect(onInputEnded)
		print("Emerald Splash enabled")
	else
		if emeraldSplashConnection then
			emeraldSplashConnection:Disconnect()
			emeraldSplashConnection = nil
		end
		stopLoop = true
		print("Emerald Splash disabled")
	end
end)

-- ====================================================================
-- SECTION 8: SANS STAMINA VIEWER (SCRIPT TAB) 
-- ====================================================================
local toggleConnectionsans

ScriptSection:NewToggle("TAN-AWON ANG SANS STAMINA", "i-toggle para mo gana", function(state)
	if state then
		function createOrUpdateStaminaGui(player, staminaValue)
			local character = player.Character
			if not character then return end

			local existingGui = character:FindFirstChild("StaminaGui")
			if existingGui then
				local textLabel = existingGui:FindFirstChild("TextLabel")
				if textLabel then
					textLabel.Text = "Stamina: " .. staminaValue
				end
			else
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "StaminaGui"
				billboardGui.Adornee = character:FindFirstChild("Head")
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
	end

	function getPlayerStamina(player)
		local playerPart = game.Workspace:FindFirstChild(player.Name)

		if playerPart then
			local maxStamina = playerPart:FindFirstChild("MaxStamina")

			if maxStamina then
				local stamina = maxStamina:FindFirstChild("Stamina")

				if stamina then

					createOrUpdateStaminaGui(player, stamina.Value)

				else

				end

			else

			end

		else

		end
	end
	
	function updateStaminaGuis()
		for _, player in pairs(game.Players:GetPlayers()) do
			getPlayerStamina(player)
		end
	end
	
	game.Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			getPlayerStamina(player)
		end)
	end)
	
	-- Start stamina GUI loop in a coroutine
	coroutine.wrap(function()
		while true do
			updateStaminaGuis()
			wait(0.6)
		end
	end)()
	
	-- Example: Wrap this in a toggle function or event
	function toggleAttack(state)
		if state then
			local attackCoroutine = coroutine.wrap(attackLoop)
			attackCoroutine()
			print("Attack enabled")
		else
			state = false
			print("off")
		end
	end
end)

-- ====================================================================
-- SECTION 9: REAVER RIFT SLICE (SCRIPT TAB) 
-- ====================================================================
local riftSliceConnection
local riftSliceActive = false

ScriptSection:NewToggle("REAVER RIFT SLICE", "Pislita ang [F] para mo gana", function(state)
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

-- ====================================================================
-- SECTION 10: ONI GODMODE (SCRIPT TAB) 
-- ====================================================================
local godModeCoroutine
local isGodModeActive = false

ScriptSection:NewToggle("ONI GODMODE", "i-toggle para mo gana", function(state)
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
end)

-- ====================================================================
-- SECTION 11: VTW KNIFE (SCRIPT TAB) 
-- ====================================================================
local knifeConnection
local holdingKnifeConnection

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local isHolding = false 

local function throwKnife()
    local targetPosition = mouse.Hit.p
    local args = {
        [1] = "Alternate",
        [2] = "Knife",
        [3] = targetPosition
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
end

ScriptSection:NewToggle("VTW KNIFE", "pislita ang [1] para mogana dapat naay timestop", function(state)
	if state then
        -- Input began connection
        knifeConnection = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.One and not isHolding then
                isHolding = true
                -- Continuous knife throwing while holding the key "1"
                holdingKnifeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if isHolding then
                        throwKnife()
                    end
                end)
            end
        end)
        
        -- Input ended connection to stop when key "1" is released
        knifeConnection = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.One then
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
        if knifeConnection then
            knifeConnection:Disconnect()
            knifeConnection = nil
        end
        if holdingKnifeConnection then
            holdingKnifeConnection:Disconnect()
            holdingKnifeConnection = nil
        end
        isHolding = false
        print("Knife throw disabled")
    end
end)

-- ====================================================================
-- SECTION 12: STAND INVISIBLE (SCRIPT TAB) 
-- ====================================================================
local standInvisible = false

ScriptSection:NewToggle("INVISIBLE STAND", "i-toggle para mo gana", function(state)
	local args = {"Alternate", "Appear", tostring(state)}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
    print(state and "Stand made invisible" or "Stand made visible")
end)

-- ====================================================================
-- SECTION 13: STANDLESS COUNTER (SCRIPT TAB) 
-- ====================================================================
local counterCoroutine

ScriptSection:NewToggle("STANDLESS COUNTER", "i-toggle para mo gana", function(state)
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
        counterCoroutine = coroutine.create(counterLoop)
        coroutine.resume(counterCoroutine)
        print("Counter attack of Standless enabled")
    else
        if counterCoroutine then
            coroutine.cancel(counterCoroutine)
            counterCoroutine = nil
        end
        print("Counter attack of Standless disabled")
    end
end)

-- ====================================================================
-- SECTION 14: GER RTZ (SCRIPT TAB) 
-- ====================================================================
local triggerConnection

local Main = game:GetService("ReplicatedStorage"):WaitForChild("Main")
local Input = Main:WaitForChild("Input")
local UserInputService = game:GetService("UserInputService")

local function triggerServerEvent()
    local args = {
        [1] = "Alternate",
        [2] = "RTZ",
        [3] = true
    }

    Input:FireServer(unpack(args)) -- Trigger the server event with the provided args
end

ScriptSection:NewToggle("GER RTZ", "Pislita ang [B] para mo gana", function(state)
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
end)

-- ====================================================================
-- SECTION 15: REAVER SPAM SCYTHE (SCRIPT TAB) 
-- ====================================================================
ScriptSection:NewToggle("REAPER SPAM SCYTHE", "Mo gana hantod ma mamatay ang avatar", function()
    repeat
        local args1 = {
            [1] = "Alternate",
            [2] = "Throw2"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args1))

        local args2 = {
            [1] = "Alternate",
            [2] = "Throw"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args2))

        wait(0.4)
    until game.Players.LocalPlayer.Character.Humanoid.Health <= 0
end)

-- ====================================================================
-- SECTION 16: HP BAR (SCRIPT TAB) 
-- ====================================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local healthGui = nil -- Store the health GUI here
local toggleConnection = nil -- To manage the connection

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

ScriptSection:NewToggle("PLAYER HP BAR", "i-toggle para mo gana", function(state)
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
end)

-- ====================================================================
-- SECTION 17: MAG HIMO UG TAB (TS SOUNDS)
-- ====================================================================
local TSsoundTab = Window:NewTab("TS Sounds")
local TsSoundSection = TSsoundTab:NewSection("Timestop sounds")

TsSoundSection:NewButton("(OLD) DIO OVA", "Pislita ang button para mo gana", function()
	local args = {15, "dioova"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("(OLD) JOTARO OVA", "Pislita ang button para mo gana", function()
	local args = {15, "jotaroova"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("JSP", "Pislita ang button para mo gana", function()
	local args = {15, "jotaro"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("SPTW", "Pislita ang button para mo gana", function()
	local args = {15, "P4"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("TWOH", "Pislita ang button para mo gana", function()
	local args = {15, "diooh"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("STW", "Pislita ang button para mo gana", function()
	local args = {15, "shadowdio"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("TW", "Pislita ang button para mo gana", function()
	local args = {15, "theworldnew"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundSection:NewButton("TWAU", "Pislita ang button para mo gana", function()
	local args = {15, "diego"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

-- ====================================================================
-- SECTION 18: MAG HIMO UG TAB (SOUNDS)
-- ====================================================================
local SoundTab = Window:NewTab("Sounds")
local SoundSection = SoundTab:NewSection("Mag generate ug mga sounds")

local sounds = {}
local lastPlayedSound
local soundLoopActive = false
local soundCount = 1
local soundLoopConnection

local function getSounds(loc)
	if loc:IsA("Sound") then
		table.insert(sounds, loc)
	end
	for _, obj in pairs(loc:GetChildren()) do
		getSounds(obj)
	end
end

getSounds(game)

game.DescendantAdded:Connect(function(obj)
	if obj:IsA("Sound") then
		table.insert(sounds, obj)
	end
end)

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

--------------------------------------------------------
-- SOUND TOGGLE UG SLIDER
--------------------------------------------------------
SoundSection:NewToggle("SOUND", "ON OR OFF", function(state)
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

SoundSection:NewSlider("PILA KA SOUND", "SOUND", 100, 0, 100, 1, function(value)
	soundCount = Value
end)

-- ====================================================================
-- SECTION 19: MAG HIMO UG TAB (MAPS)
-- ====================================================================
local MapTab = Window:NewTab("Maps")
local MapSection = MapTab:NewSection("TELEPORT SA MGA LOKASYON")

MapSection:NewButton("MOUNTAIN", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1345, 623, -506)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("FARMING ZONE", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(-285, 511, -1486)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("TAAS SA DAKONG PUNO", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1114, 515, -550)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("TUNGA SA MGA KALSADA", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1133, 420, -638)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("BOSS GATE", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1485, 401, -631)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("TAAS SA POSTE", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1159, 454, -596)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("LUGAR SA D4C", "Pislita ang button para maka tp ka sa isa ka lokasyon", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(-3092, 500, -440)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

-- ====================================================================
-- SECTION 20: MAG HIMO UG TAB (MGA LAING SCRIPTS)
-- ====================================================================
local OtherTab = Window:NewTab("Mga laing scripts")
local OtherSection = OtherTab:NewSection("MGA LAING SCRIPTS")

OtherSection:NewButton("SAMURAI HBE", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/samurai_hbe.lua"))()
end)

OtherSection:NewButton("KWA-ON ANG MGA COORDINATES", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/GetCoordinatesScript.lua"))()
end)

OtherSection:NewButton("PLAYER TELEPORTASYON", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/PlayerTeleportation.lua"))()
end)

OtherSection:NewButton("CHAT BYPASSER", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/AnnaRoblox/AnnaBypasser/refs/heads/main/AnnaBypasser.lua",true))()
end)

OtherSection:NewButton("TAN-AWON ANG PLAYER", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/ViewPlayer.lua"))()
end)

OtherSection:NewButton("MO TP LIKOD SA PLAYER", "PISLITA ANG BUTTON PARA MO GANA", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/FollowPlayersBack.lua",true))()
end)

-- ====================================================================
-- SECTION 21: MAG HIMO UG TAB (CREDITS)
-- ====================================================================
local CreditsTab = Window:NewTab("Credits")
local CreditSection = CreditsTab:NewSection("Credits")

CreditSection:NewButton("SCRIPT FOUNDER: greentownXVI", "MADE ALL SCRIPT", function()
	print("SCRIPT FOUNDER: greentownXVI")
end)