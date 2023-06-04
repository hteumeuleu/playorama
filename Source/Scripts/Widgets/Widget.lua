class('Widget').extends('Scene')

-- Widget
--
function Widget:init()

	Widget.super.init(self)
	self:setCenter(0, 0)
	return self

end

-- _drawBackgroundImage()
--
-- Private function. Returns the background image for the Widget.
function Widget:_getBackgroundImage()

	local img = playdate.graphics.image.new(self.width, self.height)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(0, 0, self.width, self.height, 8)
	playdate.graphics.popContext()
	return img

end