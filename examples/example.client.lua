local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- библиотека
local codeEditor = require(ReplicatedStorage["code-editor"])

if not Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") then

	local Gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
	Gui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame", Gui)

	MainFrame.Size = UDim2.fromScale(1, 1)

	-- редактор кода
	local editor = codeEditor.new(MainFrame)
end

