import "Scripts/ui/menu/ListView"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Menu').extends(gfx.sprite)

-- Menu
--
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

	-- Outro animation
	-- if self._outroAnimator ~= nil and not self._outroAnimator:ended() then
	-- 	self._outroSprite:setImage(self:_getOutroMaskImage(self._outroAnimator:currentValue()))
	-- elseif self._outroAnimator ~= nil and self._outroAnimator:ended() then
	-- 	self:detachSprite(self._outroSprite)
	-- 	self._outroAnimator = nil
	-- 	self._outroSprite = nil
	-- 	self._outroCallback()
	-- end

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
			-- if self.listview:isSelectionAPlayer() then
			-- 	self:outro(function() self.listview:doSelectionCallback() end)
			-- else
				self.listview:doSelectionCallback()
			-- end
		end,
		BButtonUp = function()
			self:pop()
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

-- outro()
--
-- Outro animation from Menu to Player
-- function Menu:outro(callback)

-- 	local radius <const> = 250
-- 	local mask = self:_getOutroMaskImage(radius)
-- 	self._outroSprite = gfx.sprite.new(mask)
-- 	self._outroSprite:moveTo(200, 120)
-- 	self:attachSprite(self._outroSprite)
-- 	self._outroSprite:setZIndex(300)
-- 	-- Create animator
-- 	self._outroAnimator = gfx.animator.new(300, radius, 0)
-- 	-- Prepare callback
-- 	self._outroCallback = callback
-- 	-- self._outroCallback()

-- end

-- function Menu:_getOutroMaskImage(radius)

-- 	local mask = gfx.image.new(400, 240)
-- 	gfx.pushContext(mask)
-- 		gfx.setColor(gfx.kColorBlack)
-- 		gfx.fillRect(0, 0, 400, 240)
-- 		gfx.setColor(gfx.kColorClear)
-- 		gfx.fillCircleAtPoint(200, 120, radius)
-- 	gfx.popContext()
-- 	return mask

-- end
