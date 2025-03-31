-- Get the player's mouse
local a = game.Players.LocalPlayer:GetMouse()

-- Listen for the "r" key press
a.KeyDown:Connect(function(b)
    if b == "r" then
        -- Loop through all players in the game
        for c, d in ipairs(game.Players:GetChildren()) do
            if d ~= game.Players.LocalPlayer then
                -- Prepare the arguments to fire the server event
                local e = {
                    [1] = "Damage",                             -- Action type
                    [2] = "Lunge",                        -- Attack type
                    [3] = "Damage",                            -- Repeated action type
                    [4] = "Punch",                             -- Secondary attack type
                    [5] = d.Character.Humanoid,               -- Target's Humanoid
                    [6] = CFrame.new(                         -- Position and orientation
                        Vector3.new(1598.6829833984375, 573.8587036132812, -650.6309814453125), 
                        Vector3.new(-0.27500227093696594, 0.7757357954978943, -0.5679856538772583)
                    )
                }
                -- Fire the server event with the prepared arguments
                game:GetService("ReplicatedStorage").Main.Input:FireServer(unpack(e))
            end
        end
    end
end)

-- Listen for the "r" key press
a.KeyDown:Connect(function(b)
    if b == "f" then
        -- Loop through all players in the game
        for c, d in ipairs(game.Players:GetChildren()) do
            if d ~= game.Players.LocalPlayer then
                -- Prepare the arguments to fire the server event
                local e = {
                    [1] = "Damage",                             -- Action type
                    [2] = "Rend",                        -- Attack type
                    [3] = "Damage",                            -- Repeated action type
                    [4] = "Punch",                             -- Secondary attack type
                    [5] = d.Character.Humanoid,               -- Target's Humanoid
                    [6] = CFrame.new(                         -- Position and orientation
                        Vector3.new(1598.6829833984375, 573.8587036132812, -650.6309814453125), 
                        Vector3.new(-0.27500227093696594, 0.7757357954978943, -0.5679856538772583)
                    )
                }
                -- Fire the server event with the prepared arguments
                game:GetService("ReplicatedStorage").Main.Input:FireServer(unpack(e))
            end
        end
    end
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse() -- Get the player's mouse

-- Listen for the left mouse button click
mouse.Button1Down:Connect(function()
    -- Loop through all players in the game
    for _, targetPlayer in ipairs(game.Players:GetChildren()) do
        if targetPlayer ~= player then
            -- Prepare the arguments to fire the server event
            local args = {
                [1] = "Damage",                             -- Action type
                [2] = "Swing",                              -- Attack type
                [3] = "Damage",                             -- Repeated action type
                [4] = "Punch",                              -- Secondary attack type
                [5] = targetPlayer.Character.Humanoid      -- Target's Humanoid
            }
            -- Fire the server event with the prepared arguments
            game:GetService("ReplicatedStorage").Main.Input:FireServer(unpack(args))
        end
    end
end)