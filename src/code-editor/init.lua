local tab = require(script.tab)

local codeEditor = {}
codeEditor.__index = codeEditor

export type codeEditor = typeof(setmetatable(
	{} :: {
		--[[
			Основной фрейм редактора
		]]
		_MainFrame: Frame,

		_TabsContentArea: Frame,

		--[[
			Активная сейчас вкладка
		]]
		_activeTab: NumberValue,

		--[[
			Список всех вкладок
		]]
		_tabs: {tab.tab},

		--[[
			Список RBXScriptConnection
		]] 
		_connections: {RBXScriptConnection}
	}, codeEditor)
)

--[[
	Таблица цветов
]]
export type colorsTable = {
	Main: Color3,
	Tab: Color3
}

function codeEditor.new(mainFrame: Frame?): codeEditor

	local MainFrame = mainFrame or Instance.new("Frame")
	local TabsContentArea = Instance.new("Frame", MainFrame)

	local self = setmetatable(
		{
			_MainFrame = MainFrame,
			_activeTab = Instance.new("NumberValue", MainFrame),
			_tabs = {
				[1] = tab.new(nil, nil, TabsContentArea)
			},
			_TabsContentArea = TabsContentArea,
			_connections = {}
		}, 
		codeEditor
	)

	self._TabsContentArea.Size = UDim2.fromScale(1, 0.8)
	self._TabsContentArea.Position = UDim2.fromScale(0, 0.2)

	self._activeTab.Value = 1

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
function codeEditor.OpenCode(self: codeEditor, code: string): tab.tab
	local tab = tab.new(nil, code, self._TabsContentArea)

	table.insert(self._tabs, tab)

	return tab
end

function codeEditor.Destroy(self: codeEditor)
	for _, v in pairs(self._tabs) do
		v:Destroy()
	end

	self._MainFrame:Destroy()

	self._activeTab:Destroy()
end

return codeEditor
