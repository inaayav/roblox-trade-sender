local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("🔍 Looking for SendTradeOffer remote...")

local tradeRemote = nil

-- Search for the remote in RF/Trading path
local function findRemoteByPath()
	local rf = ReplicatedStorage:FindFirstChild("RF")
	if rf then
		local trading = rf:FindFirstChild("Trading")
		if trading then
			local sendOffer = trading:FindFirstChild("SendTradeOffer")
			if sendOffer then
				return sendOffer
			end
		end
	end
	
	-- Deep search
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj.Name == "SendTradeOffer" and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
			return obj
		end
	end
	
	return nil
end

tradeRemote = findRemoteByPath()

if tradeRemote then
	print("✅ Found: " .. tradeRemote:GetFullName())
else
	print("❌ SendTradeOffer not found")
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TradeGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 220)
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
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 35)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.BackgroundTransparency = 0.2
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
if tradeRemote then
	statusLabel.Text = "✅ Found: SendTradeOffer"
else
	statusLabel.Text = "❌ Remote not found"
end
statusLabel.BorderSizePixel = 0
statusLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Name = "Input"
inputBox.Size = UDim2.new(0.9, 0, 0, 35)
inputBox.Position = UDim2.new(0.05, 0, 0, 80)
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
button.Position = UDim2.new(0.05, 0, 0, 120)
button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
button.BackgroundTransparency = 0.2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Text = "SEND TRADE"
button.BorderSizePixel = 0
button.Parent = frame

local amountLabel = Instance.new("TextLabel")
amountLabel.Name = "Amount"
amountLabel.Size = UDim2.new(0.9, 0, 0, 25)
amountLabel.Position = UDim2.new(0.05, 0, 0, 160)
amountLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
amountLabel.BackgroundTransparency = 0.5
amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
amountLabel.TextSize = 11
amountLabel.Font = Enum.Font.Gotham
amountLabel.Text = "Tokens to offer (optional): 0"
amountLabel.BorderSizePixel = 0
amountLabel.Parent = frame

local tokenBox = Instance.new("TextBox")
tokenBox.Name = "TokenInput"
tokenBox.Size = UDim2.new(0.9, 0, 0, 30)
tokenBox.Position = UDim2.new(0.05, 0, 0, 185)
tokenBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tokenBox.BackgroundTransparency = 0.2
tokenBox.TextColor3 = Color3.fromRGB(255, 255, 255)
tokenBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
tokenBox.PlaceholderText = "0"
tokenBox.TextSize = 12
tokenBox.Font = Enum.Font.Gotham
tokenBox.BorderSizePixel = 0
tokenBox.Parent = frame

button.MouseButton1Click:Connect(function()
	if not tradeRemote then
		statusLabel.Text = "❌ Remote not found!"
		return
	end
	
	local playerName = inputBox.Text:match("^%s*(.-)%s*$")
	
	if playerName == "" or playerName == nil then
		statusLabel.Text = "❌ Enter a username!"
		return
	end
	
	local target = Players:FindFirstChild(playerName)
	
	if not target then
		statusLabel.Text = "❌ Player not found: " .. playerName
		return
	end
	
	local tokenAmount = tonumber(tokenBox.Text) or 0
	
	statusLabel.Text = "📤 Sending trade to " .. target.Name .. "..."
	button.Text = "SENDING..."
	button.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	
	local success = false
	
	-- Try Pattern 1: (target)
	pcall(function()
		tradeRemote:FireServer(target)
		success = true
		print("✅ Sent with pattern: (target)")
	end)
	
	task.wait(0.3)
	
	-- Try Pattern 2: (target, tokenAmount)
	if not success then
		pcall(function()
			tradeRemote:FireServer(target, tokenAmount)
			success = true
			print("✅ Sent with pattern: (target, tokens)")
		end)
	end
	
	task.wait(0.3)
	
	-- Try Pattern 3: (target.Name)
	if not success then
		pcall(function()
			tradeRemote:FireServer(target.Name)
			success = true
			print("✅ Sent with pattern: (targetName)")
		end)
	end
	
	task.wait(0.3)
	
	-- Try Pattern 4: (target, {})
	if not success then
		pcall(function()
			tradeRemote:FireServer(target, {})
			success = true
			print("✅ Sent with pattern: (target, {})")
		end)
	end
	
	task.wait(1)
	
	if success then
		statusLabel.Text = "✅ Trade sent! Check if " .. target.Name .. " got it"
		button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		print("✅ Trade should be sent to " .. target.Name)
	else
		statusLabel.Text = "⚠️ Sent but verify in-game"
		button.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	end
	
	task.wait(3)
	button.Text = "SEND TRADE"
	button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
end)

print("✅ Trade Sender GUI created!")
print("📍 Remote location: RF/Trading/SendTradeOffer")
