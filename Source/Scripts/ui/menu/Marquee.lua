local pd <const> = playdate
local gfx <const> = pd.graphics

class('Marquee').extends(gfx.sprite)

-- Marquee
--
function Marquee:init(text, x, y, z, width, height)

	Marquee.super.init(self)
	x = x or 0
	y = y or 0
	z = z or 100
	width = width or 400
	height = height or 240
	self.text = text or "[Hello World!]"
	self._pauseDuration = 50
	self._pause = self._pauseDuration
	self._padding = 10
	self._xDirection = -1
	self._xScrollStart = self._padding
	self._xScrollOffset = self._xScrollStart
	self._textImage = gfx.imageWithText(self.text, 9999, 9999, gfx.kColorClear, nil, "…", nil, playorama.ui.fonts.large)
	self._xScrollStop = width - self._textImage.width - self._padding
	self.items = list
	self:setCenter(0, 0)
	self:setZIndex(z)
	self:setSize(width, height)
	self:moveTo(x, y)
	self:add()
	return self

end

-- update()
--
function Marquee:update()

	Marquee.super.update(self)
	if self._pause == 0 then
		self._xScrollOffset += 1 * self._xDirection
		if self._xScrollOffset < self._xScrollStop then
			self._xDirection = 1
			self._pause = self._pauseDuration
		elseif self._xScrollOffset > self._xScrollStart then
			self._xDirection = -1
			self._pause = self._pauseDuration
		end
		self:draw()
	else
		self._pause -= 1
	end

end

-- draw()
--
function Marquee:draw()

	gfx.pushContext(self:getImage())
		gfx.clear(gfx.kColorWhite)
		self._textImage:draw(self._xScrollOffset, 0)
	gfx.popContext()

end
