local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create a simple part to prove script is running
local part = Instance.new("Part")
part.Shape = Enum.PartType.Ball
part.Size = Vector3.new(2, 2, 2)
part.BrickColor = BrickColor.new("Bright red")
part.CanCollide = false
part.CFrame = character.Head.CFrame + character.Head.CFrame.LookVector * 10
part.Parent = workspace

print("✅ Part created - script is working!")
