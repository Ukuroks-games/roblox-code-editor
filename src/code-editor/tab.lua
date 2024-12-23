local ReplicatedStorage = game:GetService("ReplicatedStorage")



local Packages = ReplicatedStorage.Packages


local stdlib = require(Packages.stdlib)

local algorithm = stdlib.algorithm



local tab = {}


export type ColorsTable = {
	Text: Color3,
	Background: Color3,
	Nums: Color3
}

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
		_MainFrame: TextBox,

		--[[
			Нумерация строк
		]]
		_NumsColumn: TextLabel,

		_colorTable: ColorsTable
	}, tabClass
))

--[[
	Создать новую вкладку
]]
function tab.new(name: string?, code: string?, parent: Frame?, colorsTable: ColorsTable?): Tab

	local self = setmetatable(
		{
			_MainFrame = Instance.new("TextBox", parent),
			_NumsColumn = Instance.new("TextLabel", parent),
			_colorsTable = colorsTable or tab.newColorsTable()
		}, 
		tabClass
	)

	self._MainFrame.InputBegan:Connect(function(inputObject: InputObject) 

		if inputObject.KeyCode == Enum.KeyCode.Backspace or inputObject.KeyCode == Enum.KeyCode.Return then
			local str = ""

			for i = 1, algorithm.count(code, '\n'), 1 do
				str ..= tostring(i).."\n"
			end

			self._NumsColumn.Text = str
		end
	end)

	self._MainFrame.Size = UDim2.fromScale(0.9, 1)
	self._MainFrame.Position = UDim2.fromScale(0.1, 0)
	self._MainFrame.ClearTextOnFocus = false
	self._MainFrame.TextXAlignment = Enum.TextXAlignment.Left
	self._MainFrame.TextYAlignment = Enum.TextYAlignment.Top
	self._MainFrame.MultiLine = true
	self._MainFrame.Text = code
	self._MainFrame.TextColor3 = self._colorsTable.Text
	self._MainFrame.BackgroundColor3 = self._colorsTable.Background

	Instance.new("UIPadding", self._MainFrame)

	self._NumsColumn.Size = UDim2.fromScale(0.1, 1)
	self._NumsColumn.TextXAlignment = Enum.TextXAlignment.Right
	self._NumsColumn.TextYAlignment = Enum.TextYAlignment.Top
	self._NumsColumn.TextColor3 = self._colorsTable.Nums
	self._NumsColumn.BackgroundColor3 = self._colorsTable.Background

	


	return self
end

function tabClass.GetText(self: Tab): string
	return self._MainFrame.Text
end

function tabClass.SetFontSize(self: Tab, newFontSize)
	self._MainFrame.TextSize = newFontSize
	self._NumsColumn.TextSize = newFontSize
end



--[[
	Удалить вкладку
]]
function tabClass.Destroy(self: Tab)
	self._MainFrame:Destroy()
end


return setmetatable(tab, tabClass)

