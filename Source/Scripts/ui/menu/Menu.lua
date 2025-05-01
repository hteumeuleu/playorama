import "Scripts/ui/menu/MenuItem"
import "Scripts/ui/menu/ListView"
import "Scripts/ui/menu/Marquee"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Menu').extends(gfx.sprite)

-- Menu
--
-- `list` is a table, each item with { name, type, callback }
function Menu:init(list)

	Menu.super.init(self)
	self.listview = ListView(list)
	self.history = {}
	self:setInputHandlers()
	self:add()
	return self

end

-- update()
--
function Menu:update()

	Menu.super.update(self)

end

function Menu:add()

	Menu.super.add(self)
	self.listview:add()

end

function Menu:remove()

	Menu.super.remove(self)
	self.listview:remove()

end

-- setInputHandlers()
--
function Menu:setInputHandlers()

	local myInputHandlers = {
		AButtonUp = function()
			if not self.listview:isSelectionAPlayer() then
				self:outroToMenu(function() self.listview:doSelectionCallback() end)
			else
				self:outroToPlayer(function() self.listview:doSelectionCallback() end)
			end
		end,
		BButtonUp = function()
			if #self.history > 0 then
				self:outroToMenu(function() self:pop() end)
			end
		end,
		upButtonUp = function()
			self:previous()
			if playorama.ui.header.reel then
				playorama.ui.header.reel:next()
			end
		end,
		downButtonUp = function()
			self:next()
			if playorama.ui.header.reel then
				playorama.ui.header.reel:previous()
			end
		end,
		cranked = function(change, acceleratedChange)
			local ticks = pd.getCrankTicks(2)
			if ticks == 1 then
				self:next()
			elseif ticks == -1 then
				self:previous()
			end
		end,
	}
	pd.inputHandlers.push(myInputHandlers)

end

-- previous()
--
function Menu:previous()

	self.listview:up()

end

-- next()
--
function Menu:next()

	self.listview:down()

end

-- push()
--
function Menu:push(newListView)

	table.insert(self.history, self.listview)
	self.listview:remove()
	self.listview = newListView
	self.listview:add()

end

-- pop()
--
function Menu:pop()

	if #self.history > 0 then
		local newListView = table.remove(self.history)
		self.listview:remove()
		self.listview = newListView
		self.listview:add()
	end

end

-- goTo(i)
--
function Menu:goTo(i)

	print("Menu:goTo", i)

end

-- outroToMenu()
--
-- Outro animation from Menu to another Menu
function Menu:outroToMenu(callback)

	playorama.ui.animator.new("menu", callback)

end

-- outroToPlayer()
--
-- Outro animation from Menu to Player
function Menu:outroToPlayer(callback)

	playorama.ui.animator.new("outro", callback)

end
