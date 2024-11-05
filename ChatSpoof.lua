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
            Title = "Chat Spoofer",
            Content = Message,
            SubContent = SubMessage,
            Duration = 5
        })
    end
end

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local SubmitButton

local UI =
    Material.Load(
        {
            Title = "Chat Spoofer",
            Style = 2,
            SizeX = 400,
            SizeY = 220,
            Theme = "Dark"
        }
    )

local Page =
    UI.New(
        {
            Title = "Main"
        }
    )

-- aardappel

local OwnMessage =
    Page.TextField(
        {
            Text = "Own message",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "You will send this message as yourself (required for the method). Use something meaningful to avoid suspicion."
                        }
                    )
                end
            }
        }
    )

local SpoofName =
    Page.TextField(
        {
            Text = "Name to spoof",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "The name between the brackets, like \"[*name here*]:\"."
                        }
                    )
                end
            }
        }
    )

local SpoofMessage =
    Page.TextField(
        {
            Text = "Spoof message",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "The spoofed message."
                        }
                    )
                end
            }
        }
    )

SubmitButton =
    Page.Button(
        {
            Text = "Send (0/39)",
            Callback = function()
                if CheckCount() > 39 then
                    UI.Banner({
                        Text = "This method only allows up to 39 characters. Try using a shorter message or victim name."
                    })
                else
                    message =
                        "" ..
                        tostring(OwnMessage:GetText()) ..
                        "                                                                                                                                                             [" ..
                        tostring(SpoofName:GetText()) .. "]: " .. tostring(SpoofMessage:GetText())
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                    Notify("Spoofed Message Send!", " ")
                end
            end
        }
    )

function CheckCount()
    local TotalChars = #OwnMessage:GetText() + #SpoofName:GetText() + #SpoofMessage:GetText()
    return TotalChars
end
