import "Scripts/Scenes/Scene"
import "Scripts/Scenes/Menu/List"
import "Scripts/Scenes/Menu/ListItem"
import "Scripts/Scenes/Menu/ListView"

class('Menu').extends('Scene')

-- Menu
--
function Menu:init(list)

	Menu.super.init(self)
	self.listview = ListView(list)
	self.history = {}
	self:attachSprite(self.listview)
	self:setInputHandlers()
	return self

end

-- setInputHandlers()
--
function Menu:setInputHandlers()

	local myInputHandlers = {
		AButtonUp = function()
			self.listview:doSelectionCallback()
		end,
		BButtonUp = function()
			self:pop()
		end,
		upButtonUp = function()
			self.listview:up()
		end,
		downButtonUp = function()
			self.listview:down()
		end,
	}
	playdate.inputHandlers.push(myInputHandlers)

end

-- goTo()
--
function Menu:goTo(i)

	print(i)

end

-- push()
--
function Menu:push(newListView)

	local wasFullScreen = self.listview:isFullScreen()
	table.insert(self.history, self.listview)
	self:detachSprite(self.listview)
	self.listview = newListView
	self.listview:setFullScreen(wasFullScreen)
	self:attachSprite(self.listview)

end

-- pop()
--
function Menu:pop()

	if #self.history > 0 then
		local wasFullScreen = self.listview:isFullScreen()
		local newListView = table.remove(self.history)
		self:detachSprite(self.listview)
		self.listview = newListView
		self.listview:setFullScreen(wasFullScreen)
		self:attachSprite(self.listview)
	end

end