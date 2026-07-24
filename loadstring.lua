local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== REMOTE CALL TRACKER ===")

local hooked = {}
local callLog = {}

-- Create GUI for logs
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 500, 0, 600)
frame.Position = UDim2.new(0.5, -250, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.BackgroundTransparency = 0.3
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🔍 REMOTE CALL TRACKER"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "Instructions"
instructionLabel.Size = UDim2.new(0.95, 0, 0, 60)
instructionLabel.Position = UDim2.new(0.025, 0, 0, 40)
instructionLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
instructionLabel.BackgroundTransparency = 0.2
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.TextSize = 11
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextWrapped = true
instructionLabel.Text = "INSTRUCTIONS:\n1. Click 'START TRACKING'\n2. Manually send a trade in-game\n3. Watch the log below to see all remote calls"
instructionLabel.BorderSizePixel = 0
instructionLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Name = "StartBtn"
startBtn.Size = UDim2.new(0.9, 0, 0, 35)
startBtn.Position = UDim2.new(0.05, 0, 0, 105)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
startBtn.BackgroundTransparency = 0.3
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 14
startBtn.Font = Enum.Font.GothamBold
startBtn.Text = "▶ START TRACKING"
startBtn.BorderSizePixel = 0
startBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearBtn"
clearBtn.Size = UDim2.new(0.9, 0, 0, 35)
clearBtn.Position = UDim2.new(0.05, 0, 0, 145)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
clearBtn.BackgroundTransparency = 0.3
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "🗑 CLEAR LOG"
clearBtn.BorderSizePixel = 0
clearBtn.Parent = frame

local logBox = Instance.new("TextBox")
logBox.Name = "Log"
logBox.Size = UDim2.new(0.95, 0, 0, 400)
logBox.Position = UDim2.new(0.025, 0, 0, 190)
logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logBox.BackgroundTransparency = 0.2
logBox.TextColor3 = Color3.fromRGB(100, 255, 100)
logBox.TextSize = 9
logBox.Font = Enum.Font.GothamMonospace
logBox.TextWrapped = true
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.ReadOnly = true
logBox.Text = "Waiting for START TRACKING...\n"
logBox.BorderSizePixel = 0
logBox.Parent = frame

-- Add log function
local function addLog(message)
    logBox.Text = logBox.Text .. message .. "\n"
    print(message)
    -- Auto-scroll to bottom
    logBox.CursorPosition = #logBox.Text
end

-- Start tracking button
startBtn.MouseButton1Click:Connect(function()
    logBox.Text = "🟢 TRACKING ACTIVE - Perform a trade now!\n"
    callLog = {}
    hooked = {}
    
    addLog("=" .. string.rep("=", 48) .. "=")
    addLog("Starting to hook all RemoteEvents and RemoteFunctions...")
    addLog("=" .. string.rep("=", 48) .. "=")
    
    local hookCount = 0
    
    -- Hook ALL remotes in ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            if not hooked[obj] then
                hooked[obj] = true
                hookCount = hookCount + 1
                
                local remoteName = obj:GetFullName()
                local oldFire = obj.FireServer
                
                obj.FireServer = function(self, ...)
                    local args = {...}
                    local argStr = ""
                    
                    for i, arg in ipairs(args) do
                        local argType = typeof(arg)
                        local argValue = "?"
                        
                        if argType == "Instance" then
                            argValue = arg.ClassName .. ": " .. arg.Name
                        elseif argType == "string" then
                            argValue = '"' .. tostring(arg) .. '"'
                        elseif argType == "number" then
                            argValue = tostring(arg)
                        elseif argType == "boolean" then
                            argValue = tostring(arg)
                        elseif argType == "table" then
                            argValue = "table{" .. #arg .. "}"
                        else
                            argValue = argType
                        end
                        
                        argStr = argStr .. "\n    Arg" .. i .. " (" .. argType .. "): " .. argValue
                    end
                    
                    addLog("")
                    addLog("🔴 REMOTE EVENT FIRED!")
                    addLog("   Name: " .. remoteName)
                    addLog("   Args: " .. (#args) .. argStr)
                    
                    return oldFire(self, ...)
                end
            end
        elseif obj:IsA("RemoteFunction") then
            if not hooked[obj] then
                hooked[obj] = true
                hookCount = hookCount + 1
                
                local remoteName = obj:GetFullName()
                local oldInvoke = obj.InvokeServer
                
                obj.InvokeServer = function(self, ...)
                    local args = {...}
                    local argStr = ""
                    
                    for i, arg in ipairs(args) do
                        local argType = typeof(arg)
                        local argValue = "?"
                        
                        if argType == "Instance" then
                            argValue = arg.ClassName .. ": " .. arg.Name
                        elseif argType == "string" then
                            argValue = '"' .. tostring(arg) .. '"'
                        elseif argType == "number" then
                            argValue = tostring(arg)
                        elseif argType == "boolean" then
                            argValue = tostring(arg)
                        elseif argType == "table" then
                            argValue = "table{" .. #arg .. "}"
                        else
                            argValue = argType
                        end
                        
                        argStr = argStr .. "\n    Arg" .. i .. " (" .. argType .. "): " .. argValue
                    end
                    
                    addLog("")
                    addLog("🔵 REMOTE FUNCTION INVOKED!")
                    addLog("   Name: " .. remoteName)
                    addLog("   Args: " .. (#args) .. argStr)
                    
                    return oldInvoke(self, ...)
                end
            end
        end
    end
    
    addLog("=" .. string.rep("=", 48) .. "=")
    addLog("✅ Hooked " .. hookCount .. " remotes")
    addLog("=" .. string.rep("=", 48) .. "=")
    addLog("")
    addLog("📍 NOW: Manually send a trade in-game and watch for calls...")
    
    startBtn.Text = "✅ TRACKING ACTIVE"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
end)

-- Clear log button
clearBtn.MouseButton1Click:Connect(function()
    logBox.Text = "Log cleared. Click START TRACKING to begin.\n"
    callLog = {}
end)

print("✅ Remote Tracker GUI loaded!")
print("Click 'START TRACKING' button to begin")
