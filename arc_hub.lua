-- UI Library loader
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Mag-himo ug window
local Window = Fluent:CreateWindow({
    Title = "Arc's Hub | SA " .. Fluent.Version,
    SubTitle = "credits: kashmir",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Mag-himo ug tabs
local Tabs = {
    SCRIPTS = Window:AddTab({ Title = "SCRIPTS", Icon = "align-center" }),
    HBE = Window:AddTab({ Title = "HBE", Icon = "anchor" }),
    MAP = Window:AddTab({ Title = "MAPA", Icon = "map" }),
    OTHER = Window:AddTab({ Title = "LAING SCRIPTS", Icon = "book" }),
    CREDITS = Window:AddTab({ Title = "CREDITS", Icon = "info" }),
}






-- SCRIPT TAB

-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Toggle
local TimestopToggle = Tabs.SCRIPTS:AddToggle("TimestopToggle", {
    Title = "15S TS",
    Description = "pislita ang [CTRL] para mo gana",
    Default = false
})

-- Connection holder
local timestopConnection


-- 15S TIMESTOP
TimestopToggle:OnChanged(function(state)
    if state then
        timestopConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
                local args = {15, "jotaroova"}
                ReplicatedStorage:WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
                print("Timestop activated via CTRL")
            end
        end)
        print("Timestop enabled - Press Left Control to activate")
    else
        if timestopConnection then
            timestopConnection:Disconnect()
            timestopConnection = nil
        end
        print("Timestop disabled")
    end
end)


-- MOVE IN TS
local MoveToggle = Tabs.SCRIPTS:AddToggle("MoveToggle", { 
    Title = "LIHOK SA TIMESTOP",
    Description = "mo lihok sa timestop",
    Default = false
})

local moveLoopActive = false

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
    while moveLoopActive do
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

MoveToggle:OnChanged(function(state)
    if state then
        moveLoopActive = true
        task.spawn(toggleMovementLoop)
        print("Movement enabled in timestops")
    else
        moveLoopActive = false

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


-- D4C toggle
local D4CToggle = Tabs.SCRIPTS:AddToggle("D4CToggle", {
    Title = "SPAM D4C CLONES", 
    Description = "i-Hold [F2] and [F3] para mo gana",
    Default = false 
})

local f2Connection, f3Connection, inputEndedConnection
local isHoldingF3, isHoldingF2 = false, false

D4CToggle:OnChanged(function(state)
    local function bindKeys()
        local UIS = game:GetService("UserInputService")
        local RS = game:GetService("ReplicatedStorage")
        local Main = RS:WaitForChild("Main")

        f3Connection = UIS.InputBegan:Connect(function(input, isProcessed)
            if not isProcessed and input.KeyCode == Enum.KeyCode.F3 then
                if not isHoldingF3 then
                    isHoldingF3 = true
                    task.spawn(function()
                        while isHoldingF3 do
                            Main:WaitForChild("Death"):FireServer("Alternate", "Death")
                            task.wait(0)
                        end
                    end)
                end
            end
        end)

        f2Connection = UIS.InputBegan:Connect(function(input, isProcessed)
            if not isProcessed and input.KeyCode == Enum.KeyCode.F2 then
                if not isHoldingF2 then
                    isHoldingF2 = true
                    task.spawn(function()
                        while isHoldingF2 do
                            Main:WaitForChild("Input"):FireServer("Alternate", "Clone")
                            task.wait(0.1)
                        end
                    end)
                end
            end
        end)

        inputEndedConnection = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F3 then
                isHoldingF3 = false
            elseif input.KeyCode == Enum.KeyCode.F2 then
                isHoldingF2 = false
            end
        end)
    end

    local function unbindKeys()
        if f2Connection then f2Connection:Disconnect() f2Connection = nil end
        if f3Connection then f3Connection:Disconnect() f3Connection = nil end
        if inputEndedConnection then inputEndedConnection:Disconnect() inputEndedConnection = nil end
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









-- HBE TAB
Tabs.HBE:AddButton({
    Title = "CMOON HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/CMOON%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "CMOON HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "D4C (+SPAM CLONES) HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/D4C(%2Binf%20spawn%20clones)%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "D4C HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "DTW HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/DTW%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "DTW HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})


Tabs.HBE:AddButton({
    Title = "GER HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/GER%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "GER HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})


Tabs.HBE:AddButton({
    Title = "KC HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/KC%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "KC HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})


Tabs.HBE:AddButton({
    Title = "KCR HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/KCR%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "KCR HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "MIH HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/MIH%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "MIH HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "SAMURAI HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/SAMURAI%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "SAMURAI HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "SPOH HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/SPOH%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "SPOH HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "STW (+VAMP) HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/STW(%2Bvamp)%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "STW (+VAMP) HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "ULF HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/ULF%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "ULF HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.HBE:AddButton({
    Title = "VTW/TWGH HBE",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-SA-HBE/refs/heads/main/VTW%20HBE.txt"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "VTW/TWGH HBE executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})







-- MAP 
local MapDropdown = Tabs.MAP:AddDropdown("MapDropdown", { 
    Title = "Map Locations",
    Description = "Select a location to teleport to",
    Values = {
        "MIDDLE",
        "FARMING ZONE",
    },
    Multi = false,
    Default = 1,
})

-- Teleport function
local function teleportPlayer(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)
        Fluent:Notify({
            Title = "Teleport",
            Content = "Successfully teleported!",
            Duration = 3
        })
    else
        warn("HumanoidRootPart not found")
    end
end

-- Handle dropdown selection
MapDropdown:OnChanged(function(Value)
    local locations = {
        ["MIDDLE"] = Vector3.new(1345, 623, -506),
        ["FARMING ZONE"] = Vector3.new(-285, 511, -1486),
    }

    if locations[Value] then
        teleportPlayer(locations[Value])
    else
        warn("Invalid teleport location selected:", Value)
    end
end)






-- OTHER SCRIPT
Tabs.OTHER:AddButton({
    Title = "INF YIELD",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "INF YIELD executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.OTHER:AddButton({
    Title = "GET COORDINATES",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/GetCoordinatesScript.lua"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "GET COORDINATES executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.OTHER:AddButton({
    Title = "PLAYER TELEPORTASYON",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/PlayerTeleportation.lua"))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "PLAYER TELEPORTASYON executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.OTHER:AddButton({
    Title = "TP LOOP LIKOD SA PLAYER",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-UNIVERSAL/refs/heads/main/FollowPlayersBack.lua",true))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "TP LIKOD SA PLAYER executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})

Tabs.OTHER:AddButton({
    Title = "SA UTILITY",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/arcsCODES/RobloxScripts-STANDSAWAKENING/refs/heads/main/SA_UTILITY.lua",true))()
        end)

        if success then
            Fluent:Notify({
                Title = "Success",
                Content = "SA UTILITY executed successfully!",
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Execution failed: " .. tostring(err),
                Duration = 6
            })
        end
    end
})










-- CREDITS
Tabs.CREDITS:AddParagraph({
    Title = "Arc's Hub by arcturuszz",
    Content = "Special credits to the kashmirs, KashmirsMommy and Zyzches"
})

Tabs.CREDITS:AddParagraph({
    Title = "YOUTUBE: arcturuszz",
    Content = "Subscribe to my channel"
})