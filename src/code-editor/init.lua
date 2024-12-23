


local tab = require(script.tab)

local codeEditor = {}
codeEditor.__index = codeEditor

--[[
	Таблица цветов
]]
export type ColorsTable = {
	--[[
		Основной цвет
	]]
	Main: Color3,

	--[[
		Цвет вкладки
	]]
	TabArea: Color3
}

--[[
	Создать таблицу цветов редактора
]]
function codeEditor.newColorsTable(): ColorsTable
	return {
		Main = Color3.fromHex("#303030"),
		TabArea = Color3.fromHex("#4d4d4d")
	}
end

export type codeEditor = typeof(setmetatable(
	{} :: {
		--[[
			Основной фрейм редактора
		]]
		_MainFrame: Frame,

		--[[
			Фрейм, в которм находятся вклдки
		]]
		_TabsContentArea: Frame,

		--[[
			Активная сейчас вкладка
		]]
		_activeTab: NumberValue,

		--[[
			Список всех вкладок
		]]
		_tabs: {tab.Tab},

		--[[
			Таблица цветов редактора
		]]
		_colorsTable: ColorsTable,

		--[[
			Список RBXScriptConnection
		]] 
		_connections: {RBXScriptConnection}
	}, codeEditor)
)


--[[
	Создать редактор
]]
function codeEditor.new(mainFrame: Frame, ColorsTable: ColorsTable?): codeEditor

	local TabsContentArea = Instance.new("Frame", mainFrame)
	
	TabsContentArea.Size = UDim2.fromScale(1, 0.8)
	TabsContentArea.Position = UDim2.fromScale(0, 0.2)

	local colors_Table: ColorsTable = codeEditor.newColorsTable()

	local self = setmetatable(
		{
			_MainFrame = mainFrame,
			_activeTab = Instance.new("NumberValue", mainFrame),
			_tabs = {
				[1] = tab.new("Tab", nil, TabsContentArea, tab.newColorsTable(nil, colors_Table.TabArea))
			},
			_TabsContentArea = TabsContentArea,
			_colorsTable = colors_Table,
			_connections = {}
		}, 
		codeEditor
	)


	self._activeTab.Value = 1
	self._activeTab.Name = "activeTab"

	table.insert(self._connections, self._activeTab.Changed:Connect(function(newValue: number) 
		
		for _, v in pairs(self._tabs) do
			v._MainFrame.Visible = false
		end

		self._tabs[newValue]._MainFrame.Visible = true
	end))

	return self
end

--[[
	Открыть сущетвующую вкладку
]]
function codeEditor.OpenTab(self: codeEditor, TabNum: number)
	self._activeTab.Value = TabNum
end

--[[
	Открыть новую вклюду с кодом
]]
function codeEditor.OpenCode(self: codeEditor, code: string): tab.Tab
	local tab = tab.new(nil, code, self._TabsContentArea)

	table.insert(self._tabs, tab)

	return tab
end

--[[
	Удалить редактор
]]
function codeEditor.Destroy(self: codeEditor)
	for _, v in pairs(self._tabs) do
		v:Destroy()
	end

	self._MainFrame:Destroy()

	self._activeTab:Destroy()
end

return codeEditor
