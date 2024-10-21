tweenService = game:GetService("TweenService")

local pos1 = Vector3.new(-57.53654861450195, 34.05609130859375, -225.95188903808594)
local pos2 = Vector3.new(-164.93063354492188, 51.40309524536133, 1275.562744140625)
local pos3 = Vector3.new(-130.416259765625, 51.94549560546875, 8228.53515625)
local pos4 = Vector3.new(-51.67303466796875, 17.631446838378906, 8680.4306640625)
local finish = Vector3.new(-55.36488342285156, -360.0461730957031, 9488.30859375)

-- 30


Version = "0.0.1"

warn("----------------------------------------------------|")
warn("Loading Build A Cheat For Treasure V" .. Version .. "!")
warn("----------------------------------------------------|")

--! Debugger

local DEBUG = false

if DEBUG then
    getfenv().getfenv = function()
        return setmetatable({}, {
            __index = function()
                return function()
                    return true
                end
            end
        })
    end
end


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
    Transparency = true,
    MinimizeKey = "RightShift",
    ShowNotifications = true,
    ShowWarnings = true,
    RenderingMode = "RenderStepped",
    AutoImport = true
}

local InterfaceManager = {}

function InterfaceManager:ImportSettings()
    pcall(function()
        if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.JSON") and getfenv().readfile("UISettings.F_INT") then
            for Key, Value in next, HttpService:JSONDecode(getfenv().readfile("UISettings.JSON")) do
                UISettings[Key] = Value
            end
        end
    end)
end

function InterfaceManager:ExportSettings()
    pcall(function()
        if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().writefile then
            getfenv().writefile("UISettings.JSON", HttpService:JSONEncode(UISettings))
        end
    end)
end

InterfaceManager:ImportSettings()

UISettings.__LAST_RUN__ = os.date()
InterfaceManager:ExportSettings()

warn("Saved UISettings Loaded!")

local Player = Players.LocalPlayer

local IsComputer = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled

warn("Constants loaded!")

--! Fields

local Fluent = nil
local ShowWarning = false

local Clock = os.clock()

local Aiming = false
local Tween = nil
local MouseSensitivity = UserInputService.MouseDeltaSensitivity

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
        Title = "Build A Cheat For Treasure",
        SubTitle = "[PRIVATE RELEASE V" .. Version .. "]",
        TabWidth = UISettings.TabWidth,
        Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
        Theme = UISettings.Theme,
        Acrylic = UISettings.Acrylic,
        MinimizeKey = UISettings.MinimizeKey
    })

    local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "coins" }) }

    Window:SelectTab(1)

    local GrinderSection = Tabs.Main:AddSection("Grinder")

    local AimbotToggle = GrinderSection:AddToggle("Grinder", { Title = "Grinder", Description = "Toggles the Grinder", Default = Configuration.Grinder })
    AimbotToggle:OnChanged(function(Value)

    
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

    Tabs.Credits = Window:AddTab({ Title = "Credits", Icon = "book" })

    Tabs.Credits:AddParagraph({
        Title = "Credits",
        Content = "|--------------------------------|\n|Coding: S_B\n|--------------------------------|\n|Testing: S_B\n|--------------------------------|\n|Design: S_B|\n|--------------------------------|\n|Module Design: S_B|\n|--------------------------------|\n|Fluent UI Library: Dawid\n|--------------------------------|",
    })

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
    
    if UISettings.ShowWarnings then
    if ShowWarning then
        Window:Dialog({
            Title = "Note",
            Content = "This script is very ultra pre-historic-pre-alpha 0.0.0.1, also its made by S_B, shameless plug: Use Future Internals aimbot its soo good frfrfrfr https://Future-Internals.xyz 🔥🔥",
            Buttons = {
                { Title = "ight" }
            }
        })
    end
end

warn("UI loaded!")

--! Notifications Handler

local function Notify(Message)
    if Fluent and typeof(Message) == "string" then
        Fluent:Notify({
            Title = "Build A Cheat For Treasure",
            Content = Message,
            SubContent = "By S_B",
            Duration = 2.5
        })
    end
end

Notify("Notification System loaded!")

warn("Notification System loaded!")

--! Fields Handler

local FieldsHandler = {}

--! Input Handler

warn("Input Handler loaded!")

local OnTeleport; OnTeleport = Player.OnTeleport:Connect(function()
    if DEBUG or not Fluent or not getfenv().queue_on_teleport then
        OnTeleport:Disconnect()
    else
        getfenv().queue_on_teleport("getfenv().loadstring(game:HttpGet(\"https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/FutureInternals.lua\", true))()")
        OnTeleport:Disconnect()
    end
end)

warn("Player Events Handler loaded!")

while Grinder == true do
    tweenServie = game:GetService("TweenService")

    local one = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local two = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local three = TweenInfo.new(50, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local four = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local finishh = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local oneone = tweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, one, {Position = pos1})

    local twotwo = tweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, two, {Position = pos2})

    local threethree = tweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, three, {Position = pos3})

    local fourfour = tweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, four, {Position = pos4})

    local finishfinish = tweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, finishh, {Position = finish})

    oneone:Play()
    task.wait(3.5)
    twotwo:Play()
    task.wait(3.5)
    threethree:Play()
    task.wait(50.5)
    fourfour:Play()
    task.wait(2.5)
    finishfinish:Play()
    task.wait(23.5)
end

warn("Grinder Handler loaded!")
wait(1)
warn("----------------------------------------------------|")
warn("Loaded Build A Cheat For Treasure V" .. Version .. "!")
warn("----------------------------------------------------|")
end
