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
			self:previous()
		end,
		downButtonUp = function()
			self:next()
		end,
		cranked = function(change, acceleratedChange)
			local ticks = playdate.getCrankTicks(2)
			if ticks == 1 then
				self:next()
			elseif ticks == -1 then
				self:previous()
			end
		end,
	}
	playdate.inputHandlers.push(myInputHandlers)

end

-- previous()
--
function Menu:previous()

	self.listview:up()
	if app.header.reel then
		app.header.reel:next()
	end

end

-- next()
--
function Menu:next()

	self.listview:down()
	if app.header.reel then
		app.header.reel:previous()
	end

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