local kControlsMargin <const> = 0
local kControlsPadding <const> = 10
local kControlsWidth <const> = 400 - (kControlsMargin * 2)
local kControlsHeight <const> = 40
local kControlsBorderWidth <const> = 0
local kControlsBorderRadius <const> = 4
local kControlsTop <const> = 240 - kControlsHeight - kControlsMargin
local kExtraHeightForBounce <const> = 20
local kControlsFont <const> = playdate.graphics.getFont()

class('Controls').extends(playdate.graphics.sprite)

function Controls:init()

	Controls.super.init(self)
	self.currentTime = 0
	self.totalTime = 0
	self.isVisible = false
	self.y = 240
	self.x = 0
	self.rate = "1.0x"
	self.hasSound = true
	self.playText = "PLAY"
	self.soundText = "S"

	return self

end

-- update()
--
function Controls:update()

	if self.isVisible then
		self:draw()
	end

end

-- getImage()
--
function Controls:getImage()

	if self.img ~= nil then
		return self.img
	else
		self.img = playdate.graphics.image.new(kControlsWidth, kControlsHeight + kExtraHeightForBounce)
		return self.img
	end

end

-- drawBackgroundImage()
--
-- Draws the black background image.
function Controls:drawBackgroundImage()

	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.fillRect(0, 0, kControlsWidth, kControlsHeight + kExtraHeightForBounce)

end

-- drawPlayButton()
--
function Controls:drawPlayButton()

	local buttonWidth <const> = 56
	local buttonHeight <const> = 28
	local offset <const> = math.floor((kControlsHeight - buttonHeight) / 2)
	local x <const> = offset
	local y <const> = offset
	local textY <const> = y + 3 + math.floor((buttonHeight - kControlsFont:getHeight()) / 2)
	local text = self.playText
	playdate.graphics.setLineWidth(3)
	playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.drawRoundRect(x, y, buttonWidth, buttonHeight, 4)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawTextInRect(text, x+3, textY, buttonWidth-6, buttonHeight-6, nil, nil, kTextAlignment.center)

end

-- drawSoundIcon()
--
function Controls:drawSoundIcon()

	local iconWidth <const> = 28
	local iconHeight <const> = 28
	local offset <const> = math.floor((kControlsHeight - iconHeight) / 2)
	local x <const> = offset + 56 + offset
	local y <const> = offset
	local textY <const> = y + 3 + math.floor((iconHeight - kControlsFont:getHeight()) / 2)
	local text = self.soundText
	playdate.graphics.setLineWidth(3)
	playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.drawRoundRect(x, y, iconWidth, iconHeight, 4)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawTextInRect(text, x+3, textY, iconWidth-6, iconHeight-6, nil, nil, kTextAlignment.center)

end

-- drawRateButton()
--
function Controls:drawRateButton()

	local buttonWidth <const> = 38
	local buttonHeight <const> = 28
	local offset <const> = math.floor((kControlsHeight - buttonHeight) / 2)
	local x <const> = 400 - buttonWidth - offset
	local y <const> = offset
	local textY <const> = y + 3 + math.floor((buttonHeight - kControlsFont:getHeight()) / 2)
	local text = self.rate
	if text == "CRK!" then
		text = "🎣"
	end
	playdate.graphics.setLineWidth(3)
	playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.drawRoundRect(x, y, buttonWidth, buttonHeight, 4)
	playdate.graphics.drawTextInRect(text, x+3, textY, buttonWidth-6, buttonHeight-6, nil, nil, kTextAlignment.center)

end

-- drawCurrentTime()
--
function Controls:drawCurrentTime()

	local x <const> = 6 + 56 + 6 + 28 + 8
	local y <const> = math.floor((kControlsHeight - kControlsFont:getHeight() + 6) / 2)
	local currentTimeString = getTimeAsAString(self.currentTime)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText(currentTimeString, x, y)

end

-- drawTotalTime()
--
function Controls:drawTotalTime()

	local x <const> = 400 - 6 - 38 - 6
	local y <const> = math.floor((kControlsHeight - kControlsFont:getHeight() + 6) / 2)
	local totalTimeString = getTimeAsAString(self.totalTime)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawTextAligned(totalTimeString, x, y, kTextAlignment.right)

end

-- drawScrobbleBar()
--
function Controls:drawScrobbleBar()

	playdate.graphics.setLineWidth(0)
	-- Background shape
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.fillRoundRect(146, 18, 162, 4, 4)
	-- Current shape
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRoundRect(146, 18, self:getScrobbleWidth(162), 4, 4)

end

-- draw()
--
function Controls:draw()

	local controlsImage = self:getImage()
	playdate.graphics.pushContext(controlsImage)
		self:drawBackgroundImage()
		self:drawPlayButton()
		self:drawSoundIcon()
		self:drawCurrentTime()
		self:drawScrobbleBar()
		self:drawTotalTime()
		self:drawRateButton()

	-- Pop context and draw
	playdate.graphics.popContext() -- controlsImage
	controlsImage:draw(kControlsMargin, self.y)

end

-- toggle()
--
function Controls:toggle()

	if self.isVisible then
		self:hide()
	else
		self:show()
	end

end

-- hide()
--
function Controls:hide()

	if self.timer ~= nil then
		self.timer:remove()
	end
	self.timer = playdate.timer.new(500, self.y, 240, playdate.easingFunctions.outBounce)
	self.timer.updateCallback = function(timer)
		self.y = timer.value
	end
	self.timer.timerEndedCallback = function(timer)
		self.isVisible = false
	end

end

function Controls:hideNow()

	self.isVisible = false
	self.y = 240

end

-- show()
--
function Controls:show()

	if self.timer ~= nil then
		self.timer:remove()
	end
	self.isVisible = true
	self.timer = playdate.timer.new(500, self.y, kControlsTop, playdate.easingFunctions.outElastic)
	self.timer.updateCallback = function(timer)
		self.y = timer.value
	end

end

-- setY()
--
function Controls:setY(y)

	self.y = y

end

-- getScrobbleWidth(barWidth)
--
function Controls:getScrobbleWidth(barWidth)

	local xMin = 0
	local xMax = barWidth
	local x = math.floor((self.currentTime * xMax) / self.totalTime)
	if x > xMax then
		x = xMax
	end
	if x < xMin then
		x = xMin
	end
	return x

end

-- setTotalTime()
--
function Controls:setTotalTime(time)

	self.totalTime = time

end

-- setCurrentTime()
--
function Controls:setCurrentTime(time)

	self.currentTime = time

end

-- setSoundText()
--
function Controls:setSoundText(text)

	self.soundText = text

end

-- setPlayText()
--
function Controls:setPlayText(text)

	self.playText = text

end

-- setRate()
--
function Controls:setRate(rate)

	self.rate = rate

end

-- getTimeAsAString(time)
--
-- Converts a time value (in seconds)
-- to a string in the 'HH:MM' format. Maxes out at '99:99'.
function getTimeAsAString(time)

	local minutes = math.floor(time / 60)
	local seconds = math.floor(time % 60)
	if minutes > 99 then
		minutes = 99
	end
	if seconds > 59 then
		seconds = 59
	end
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	if seconds < 10 then
		seconds = '0' .. seconds
	end
	return minutes .. ':' .. seconds

end