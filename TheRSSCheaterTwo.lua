Version = "0.0.4"

warn("----------------------------------------------------|")
warn("Loading The R.S.S. Cheater 2 V" .. Version .. "!")
warn("----------------------------------------------------|")

--! Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--! Interface Manager
local UISettings = {
    TabWidth = 160,
    Size = { 680, 560 },
    Theme = "Darker",
    Acrylic = false,
    Transparency = false,
    MinimizeKey = "RightShift",
    ShowWarnings = true,
    RenderingMode = "RenderStepped",
    AutoImport = true
}

local InterfaceManager = {}

function InterfaceManager:ImportSettings()
    pcall(function()
        if getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.F_INT") and getfenv().readfile("UISettings.F_INT") then
            for Key, Value in next, HttpService:JSONDecode(getfenv().readfile("UISettings.F_INT")) do
                UISettings[Key] = Value
            end
        end
    end)
end

function InterfaceManager:ExportSettings()
    pcall(function()
        if getfenv().isfile and getfenv().readfile and getfenv().writefile then
            getfenv().writefile("UISettings.F_LOADER", HttpService:JSONEncode(UISettings))
        end
    end)
end

InterfaceManager:ImportSettings()

UISettings.__LAST_RUN__ = os.date()
InterfaceManager:ExportSettings()

--! Constants
local Player = Players.LocalPlayer
local IsComputer = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled

warn("Constants loaded!")

local Fluent = nil

do
    if typeof(script) == "Instance" and script:FindFirstChild("Fluent") and script:FindFirstChild("Fluent"):IsA("ModuleScript") then
        Fluent = require(script:FindFirstChild("Fluent"))
    else
        local Success, Result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/Fluent.txt", true)
        end)
        if Success and typeof(Result) == "string" then
            Fluent = loadstring(Result)()
        else
            return
        end
    end
end

warn("Fluent UI Library loaded!")

do
    local Window = Fluent:CreateWindow({
        Title = "The R.S.S. Cheater",
        SubTitle = "[PRIVATE RELEASE V" .. Version .. "]",
        TabWidth = UISettings.TabWidth,
        Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
        Theme = UISettings.Theme,
        Acrylic = UISettings.Acrylic,
        MinimizeKey = UISettings.MinimizeKey
    })

    local Tabs = { PhaserMods = Window:AddTab({ Title = "Phaser", Icon = "crosshair" }) }

    Window:SelectTab(1)

    local Phaser = Tabs.PhaserMods:AddSection("Phaser Aura")

    local PhaserAura = false
    local setup = false
    local PhaserRadius = 25
    local Visualize = false

    local function isPartInRadius(targetPart)
        local localHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

        if targetPart and localHRP then
            local distance = (targetPart.Position - localHRP.Position).magnitude
            return distance <= PhaserRadius
        end
        return false
    end

    local function onPhaserAuraToggle(value)
        PhaserAura = value
        if PhaserAura then
            while PhaserAura do
                game["Run Service"].Heartbeat:Wait()
                for _, target in ipairs(workspace:GetChildren()) do
                    if target:IsA("Model") and target:FindFirstChild("HRP") then
                        local targetHRP = target.HRP
                        if isPartInRadius(targetHRP) then
                            if Player.Character:FindFirstChild("Phaser") then
                                local remote = Player.Character.Phaser.Shoot
                                remote:FireServer(targetHRP.CFrame)
                            end
                        end
                    end
                end
            end
        end
    end
	
    --[[local function isPlayerInRadius(targetPlayer)
        local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

        if targetHRP and localHRP then
            local distance = (targetHRP.Position - localHRP.Position).magnitude
            return distance <= PhaserRadius
        end
        return false
    end

    local function onPhaserAuraToggle(value)
        PhaserAura = value
        if PhaserAura then
            while PhaserAura == true do
                game["Run Service"].Heartbeat:Wait()
                for _, targetPlayer in ipairs(Players:GetPlayers()) do
                    if targetPlayer ~= Player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if isPlayerInRadius(targetPlayer) then
                            if Player.Character:FindFirstChild("Phaser") then
                                local remote = Player.Character.Phaser.Shoot
                                remote:FireServer(targetPlayer.Character.HumanoidRootPart.CFrame)
                            end
                        end
                    end
                end
            end
        end
    end]]


    Phaser:AddToggle("PhaserAuraa", {
	Title = "Phaser Aura",
	Description = "Toggles Phaser Aura.",
	Default = false,
	OnChanged = function(Value)
	    onPhaserAuraToggle(Value)
	end
    })

    Phaser:AddSlider("Radius", {
        Title = "Phaser Aura Radius",
        Description = "Sets the trigger radius of Phaser Aura.",
        Default = 25,
        Min = 10,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            PhaserRadius = Value
        end
    })

    Phaser:AddToggle("VisualizeRadius", {
        Title = "Visualize Radius",
        Description = "Whether or not the sphere radius is visible.",
        Default = false,
        OnChanged = function(Value)
            Visualize = Value
        end
    })

    Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

    local UISection = Tabs.Settings:AddSection("UI")

    UISection:AddDropdown("Theme", {
        Title = "Theme",
        Description = "Changes the UI Theme",
        Values = Fluent.Themes,
        Default = Fluent.Theme,
        Callback = function(Value)
            Fluent:SetTheme(Value)
            UISettings.Theme = Value
            InterfaceManager:ExportSettings()
        end
    })

    if Fluent.UseAcrylic then
        UISection:AddToggle("Acrylic", {
            Title = "Acrylic",
            Description = "Blurred Background requires Graphic Quality >= 8",
            Default = Fluent.Acrylic,
            Callback = function(Value)
                if not Value or not UISettings.ShowWarnings then
                    Fluent:ToggleAcrylic(Value)
                elseif UISettings.ShowWarnings then
                    Window:Dialog({
                        Title = "Warning",
                        Content = "This Option can be detected! Activate it anyway?",
                        Buttons = {
                            {
                                Title = "Confirm",
                                Callback = function()
                                    Fluent:ToggleAcrylic(Value)
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    Fluent.Options.Acrylic:SetValue(false)
                                end
                            }
                        }
                    })
                end
            end
        })
    end

    UISection:AddToggle("Transparency", {
        Title = "Transparency",
        Description = "Makes the UI Transparent",
        Default = UISettings.Transparency,
        Callback = function(Value)
            Fluent:ToggleTransparency(Value)
            UISettings.Transparency = Value
            InterfaceManager:ExportSettings()
        end
    })

    if IsComputer then
        UISection:AddKeybind("MinimizeKey", {
            Title = "Minimize Key",
            Description = "Changes the Minimize Key",
            Default = Fluent.MinimizeKey,
            ChangedCallback = function(Value)
                UISettings.MinimizeKey = pcall(UserInputService.GetStringForKeyCode, UserInputService, Value) and UserInputService:GetStringForKeyCode(Value) or "RMB"
                InterfaceManager:ExportSettings()
            end
        })
        Fluent.MinimizeKeybind = Fluent.Options.MinimizeKey
    end

    Tabs.Contact = Window:AddTab({ Title = "Contact Me", Icon = "user"})

    Tabs.Contact:AddParagraph({
        Title = "Contact Me!",
        Content = "Report bugs, give me suggestions, or just talk to me!"
    })

    Tabs.Contact:AddButton({
        Title = "Contact me on Discord!",
        Description = "Click to copy the Discord invite to your clipboard!",
        Callback = function()
            setclipboard("https://discord.gg/MBMehqKKCv")
        end
    })
end
warn("----------------------------------------------------|")
warn("Loaded The R.S.S. Cheater 2 V" .. Version .. "!")
warn("----------------------------------------------------|")



--[[
Version = "0.0.1"

warn("----------------------------------------------------|")
warn("Loading The R.S.S. Cheater 2 V" .. Version .. "!")
warn("----------------------------------------------------|")

--! Services

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")


--! Interface Manager

local UISettings = {
    TabWidth = 160,
    Size = { 680, 560 },
    Theme = "Darker",
    Acrylic = false,
    Transparency = false,
    MinimizeKey = "RightShift",
    ShowWarnings = true,
    RenderingMode = "RenderStepped",
    AutoImport = true
}

local InterfaceManager = {}

function InterfaceManager:ImportSettings()
    pcall(function()
        if getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.F_INT") and getfenv().readfile("UISettings.F_INT") then
            for Key, Value in next, HttpService:JSONDecode(getfenv().readfile("UISettings.F_INT")) do
                UISettings[Key] = Value
            end
        end
    end)
end

function InterfaceManager:ExportSettings()
    pcall(function()
        if getfenv().isfile and getfenv().readfile and getfenv().writefile then
            getfenv().writefile("UISettings.F_LOADER", HttpService:JSONEncode(UISettings))
        end
    end)
end

InterfaceManager:ImportSettings()

UISettings.__LAST_RUN__ = os.date()
InterfaceManager:ExportSettings()

--! Constants

local Player = Players.LocalPlayer

local IsComputer = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled

warn("Constants loaded!")

local Fluent = nil

do
    if typeof(script) == "Instance" and script:FindFirstChild("Fluent") and script:FindFirstChild("Fluent"):IsA("ModuleScript") then
        Fluent = require(script:FindFirstChild("Fluent"))
    else
        local Success, Result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/Fluent.txt", true)
        end)
        if Success and typeof(Result) == "string" then
            Fluent = loadstring(Result)()
        else
            return
        end
    end
end

warn("Fluent UI Library loaded!")

do
    local Window = Fluent:CreateWindow({
        Title = "The R.S.S. Cheater",
        SubTitle = "[PRIVATE RELEASE V" .. Version .. "]",
        TabWidth = UISettings.TabWidth,
        Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
        Theme = UISettings.Theme,
        Acrylic = UISettings.Acrylic,
        MinimizeKey = UISettings.MinimizeKey
    })

    local Tabs = { PhaserMods = Window:AddTab({ Title = "Phaser Mods", Icon = "crosshair" }) }

    Window:SelectTab(1)

    Phaser = Tabs.PhaserMods:AddSection("Phaser Aura")

    local trigger = 
    
    local PhaserAura = false
    local setup = false
    local PhaserRadius = 25
    local Visualize = false
    local Modded = false

    game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
	    Modded = false
        setup = false
    end)

    Phaser:AddToggle("PhaserAura", { Title = "Phaser Aura", Description = "Toggles Phaser Aura.", Default = false })
    PhaserAura:OnChanged(function(Value)
        if setup = false then
            local sphere = Instance.new("Part")
            sphere.Shape = 0
            sphere.Size = Vector3.new(PhaserRadius,PhaserRadius,PhaserRadius)
            sphere.CanCollide = false
            sphere.CanQuery = false
            sphere.CanTouch = false
            sphere.Anchored = true
            if Visualize == true then
                sphere.Transparency = 0.7
            else
                sphere.Transparency = 1
            end
            sphere.BrickColor = BrickColor.new("Bright red")
            sphere.Locked = true
            sphere.Parent = game.Players.LocalPlayer.Character
            local wc = Instance.new("WeldConstraint")
            wc.Part1 = sphere
            wc.Part0 = game.Players.LocalPlayer.Character.HumanoidRootPart
            sphere.Name = "PhaserAura"
            while true do
                
            end
        else
            
        end
    end)

    Phaser:AddSlider("Radius", {
        Title = "Phaser Aura Radius",
        Description = "Sets the trigger radius of Phaser Aura.",
        Default = 25,
        Min = 10,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            PhaserRadius = Value
        end
    })

    Phaser:AddToggle("VisualizeRadius", {
        Title = "Visualize Radius",
        Description = "Whether or not the sphere radius is visible.",
        Default = false,
        VisualizeRadius.OnChanged(function(Value)
            Visualize = true
        end)
    })
    
    Phaser:AddButton({
        Title = "",
        Description = "",
        Callback = function(Value)
            
        end
    })
    
    Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

    local UISection = Tabs.Settings:AddSection("UI")

    UISection:AddDropdown("Theme", {
        Title = "Theme",
        Description = "Changes the UI Theme",
        Values = Fluent.Themes,
        Default = Fluent.Theme,
        Callback = function(Value)
            Fluent:SetTheme(Value)
            UISettings.Theme = Value
            InterfaceManager:ExportSettings()
        end
    })

    if Fluent.UseAcrylic then
        UISection:AddToggle("Acrylic", {
            Title = "Acrylic",
            Description = "Blurred Background requires Graphic Quality >= 8",
            Default = Fluent.Acrylic,
            Callback = function(Value)
                if not Value or not UISettings.ShowWarnings then
                    Fluent:ToggleAcrylic(Value)
                elseif UISettings.ShowWarnings then
                    Window:Dialog({
                        Title = "Warning",
                        Content = "This Option can be detected! Activate it anyway?",
                        Buttons = {
                            {
                                Title = "Confirm",
                                Callback = function()
                                    Fluent:ToggleAcrylic(Value)
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    Fluent.Options.Acrylic:SetValue(false)
                                end
                            }
                        }
                    })
                end
            end
        })
    end

    UISection:AddToggle("Transparency", {
        Title = "Transparency",
        Description = "Makes the UI Transparent",
        Default = UISettings.Transparency,
        Callback = function(Value)
            Fluent:ToggleTransparency(Value)
            UISettings.Transparency = Value
            InterfaceManager:ExportSettings()
        end
    })

    if IsComputer then
        UISection:AddKeybind("MinimizeKey", {
            Title = "Minimize Key",
            Description = "Changes the Minimize Key",
            Default = Fluent.MinimizeKey,
            ChangedCallback = function(Value)
                UISettings.MinimizeKey = pcall(UserInputService.GetStringForKeyCode, UserInputService, Value) and UserInputService:GetStringForKeyCode(Value) or "RMB"
                InterfaceManager:ExportSettings()
            end
        })
        Fluent.MinimizeKeybind = Fluent.Options.MinimizeKey
    end

    Tabs.Contact = Window:AddTab({ Title = "Contact Me", Icon = "user"})

    Tabs.Contact:AddParagraph({
        Title = "Contact Me!",
        Content = "Report bugs, give me suggestions, or just talk to me!"
    })

    Tabs.Contact:AddButton({
        Title = "Contact me on Discord!",
        Description = "Click to copy the Discord invite to your clipboard!",
        Callback = function()
            setclipboard("https://discord.gg/MBMehqKKCv")
        end
    })
end
warn("----------------------------------------------------|")
warn("Loaded The R.S.S. Cheater 2 V" .. Version .. "!")
warn("----------------------------------------------------|")
]]

