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
	self:add()
	return self

end

-- update()
--
function Menu:update()

	Menu.super.update(self)

	-- Outro animation
	if self._outroAnimator ~= nil and not self._outroAnimator:ended() then
		self._outroSprite:setImage(self:_getOutroMaskImage(self._outroAnimator:currentValue()))
	elseif self._outroAnimator ~= nil and self._outroAnimator:ended() then
		self:detachSprite(self._outroSprite)
		self._outroAnimator = nil
		self._outroSprite = nil
		self._outroCallback()
	end

end

-- setInputHandlers()
--
function Menu:setInputHandlers()

	local myInputHandlers = {
		AButtonUp = function()
			if self.listview:isSelectionAPlayer() then
				self:outro(function() self.listview:doSelectionCallback() end)
			else
				self.listview:doSelectionCallback()
			end
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

-- outro()
--
-- Outro animation from Menu to Player
function Menu:outro(callback)

	local radius <const> = 250
	local mask = self:_getOutroMaskImage(radius)
	self._outroSprite = playdate.graphics.sprite.new(mask)
	self._outroSprite:moveTo(200, 120)
	self:attachSprite(self._outroSprite)
	self._outroSprite:setZIndex(300)
	-- Create animator
	self._outroAnimator = playdate.graphics.animator.new(300, radius, 0)
	-- Prepare callback
	self._outroCallback = callback
	-- self._outroCallback()

end

function Menu:_getOutroMaskImage(radius)

	local mask = playdate.graphics.image.new(400, 240)
	playdate.graphics.pushContext(mask)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRect(0, 0, 400, 240)
		playdate.graphics.setColor(playdate.graphics.kColorClear)
		playdate.graphics.fillCircleAtPoint(200, 120, radius)
	playdate.graphics.popContext()
	return mask

end