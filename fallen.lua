local localplayer = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local players = game.Players
local runservice = game:GetService("RunService")
local enabled = true
local function box_esp(plr,cr)
    local box = Drawing.new("Square")
    
   
    local humanoidrootpart = cr:WaitForChild("HumanoidRootPart")
    local head = cr:WaitForChild("Head")
    local humanoid = cr:WaitForChild("Humanoid")

    local connection
    local connection2
    local connection3

    local function disconnect()
        box.Visible = false
        box:Remove()
        if connection then
            connection:Disconnect()
            connection = nil
        end
        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end
        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end
    end

    connection2 = cr.AncestryChanged:Connect(function (_,parent)
        if not parent then
            disconnect()
        end
    end)

    connection3 = humanoid.HealthChanged:Connect(function (health)
        if health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
            
        end
    end)

    connection = runservice.RenderStepped:Connect(function ()
        box.Color = Color3.fromRGB(255,255,255)
        box.Thickness = 1.5
        local humanoidrootpart_pos, onscreen = camera:WorldToViewportPoint(humanoidrootpart.Position)
        local head_pos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
        local leg_pos = camera:WorldToViewportPoint(humanoidrootpart.Position + Vector3.new(0,-3,0))
        if onscreen and enabled then
            box.Size = Vector2.new(1800/humanoidrootpart_pos.Z,head_pos.Y - leg_pos.Y)
            box.Position = Vector2.new(humanoidrootpart_pos.X - box.Size.X / 2, humanoidrootpart_pos.Y - box.Size.Y / 2)
            box.Visible = true
        else
            box.Visible = false
        end
    end)
end


local function player_added(player)
    if player.Character then
         box_esp(player, player.Character)
    end
    player.CharacterAdded:Connect(function (character)
        box_esp(player,character)
    end)
end

for i,v in pairs(players:GetChildren()) do
    if v ~= localplayer then
        player_added(v)
    end
end
