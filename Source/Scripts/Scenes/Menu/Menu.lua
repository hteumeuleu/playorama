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
			app.header.reel:next()
		end,
		downButtonUp = function()
			self.listview:down()
			app.header.reel:previous()
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

	table.insert(self.history, self.listview)
	self:detachSprite(self.listview)
	self.listview = newListView
	self:attachSprite(self.listview)

end

-- pop()
--
function Menu:pop()

	if #self.history > 0 then
		local newListView = table.remove(self.history)
		self:detachSprite(self.listview)
		self.listview = newListView
		self:attachSprite(self.listview)
	end

end