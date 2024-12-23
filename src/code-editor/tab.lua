local ReplicatedStorage = game:GetService("ReplicatedStorage")



local Packages = ReplicatedStorage.Packages


local stdlib = require(Packages.stdlib)

local algorithm = stdlib.algorithm



local tab = {}

--[[
	Таблица цветов вкладки
]]
export type ColorsTable = {
	Text: Color3,
	Background: Color3,
	Nums: Color3
}

--[[
	Создать таблицу цветов вкладки
]]
function tab.newColorsTable(text: Color3?, background: Color3?, nums: Color3?): ColorsTable
	return   {
		Text = text or Color3.fromHex("#d6d6d6"),
		Background = background or Color3.fromHex("#292929"),
		Nums = nums or Color3.fromHex("#7c7c7c")
	}
end


local tabClass = {}
tabClass.__index = tabClass

--[[
	Вкладка
]]
export type Tab = typeof(setmetatable(
	{} :: {
		--[[
		
		]]
		_MainFrame: ScrollingFrame,

		_TextBox: TextBox,

		--[[
			Нумерация строк
		]]
		_NumsColumn: TextLabel,
		
		--[[
			Таблица цветов вкладки
		]]
		_colorTable: ColorsTable
	}, tabClass
))

--[[
	Создать новую вкладку
]]
function tab.new(name: string?, code: string?, parent: Frame?, colorsTable: ColorsTable?): Tab

	local MainFrome = Instance.new("ScrollingFrame", parent)

	local self = setmetatable(
		{
			_MainFrame = MainFrome,
			_TextBox = Instance.new("TextBox", MainFrome),
			_NumsColumn = Instance.new("TextLabel", parent),
			_colorsTable = colorsTable or tab.newColorsTable()
		}, 
		tabClass
	)

	self._MainFrame.InputBegan:Connect(function(inputObject: InputObject) 

		if inputObject.KeyCode.Value == Enum.KeyCode.Backspace.Value or inputObject.KeyCode.Value == Enum.KeyCode.Return.Value then
			local str = ""

			for i = 1, algorithm.count(code, '\n'), 1 do
				str ..= tostring(i).."\n"
			end

			self._NumsColumn.Text = str
		end
	end)

	self:SetColors(self._colorsTable)

	self._MainFrame.Size = UDim2.new(1, -self._NumsColumn.TextSize, 1, 0)
	self._MainFrame.Position = UDim2.new(0, self._NumsColumn.TextSize, 0, 0)

	self._TextBox.Size = UDim2.fromScale(1, 1)
	self._TextBox.ClearTextOnFocus = false
	self._TextBox.TextXAlignment = Enum.TextXAlignment.Left
	self._TextBox.TextYAlignment = Enum.TextYAlignment.Top
	self._TextBox.MultiLine = true
	self._TextBox.Text = code
	self._TextBox.BackgroundTransparency = 1

	Instance.new("UIPadding", self._MainFrame)

	self._NumsColumn.Size = UDim2.new(0, self._NumsColumn.TextSize, 1, 0)
	self._NumsColumn.TextXAlignment = Enum.TextXAlignment.Right
	self._NumsColumn.TextYAlignment = Enum.TextYAlignment.Top
	self._NumsColumn.TextColor3 = self._colorsTable.Nums

	return self
end

function tabClass.GetText(self: Tab): string
	return self._TextBox.Text
end

--[[
	Изменить размер текста
]]
function tabClass.SetFontSize(self: Tab, newFontSize)
	self._TextBox.TextSize = newFontSize
	self._NumsColumn.TextSize = newFontSize

	self._NumsColumn.Size = UDim2.new(0, newFontSize, 1, 0)
	self._MainFrame.Size = UDim2.new(1, -newFontSize, 1, 0)
	self._MainFrame.Position = UDim2.new(0, newFontSize, 0, 0)
end

--[[
	Изменить цвета вкладки
]]
function tabClass.SetColors(self: Tab, colorsTable: ColorsTable)
	self._MainFrame.BackgroundColor3 = colorsTable.Background
	self._NumsColumn.BackgroundColor3 = colorsTable.Background
	self._TextBox.TextColor3 = colorsTable.Text
end

--[[
	Удалить вкладку
]]
function tabClass.Destroy(self: Tab)
	self._MainFrame:Destroy()
end


return setmetatable(tab, tabClass)

