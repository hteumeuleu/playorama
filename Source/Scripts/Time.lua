class('Time').extends(playdate.graphics.sprite)

-- Time
--
function Time:init()

	Time.super.init(self)
	local width = kFontCuberickBold:getTextWidth("00:00")
	local height = kFontCuberickBold:getHeight()
	self:setSize(width, height)
	self:moveTo(10 + (width / 2), 20)
	self:setZIndex(2)
	self:initImage()
	return self

end

-- initImage()
--
function Time:initImage()

	local img = playdate.graphics.image.new(self.width, self.height)
	playdate.graphics.pushContext(img)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		local time <const> = playdate.getTime()
		local hours = padNumber(time.hour)
		local minutes = padNumber(time.minute)
		playdate.graphics.drawText(hours .. ":" .. minutes, 0, 0)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	playdate.graphics.popContext()
	self:setImage(img)
	self.timer = playdate.timer.performAfterDelay(60000, function(timeObj)
		timeObj:initImage()
	end, self)

end