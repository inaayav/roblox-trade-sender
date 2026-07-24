local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== ENHANCED REMOTE TRACKER ===")

local hooked = {}
local isTracking = false
local capturedCalls = {}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EnhancedTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 600, 0, 700)
frame.Position = UDim2.new(0.5, -300, 0, 5)
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
titleLabel.Text = "🔍 REMOTE TRACKER v2"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "Instructions"
instructionLabel.Size = UDim2.new(0.95, 0, 0, 70)
instructionLabel.Position = UDim2.new(0.025, 0, 0, 45)
instructionLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
instructionLabel.BackgroundTransparency = 0.2
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.TextSize = 10
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextWrapped = true
instructionLabel.Text = "1️⃣ Open trade menu in-game FIRST\n2️⃣ Click SCAN REMOTES\n3️⃣ Then click START TRACKING\n4️⃣ Send the trade and watch logs"
instructionLabel.BorderSizePixel = 0
instructionLabel.Parent = frame

local scanBtn = Instance.new("TextButton")
scanBtn.Name = "ScanBtn"
scanBtn.Size = UDim2.new(0.45, 0, 0, 35)
scanBtn.Position = UDim2.new(0.05, 0, 0, 120)
scanBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
scanBtn.BackgroundTransparency = 0.3
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 12
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "🔎 SCAN"
scanBtn.BorderSizePixel = 0
scanBtn.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Name = "StartBtn"
startBtn.Size = UDim2.new(0.45, 0, 0, 35)
startBtn.Position = UDim2.new(0.5, 0, 0, 120)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
startBtn.BackgroundTransparency = 0.3
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 12
startBtn.Font = Enum.Font.GothamBold
startBtn.Text = "▶ START"
startBtn.BorderSizePixel = 0
startBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearBtn"
clearBtn.Size = UDim2.new(0.9, 0, 0, 30)
clearBtn.Position = UDim2.new(0.05, 0, 0, 160)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
clearBtn.BackgroundTransparency = 0.3
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 11
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "🗑 CLEAR LOG"
clearBtn.BorderSizePixel = 0
clearBtn.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 195)
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
logBox.Size = UDim2.new(0.95, 0, 0, 470)
logBox.Position = UDim2.new(0.025, 0, 0, 225)
logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logBox.BackgroundTransparency = 0.2
logBox.TextColor3 = Color3.fromRGB(100, 255, 100)
logBox.TextSize = 8
logBox.Font = Enum.Font.GothamMonospace
logBox.TextWrapped = true
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.ReadOnly = true
logBox.Text = "Ready. Click SCAN REMOTES first.\n"
logBox.BorderSizePixel = 0
logBox.Parent = frame

-- Add log function
local function addLog(message)
    logBox.Text = logBox.Text .. message .. "\n"
    print(message)
    table.insert(capturedCalls, message)
end

-- Deep hook function
local function hookRemote(obj)
    if hooked[obj] then return end
    hooked[obj] = true
    
    if obj:IsA("RemoteEvent") then
        local oldFire = obj.FireServer
        obj.FireServer = function(self, ...)
            if isTracking then
                local remoteName = obj:GetFullName()
                local argCount = select('#', ...)
                addLog("")
                addLog("🔴 REMOTE EVENT FIRED!")
                addLog("   Path: " .. remoteName)
                addLog("   Arguments: " .. argCount)
                
                for i = 1, argCount do
                    local arg = select(i, ...)
                    local argType = typeof(arg)
                    local argValue = ""
                    
                    if argType == "Instance" then
                        argValue = arg.ClassName .. ": " .. arg.Name
                    elseif argType == "table" then
                        argValue = "table (" .. #arg .. " items)"
                    else
                        argValue = tostring(arg)
                    end
                    
                    addLog("      [" .. i .. "] " .. argType .. " = " .. argValue)
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
                addLog("🔵 REMOTE FUNCTION INVOKED!")
                addLog("   Path: " .. remoteName)
                addLog("   Arguments: " .. argCount)
                
                for i = 1, argCount do
                    local arg = select(i, ...)
                    local argType = typeof(arg)
                    local argValue = ""
                    
                    if argType == "Instance" then
                        argValue = arg.ClassName .. ": " .. arg.Name
                    elseif argType == "table" then
                        argValue = "table (" .. #arg .. " items)"
                    else
                        argValue = tostring(arg)
                    end
                    
                    addLog("      [" .. i .. "] " .. argType .. " = " .. argValue)
                end
            end
            return oldInvoke(self, ...)
        end
    end
end

-- Scan button
scanBtn.MouseButton1Click:Connect(function()
    logBox.Text = ""
    addLog("🔎 SCANNING FOR REMOTES...")
    addLog("")
    
    local count = 0
    local remotesList = {}
    
    -- Search everywhere
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            hookRemote(obj)
            count = count + 1
            table.insert(remotesList, obj:GetFullName())
        end
    end
    
    -- Also search workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            hookRemote(obj)
            count = count + 1
            table.insert(remotesList, obj:GetFullName())
        end
    end
    
    addLog("=" .. string.rep("=", 50) .. "=")
    addLog("✅ FOUND " .. count .. " REMOTES")
    addLog("=" .. string.rep("=", 50) .. "=")
    
    for i, remotePath in ipairs(remotesList) do
        addLog((i) .. ". " .. remotePath)
    end
    
    addLog("")
    addLog("📍 Now click START TRACKING and send a trade!")
    
    statusLabel.Text = "Status: ✅ Scanned " .. count .. " remotes"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    scanBtn.Text = "✅ DONE"
end)

-- Start tracking button
startBtn.MouseButton1Click:Connect(function()
    isTracking = true
    addLog("")
    addLog("=" .. string.rep("=", 50) .. "=")
    addLog("🟢 TRACKING ACTIVE - SEND A TRADE NOW!")
    addLog("=" .. string.rep("=", 50) .. "=")
    
    statusLabel.Text = "Status: 🟢 TRACKING"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    startBtn.Text = "⏹ ACTIVE"
end)

-- Clear button
clearBtn.MouseButton1Click:Connect(function()
    logBox.Text = "Log cleared.\n"
    capturedCalls = {}
    addLog("Ready for new session...")
end)

print("✅ Enhanced Remote Tracker loaded!")
print("Open trade menu, then click SCAN REMOTES button")
