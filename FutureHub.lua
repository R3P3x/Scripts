
Version = "0.0.3"

warn("----------------------------------------------------|")
warn("Loading Future Hub V" .. Version .. "!")
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

local function Notify(Message, SubMessage)
    if Fluent and typeof(Message) == "string" and typeof(SubMessage) == "string" then
        Fluent:Notify({
            Title = "Future Hub",
            Content = Message,
            SubContent = SubMessage,
            Duration = 5
        })
    end
end

warn("Fluent UI Library loaded!")

do
    local Window = Fluent:CreateWindow({
        Title = "Future Hub",
        SubTitle = "[PRIVATE RELEASE V" .. Version .. "]",
        TabWidth = UISettings.TabWidth,
        Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
        Theme = UISettings.Theme,
        Acrylic = UISettings.Acrylic,
        MinimizeKey = UISettings.MinimizeKey
    })

    local Tabs = { Scripts = Window:AddTab({ Title = "Scripts", Icon = "list" }) }

    Window:SelectTab(1)

    Universal = Tabs.Scripts:AddSection("Universals")

    Universal:AddButton({
        Title = "Infinite Yield",
        Description = "THE script.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            Notify("Loading Infinite Yield!", "Made by Toon (aka toonarch, EdgeIY)")
        end
    })

    Universal:AddButton({
        Title = "Future Internals",
        Description = "Aimbot, esp, triggerbot, all you need for competetive games!.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/FutureInternals.lua"))()
            Notify("Loading Future Internals!", "Made By Future Hub (aka S_B)")
        end
    })

    Universal:AddButton({
        Title = "Chat Spoofer",
        Description = "Spoofs chat messages.",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/ChatSpoof.lua'))()
            Notify("Loading Chat Spoofer!", "Made by unknown, modded by S_B")
        end
    })

    Universal:AddButton({
        Title = "Invisibility Button",
        Description = "Might be buggy if map is place in a weird location!.",
        Callback = function()
            loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
            Notify("Loading Invisiblity Button!", "Made by unknown")
        end
    })

    Games = Tabs.Scripts:AddSection("Games")

    Games:AddButton({
        Title = "PrisonWare V1.3",
        Description = "Game: Prison Life.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Denverrz/scripts/master/PRISONWARE_v1.3.txt"))()
            Notify("Loading PrisonWare V1.3!", "Made by Zyrex (aka Denverrz)")
        end
    })

    Games:AddButton({
        Title = "The R.S.S. Cheater 2",
        Description = "Game: The R.S.S. Bloxy 2",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/R3P3x/Scripts/refs/heads/main/TheRSSCheaterTwo.lua"))()
            Notify("Loading The R.S.S. Cheater 2!", "Made by Future Hub")
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
    
    Window:Dialog({
        Title = "Loader Hub",
        Content = "This is the Loader Hub, to actually use the scripts please load them and unload this UI (with the X in the top right)",
        Buttons = {
          { Title = "I Understand" }
        }
    })
end
warn("----------------------------------------------------|")
warn("Loaded Future Hub V" .. Version .. "!")
warn("----------------------------------------------------|")
