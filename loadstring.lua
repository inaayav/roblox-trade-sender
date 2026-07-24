local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== SIMPLE REMOTE LISTER ===")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteListGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 600, 0, 750)
frame.Position = UDim2.new(0.5, -300, 0, 5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
titleLabel.BackgroundTransparency = 0.3
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "📋 ALL REMOTES IN GAME"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Name = "RefreshBtn"
refreshBtn.Size = UDim2.new(0.9, 0, 0, 35)
refreshBtn.Position = UDim2.new(0.05, 0, 0, 45)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
refreshBtn.BackgroundTransparency = 0.3
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextSize = 14
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.Text = "🔄 REFRESH LIST"
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = frame

local listBox = Instance.new("TextBox")
listBox.Name = "List"
listBox.Size = UDim2.new(0.95, 0, 0, 650)
listBox.Position = UDim2.new(0.025, 0, 0, 85)
listBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
listBox.BackgroundTransparency = 0.2
listBox.TextColor3 = Color3.fromRGB(100, 255, 100)
listBox.TextSize = 9
listBox.Font = Enum.Font.GothamMonospace
listBox.TextWrapped = true
listBox.TextXAlignment = Enum.TextXAlignment.Left
listBox.TextYAlignment = Enum.TextYAlignment.Top
listBox.ReadOnly = true
listBox.Text = "Click REFRESH LIST to scan...\n"
listBox.BorderSizePixel = 0
listBox.Parent = frame

-- Function to list all remotes
local function listAllRemotes()
    listBox.Text = "🔍 SCANNING...\n\n"
    
    print("Scanning ReplicatedStorage...")
    
    local remotes = {}
    local count = 0
    
    -- Get all remotes from ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local fullPath = obj:GetFullName()
            table.insert(remotes, {
                name = obj.Name,
                type = obj.ClassName,
                path = fullPath
            })
            count = count + 1
            print("Found: " .. fullPath .. " (" .. obj.ClassName .. ")")
        end
    end
    
    -- Sort by name
    table.sort(remotes, function(a, b) return a.name < b.name end)
    
    -- Display
    listBox.Text = "=" .. string.rep("=", 60) .. "\n"
    listBox.Text = listBox.Text .. "TOTAL REMOTES: " .. count .. "\n"
    listBox.Text = listBox.Text .. "=" .. string.rep("=", 60) .. "\n\n"
    
    for i, remote in ipairs(remotes) do
        local icon = remote.type == "RemoteEvent" and "🔴" or "🔵"
        listBox.Text = listBox.Text .. i .. ". " .. icon .. " " .. remote.name .. "\n"
        listBox.Text = listBox.Text .. "   Type: " .. remote.type .. "\n"
        listBox.Text = listBox.Text .. "   Path: " .. remote.path .. "\n\n"
        print(i .. ". " .. remote.name .. " (" .. remote.type .. ")")
    end
    
    print("✅ Total remotes found: " .. count)
end

refreshBtn.MouseButton1Click:Connect(function()
    listAllRemotes()
end)

-- Auto-scan on load
task.wait(0.5)
listAllRemotes()

print("✅ Remote Lister loaded!")
print("Click REFRESH LIST to update")
