-- yes i stole this from IY but its open source anyway so cry about it lmfao

-- up: E
-- down: Q

-- toggle platform = G

IYMouse = game.Players.LocalPlayer:GetMouse()
local function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart')
    return rootPart
end

local floatActive = false
local function platform(speaker)
	local pchar = speaker.Character
	if pchar and not pchar:FindFirstChild("floatName") then
		task.spawn(function()
			local Float = Instance.new('Part')
			Float.Name = "floatName"
			Float.Parent = pchar
			Float.Transparency = 0.8
			Float.Size = Vector3.new(2,0.2,1.5)
			Float.Anchored = true
			local FloatValue = -3.097
			Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
			qUp = IYMouse.KeyUp:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue + 0.5
				end
			end)
			eUp = IYMouse.KeyUp:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue - 0.5
				end
			end)
			qDown = IYMouse.KeyDown:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue - 0.5
				end
			end)
			eDown = IYMouse.KeyDown:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue + 0.5
				end
			end)
			floatDied = speaker.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				FloatingFunc:Disconnect()
				Float:Destroy()
				qUp:Disconnect()
				eUp:Disconnect()
				qDown:Disconnect()
				eDown:Disconnect()
				floatDied:Disconnect()
			end)
			local function FloatPadLoop()
				if pchar:FindFirstChild("floatName") and getRoot(pchar) and floatActive then
					Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
				else
					FloatingFunc:Disconnect()
					Float:Destroy()
					qUp:Disconnect()
					eUp:Disconnect()
					qDown:Disconnect()
					eDown:Disconnect()
					floatDied:Disconnect()
				end
			end			
			FloatingFunc = game:GetService("RunService").Heartbeat:Connect(FloatPadLoop)
		end)
	end
end

platform(game.Players.LocalPlayer)
warn("loaded")

IYMouse.KeyDown:Connect(function(KEY)
	if KEY == 'g' then
		floatActive = not floatActive
	end
end)
