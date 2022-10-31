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

-- update()
--
function Time:update()

	Time.super.update(self)
	local elapsedTime = playdate.getElapsedTime()
	if elapsedTime >= 60 then
		self:initImage()
	end
	return self

end

-- initImage()
--
function Time:initImage()

	playdate.resetElapsedTime()
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

end