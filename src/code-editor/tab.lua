local UserInputService = game:GetService("UserInputService")

local tab = {}
tab.__index = tab

--[[
	Вкладка
]]
export type tab = typeof(setmetatable(
	{} :: {
		--[[
		
		]]
		_MainFrame: TextBox,

	}, tab
))

--[[
	Создать новую вкладку
]]
function tab.new(name: string?, code: string?, parent: Frame?): tab

	local self = setmetatable(
		{
			_MainFrame = Instance.new("TextBox")
		}, 
		tab
	)

	self._MainFrame.Parent = parent
	self._MainFrame.Size = UDim2.fromScale(1, 1)
	self._MainFrame.ClearTextOnFocus = false
	self._MainFrame.TextXAlignment = Enum.TextXAlignment.Left
	self._MainFrame.TextYAlignment = Enum.TextYAlignment.Top

	return self
end

function tab.GetText(self: tab): string
	return self._MainFrame.Text
end

function tab.Destroy(self: tab)
	self._MainFrame:Destroy()
end

return tab
