local pd <const> = playdate
local gfx <const> = pd.graphics

class("Widget").extends(gfx.sprite)

-- Widget
--
function Widget:init(x, y, width, height)

	Widget.super.init(self)
	self.initialPosition = pd.geometry.point.new(x, y)
	self:setImage(gfx.image.new(width, height, gfx.kColorClear))
	self:setCenter(0, 0)
	self:moveTo(self.initialPosition)
	self:setZIndex(1000)
	self:draw()
	self:setVisible(false)
	self:add()
	return self

end

function Widget:update()

	Widget.super.update(self)
	self:draw()

end

function Widget:setInputHandlers()

	pd.inputHandlers.push({}, true)

end

function Widget:removeInputHandlers()

	pd.inputHandlers.pop()

end

function Widget:toggle()

	if not playorama.ui.isAnimating() then
		local startX, startY = gfx.getDrawOffset()
		local endX, endY = startX, startY
		local callback = nil
		if endX ~= 0 or endY ~= 0 then
			endX = 0
			endY = 0
			callback = function()
				self:setVisible(false)
			end
			self:removeInputHandlers()
		else
			endX = pd.display.getWidth() - self.x - self.width
			endY = pd.display.getHeight() - self.y - self.height
			self:setVisible(true)
			callback = function()
				self:setInputHandlers()
			end
		end
		playorama.ui.setAnimator(pd.geometry.point.new(startX, startY), pd.geometry.point.new(endX, endY), callback)
	end

end

function Widget:draw()

	return true

end
