local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== DEEP REMOTE TRACKER ===")

local hooked = {}
local isTracking = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeepTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 550, 0, 650)
frame.Position = UDim2.new(0.5, -275, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.BackgroundTransparency = 0.3
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🔍 DEEP REMOTE TRACKER"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "Instructions"
instructionLabel.Size = UDim2.new(0.95, 0, 0, 80)
instructionLabel.Position = UDim2.new(0.025, 0, 0, 45)
instructionLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
instructionLabel.BackgroundTransparency = 0.2
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.TextSize = 10
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextWrapped = true
instructionLabel.Text = "📍 INSTRUCTIONS:\n1. Click 'START TRACKING'\n2. Manually send a trade in-game\n3. Watch the log for remote calls\n4. Screenshot and share the log"
instructionLabel.BorderSizePixel = 0
instructionLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Name = "StartBtn"
startBtn.Size = UDim2.new(0.45, 0, 0, 35)
startBtn.Position = UDim2.new(0.05, 0, 0, 130)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
startBtn.BackgroundTransparency = 0.3
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 13
startBtn.Font = Enum.Font.GothamBold
startBtn.Text = "▶ START"
startBtn.BorderSizePixel = 0
startBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearBtn"
clearBtn.Size = UDim2.new(0.45, 0, 0, 35)
clearBtn.Position = UDim2.new(0.5, 0, 0, 130)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
clearBtn.BackgroundTransparency = 0.3
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 13
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "🗑 CLEAR"
clearBtn.BorderSizePixel = 0
clearBtn.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.95, 0, 0, 20)
statusLabel.Position = UDim2.new(0.025, 0, 0, 170)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.5
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "Status: Ready"
statusLabel.BorderSizePixel = 0
statusLabel.Parent = frame

local logBox = Instance.new("TextBox")
logBox.Name = "Log"
logBox.Size = UDim2.new(0.95, 0, 0, 450)
logBox.Position = UDim2.new(0.025, 0, 0, 195)
logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logBox.BackgroundTransparency = 0.2
logBox.TextColor3 = Color3.fromRGB(100, 255, 100)
logBox.TextSize = 8
logBox.Font = Enum.Font.GothamMonospace
logBox.TextWrapped = true
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.ReadOnly = true
logBox.Text = "Waiting for START...\n"
logBox.BorderSizePixel = 0
logBox.Parent = frame

-- Add log function
local function addLog(message)
    logBox.Text = logBox.Text .. message .. "\n"
    print(message)
end

-- Deep hook function
local function deepHook(obj)
    if hooked[obj] then return end
    hooked[obj] = true
    
    if obj:IsA("RemoteEvent") then
        local oldFire = obj.FireServer
        obj.FireServer = function(self, ...)
            if isTracking then
                local remoteName = obj:GetFullName()
                local argCount = select('#', ...)
                addLog("")
                addLog("🔴 REMOTE EVENT: " .. remoteName)
                addLog("   Args: " .. argCount)
                
                for i = 1, argCount do
                    local arg = select(i, ...)
                    local argType = typeof(arg)
                    local argValue = tostring(arg)
                    
                    if argType == "Instance" then
                        argValue = arg.ClassName .. " (" .. arg.Name .. ")"
                    elseif argType == "table" then
                        argValue = "table with " .. #arg .. " items"
                    end
                    
                    addLog("   Arg" .. i .. " [" .. argType .. "]: " .. argValue)
                end
            end
            return oldFire(self, ...)
        end
    elseif obj:IsA("RemoteFunction") then
        local oldInvoke = obj.InvokeServer
        obj.InvokeServer = function(self, ...)
            if isTracking then
                local remoteName = obj:GetFullName()
                local argCount = select('#', ...)
                addLog("")
                addLog("🔵 REMOTE FUNCTION: " .. remoteName)
                addLog("   Args: " .. argCount)
                
                for i = 1, argCount do
                    local arg = select(i, ...)
                    local argType = typeof(arg)
                    local argValue = tostring(arg)
                    
                    if argType == "Instance" then
                        argValue = arg.ClassName .. " (" .. arg.Name .. ")"
                    elseif argType == "table" then
                        argValue = "table with " .. #arg .. " items"
                    end
                    
                    addLog("   Arg" .. i .. " [" .. argType .. "]: " .. argValue)
                end
            end
            return oldInvoke(self, ...)
        end
    end
end

-- Scan and hook function
local function scanAndHook()
    local count = 0
    
    -- Hook all existing remotes
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            deepHook(obj)
            count = count + 1
        end
    end
    
    -- Monitor for new remotes
    ReplicatedStorage.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            deepHook(obj)
            if isTracking then
                addLog("")
                addLog("🆕 NEW REMOTE FOUND: " .. obj:GetFullName())
            end
        end
    end)
    
    return count
end

-- Start button
startBtn.MouseButton1Click:Connect(function()
    isTracking = true
    logBox.Text = "🟢 TRACKING ACTIVE!\n"
    statusLabel.Text = "Status: ✅ TRACKING"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    startBtn.Text = "⏹ ACTIVE"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    
    addLog("=" .. string.rep("=", 50) .. "=")
    addLog("🟢 TRACKING STARTED")
    addLog("=" .. string.rep("=", 50) .. "=")
    addLog("")
    addLog("📍 NOW: Manually send a trade in-game...")
    addLog("Watch below for remote calls!")
end)

-- Clear button
clearBtn.MouseButton1Click:Connect(function()
    logBox.Text = "Log cleared.\n"
    addLog("Ready for new tracking session...")
end)

-- Initial scan
task.wait(1)
local remoteCount = scanAndHook()
addLog("✅ Scanned and hooked " .. remoteCount .. " remotes")
addLog("Click START to begin tracking")

print("✅ Deep Remote Tracker loaded!")
print("Total remotes hooked: " .. remoteCount)
