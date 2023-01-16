local kControlsMargin <const> = 0
local kControlsPadding <const> = 8
local kControlsWidth <const> = 400 - (kControlsMargin * 2)
local kControlsHeight <const> = 40
local kControlsBorderWidth <const> = 0
local kControlsBorderRadius <const> = 8
local kControlsTop <const> = 240 - kControlsHeight - kControlsMargin
local kControlsFont <const> = playdate.graphics.getFont()

class('Controls').extends(playdate.graphics.sprite)

-- Controls
--
-- This class is for the controls UI displayed on top of a video playing.
function Controls:init()

	Controls.super.init(self)
	self.currentTime = 0
	self.totalTime = 0
	self:setCenter(0,0)
	self:setVisible(true)
	self:moveTo(kControlsMargin,kControlsTop)
	self:setImage(playdate.graphics.image.new(kControlsWidth, kControlsHeight, playdate.graphics.kColorClear))
	self.rate = "1.0x"
	self.hasSound = true
	return self

end

-- update()
--
function Controls:update()

	Controls.super.update(self)
	if self:isVisible() and self.customDraw ~= nil then
		self:customDraw()
	end

end

-- getMuteIcon()
--
function Controls:getMuteIcon()

	if self.muteIcon ~= nil then
		return self.muteIcon
	else
		self.muteIcon = playdate.graphics.image.new("Assets/mute")
		return self.muteIcon
	end

end

-- drawBackgroundImage()
--
-- Draws the black background image.
function Controls:drawBackgroundImage()

	playdate.graphics.setColor(playdate.graphics.kColorBlack)
	playdate.graphics.fillRoundRect(0, 0, kControlsWidth, kControlsHeight, kControlsBorderRadius)

end

-- drawSoundIcon()
--
function Controls:drawSoundIcon()

	local icon <const> = self:getMuteIcon()
	local x <const> = self.currentOffset + kControlsPadding
	local y <const> = 10
	icon:draw(x, y)
	self.currentOffset = x + icon.width

end

-- drawPauseButton()
--
function Controls:drawPauseButton()
	local width <const> = 40
	local height <const> = 28
	local x = 400 - width - kControlsPadding - kControlsMargin
	local y = 6
	local iconWidth = 9
	local iconHeight = 12
	local barWidth = 3
	-- Round border
	playdate.graphics.setLineWidth(3)
	playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.drawRoundRect(x, y, width, height, 4)
	-- Icon
	x = x + math.abs(math.floor((width - iconWidth) / 2))
	y = y + math.abs(math.floor((height - iconHeight) / 2))
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRect(x, y, barWidth, iconHeight)
	playdate.graphics.fillRect(x + iconWidth - barWidth, y, barWidth, iconHeight)
end

-- drawRateButton()
--
function Controls:drawRateButton()

	local buttonWidth <const> = 40
	local buttonHeight <const> = 28
	local offset <const> = math.floor((kControlsHeight - buttonHeight) / 2)
	local x <const> = 400 - buttonWidth - kControlsPadding - kControlsMargin
	local y <const> = offset
	local textY = y + 3 + math.floor((buttonHeight - kControlsFont:getHeight()) / 2)
	local text = self.rate
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRoundRect(x, y, buttonWidth, buttonHeight, 4)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
	playdate.graphics.drawTextInRect(text, x+1, textY, buttonWidth-6, buttonHeight-6, nil, nil, kTextAlignment.right)

end

-- drawCurrentTime()
--
function Controls:drawCurrentTime()

	local x <const> = self.currentOffset + kControlsPadding
	local y <const> = math.floor((kControlsHeight - kControlsFont:getHeight() + 6) / 2)
	local currentTimeString = getTimeAsAString(self.currentTime)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText(currentTimeString, x, y)
	self.currentOffset = x + 38

end

-- drawTotalTime()
--
function Controls:drawTotalTime()

	local x <const> = self.currentOffset + kControlsPadding
	local y <const> = math.floor((kControlsHeight - kControlsFont:getHeight() + 6) / 2)
	local totalTimeString = getTimeAsAString(self.totalTime)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawTextAligned(totalTimeString, x, y, kTextAlignment.left)
	self.currentOffset = x + 38

end

-- drawScrobbleBar()
--
function Controls:drawScrobbleBar()

	local scrobbleBarWidth <const> = kControlsWidth - (5 * kControlsPadding) - 40 - 28 - self.currentOffset
	local x <const> = self.currentOffset + kControlsPadding
	local y <const> = 18
	playdate.graphics.setLineWidth(0)
	-- Background shape
	playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	playdate.graphics.fillRoundRect(x, y, scrobbleBarWidth, 4, 4)
	-- Current shape
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRoundRect(x, y, self:getScrobbleWidth(scrobbleBarWidth), 4, 4)
	self.currentOffset = x + scrobbleBarWidth

end

-- customDraw()
--
function Controls:customDraw()

	local controlsImage = self:getImage()
	playdate.graphics.pushContext(controlsImage)
		self.currentOffset = 0
		self:drawBackgroundImage()
		if not self:getHasSound() then
			self:drawSoundIcon()
		end
		self:drawCurrentTime()
		self:drawScrobbleBar()
		self:drawTotalTime()
		if self:isPaused() then
			self:drawPauseButton()
		else
			self:drawRateButton()
		end

	-- Pop context and draw
	playdate.graphics.popContext() -- controlsImage
	self:setImage(controlsImage)

end

-- toggle()
--
function Controls:toggle()

	if self:isVisible() then
		self:hide()
	else
		self:show()
	end

end

-- hide()
--
function Controls:hide()

	self:setVisible(false)

end

-- hideNow()
--
-- Instantly hides the Controls, without animation.
function Controls:hideNow()

	self:setVisible(false)
	self.y = 240

end

-- show()
--
function Controls:show()

	self:setVisible(true)

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

-- getHasSound()
--
function Controls:getHasSound()

	return self.hasSound

end

-- setHasSound()
--
function Controls:setHasSound(value)

	if value ~= nil then
		self.hasSound = value
	end

end

-- setRate()
--
function Controls:setRate(rate)

	self.rate = rate

end

-- setPaused()
--
function Controls:setPaused(value)

	self.paused = value

end

-- isPaused()
--
function Controls:isPaused()

	return self.paused

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