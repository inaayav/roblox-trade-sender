local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("🔍 Looking for SendTradeOffer remote...")

local tradeRemote = nil

-- Search function
local function findRemote(searchName)
	-- Search ReplicatedStorage
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj.Name == searchName and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
			return obj
		end
	end
	
	-- Search Workspace
	for _, obj in pairs(game.Workspace:GetDescendants()) do
		if obj.Name == searchName and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
			return obj
		end
	end
	
	-- Search PlayerGui
	for _, obj in pairs(PlayerGui:GetDescendants()) do
		if obj.Name == searchName and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
			return obj
		end
	end
	
	return nil
end

-- Try to find the remote
tradeRemote = findRemote("SendTradeOffer")

-- If not found, print all remotes for debugging
if not tradeRemote then
	print("❌ SendTradeOffer not found. Searching for any trade-related remotes...")
	local remotes = {}
	
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			if obj.Name:lower():find("trade") or obj.Name:lower():find("offer") then
				table.insert(remotes, obj:GetFullName())
				print("📍 Found: " .. obj:GetFullName())
			end
		end
	end
	
	if #remotes == 0 then
		print("⚠️ No trade-related remotes found yet. They may load when you open the trade menu.")
	end
end

if tradeRemote then
	print("✅ Found: " .. tradeRemote:GetFullName())
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TradeGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 260)
frame.Position = UDim2.new(0.5, -175, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
titleLabel.BackgroundTransparency = 0.3
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "TRADE WEAPONS SENDER"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.9, 0, 0, 50)
statusLabel.Position = UDim2.new(0.05, 0, 0, 35)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.BackgroundTransparency = 0.2
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
if tradeRemote then
	statusLabel.Text = "✅ Remote Found!\nReady to send trades"
else
	statusLabel.Text = "⚠️ Remote not found yet\nOpen trade menu in-game first"
end
statusLabel.BorderSizePixel = 0
statusLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Name = "Input"
inputBox.Size = UDim2.new(0.9, 0, 0, 35)
inputBox.Position = UDim2.new(0.05, 0, 0, 90)
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputBox.BackgroundTransparency = 0.2
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
inputBox.PlaceholderText = "Username"
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.BorderSizePixel = 0
inputBox.Parent = frame

local button = Instance.new("TextButton")
button.Name = "SendBtn"
button.Size = UDim2.new(0.9, 0, 0, 35)
button.Position = UDim2.new(0.05, 0, 0, 130)
button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
button.BackgroundTransparency = 0.2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Text = "SEND TRADE"
button.BorderSizePixel = 0
button.Parent = frame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Name = "RefreshBtn"
refreshBtn.Size = UDim2.new(0.9, 0, 0, 30)
refreshBtn.Position = UDim2.new(0.05, 0, 0, 170)
refreshBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
refreshBtn.BackgroundTransparency = 0.3
refreshBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
refreshBtn.TextSize = 12
refreshBtn.Font = Enum.Font.Gotham
refreshBtn.Text = "🔄 REFRESH REMOTE"
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = frame

local amountLabel = Instance.new("TextLabel")
amountLabel.Name = "Amount"
amountLabel.Size = UDim2.new(0.9, 0, 0, 20)
amountLabel.Position = UDim2.new(0.05, 0, 0, 205)
amountLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
amountLabel.BackgroundTransparency = 0.5
amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
amountLabel.TextSize = 10
amountLabel.Font = Enum.Font.Gotham
amountLabel.Text = "Tokens (optional):"
amountLabel.BorderSizePixel = 0
amountLabel.Parent = frame

local tokenBox = Instance.new("TextBox")
tokenBox.Name = "TokenInput"
tokenBox.Size = UDim2.new(0.9, 0, 0, 25)
tokenBox.Position = UDim2.new(0.05, 0, 0, 225)
tokenBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tokenBox.BackgroundTransparency = 0.2
tokenBox.TextColor3 = Color3.fromRGB(255, 255, 255)
tokenBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
tokenBox.PlaceholderText = "0"
tokenBox.TextSize = 12
tokenBox.Font = Enum.Font.Gotham
tokenBox.BorderSizePixel = 0
tokenBox.Parent = frame

-- Refresh button functionality
refreshBtn.MouseButton1Click:Connect(function()
	tradeRemote = findRemote("SendTradeOffer")
	if tradeRemote then
		statusLabel.Text = "✅ Remote Found!\nReady to send trades"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		print("✅ Remote refreshed!")
	else
		statusLabel.Text = "❌ Remote still not found\nOpen trade menu and try again"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		print("❌ Remote not found after refresh")
	end
end)

-- Send button functionality
button.MouseButton1Click:Connect(function()
	-- Refresh remote first
	if not tradeRemote then
		tradeRemote = findRemote("SendTradeOffer")
	end
	
	if not tradeRemote then
		statusLabel.Text = "❌ Remote not found!\nClick REFRESH REMOTE button"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local playerName = inputBox.Text:match("^%s*(.-)%s*$")
	
	if playerName == "" or playerName == nil then
		statusLabel.Text = "❌ Enter a username!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local target = Players:FindFirstChild(playerName)
	
	if not target then
		statusLabel.Text = "❌ Player not found: " .. playerName
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local tokenAmount = tonumber(tokenBox.Text) or 0
	
	statusLabel.Text = "📤 Sending trade to " .. target.Name .. "..."
	statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
	button.Text = "SENDING..."
	button.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	
	local success = false
	
	-- Try different patterns
	local patterns = {
		function() tradeRemote:FireServer(target) end,
		function() tradeRemote:FireServer(target, tokenAmount) end,
		function() tradeRemote:FireServer(target.Name) end,
		function() tradeRemote:FireServer(target, {}) end,
		function() tradeRemote:InvokeServer(target) end,
	}
	
	for i, pattern in ipairs(patterns) do
		pcall(function()
			pattern()
			success = true
			print("✅ Sent with pattern " .. i)
		end)
		if success then break end
		task.wait(0.2)
	end
	
	task.wait(1)
	
	if success then
		statusLabel.Text = "✅ Trade sent to " .. target.Name .. "!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		statusLabel.Text = "⚠️ Sent but verify (check Refresh)"
		statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
	end
	
	task.wait(3)
	button.Text = "SEND TRADE"
	button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
end)

print("✅ Trade Sender GUI created!")
print("📍 If remote not found, open the trade menu in-game first, then click REFRESH REMOTE")
