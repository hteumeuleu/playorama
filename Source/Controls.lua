import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

local kControlsHeight <const> = 40
local kControlsMargin <const> = 0
local kControlsPadding <const> = 10
local kControlsWidth <const> = 400 - (kControlsMargin * 2)
local kControlsBorderWidth <const> = 0
local kControlsBorderRadius <const> = 4
local kControlsTop <const> = 240 - kControlsHeight - kControlsMargin

class('Controls').extends()

function Controls:init()

	Controls.super.init(self)
	self.currentTime = 0
	self.totalTime = 0
	self.isVisible = false
	self.y = 240

	return self

end

-- update()
--
function Controls:update()

	if self.isVisible then
		self:draw()
	end

end

-- draw()
--
function Controls:draw()

	local kExtraHeightForBounce <const> = 20
	local controlsImage = playdate.graphics.image.new(kControlsWidth, kControlsHeight + kExtraHeightForBounce)
	playdate.graphics.pushContext(controlsImage)

		-- Controls bar black background
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(0, 0, kControlsWidth, kControlsHeight + kExtraHeightForBounce, kControlsBorderRadius)

		-- Current time text
		local kControlsFont <const> = playdate.graphics.getFont()
		local kTextForMeasurement <const> = "*00:00*"
		local kControlsTextY <const> = math.floor((kControlsHeight - kControlsFont:getHeight()) / 2) + kControlsBorderWidth
		local currentTimeString = ("*" .. getTimeAsAString(self.currentTime) .. "*")
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText(currentTimeString, kControlsPadding, kControlsTextY)

		-- Total time text
		local totalTimeString = ("*" .. getTimeAsAString(self.totalTime) .. "*")
		local totalTimeX = kControlsWidth - kControlsPadding
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawTextAligned(totalTimeString, totalTimeX, kControlsTextY, kTextAlignment.right)

		-- Resets DrawMode (used for texts only)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)

		-- Scrobble bar
		local scrobbleBarLeft = kControlsFont:getTextWidth(kTextForMeasurement)
		local kScrobbleBarWidth <const> = kControlsWidth - (scrobbleBarLeft * 2)
		local kScrobbleBarHeight <const> = 20
		local kBarHeight <const> = 4
		local barImage = playdate.graphics.image.new(kScrobbleBarWidth, kScrobbleBarHeight)
		local scrobbleBarTop = (kControlsHeight - kScrobbleBarHeight) / 2 - kControlsBorderWidth
		playdate.graphics.pushContext(barImage)
			playdate.graphics.setColor(playdate.graphics.kColorWhite)
			playdate.graphics.fillRoundRect(0, ((kScrobbleBarHeight - kBarHeight) / 2), kScrobbleBarWidth, kBarHeight, kControlsBorderRadius)

			-- Scrobble dot
			local dotImage = playdate.graphics.image.new(20, 20)
			playdate.graphics.pushContext(dotImage)
				playdate.graphics.setColor(playdate.graphics.kColorBlack)
				playdate.graphics.fillCircleInRect(0, 0, 20, 20)
				playdate.graphics.setColor(playdate.graphics.kColorWhite)
				playdate.graphics.setLineWidth(2)
				playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
				playdate.graphics.drawCircleInRect(0, 0, 20, 20)
			playdate.graphics.popContext() -- dotImage
			local dotX = self:getScrobbleX(kScrobbleBarWidth)
			dotImage:draw(dotX, 0)

		playdate.graphics.popContext() -- barImage
		barImage:draw(scrobbleBarLeft, scrobbleBarTop)

	-- Draw controls
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

-- getScrobbleX(time)
--
function Controls:getScrobbleX(barWidth)

	local xMin = 0
	local xMax = barWidth - 20
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