import "CoreLibs/object"
import "CoreLibs/ui"
import "Videorama"
import "Controls"

local video = Videorama()
local controls = Controls()
controls:setTotalTime(video:getTotalTime())

local contextImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
contextImage:draw(0, 0)
video:setContext(contextImage)

local maskImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
playdate.graphics.pushContext(maskImage)
playdate.graphics.setColor(playdate.graphics.kColorWhite)
playdate.graphics.fillRoundRect(0, 0, 400, 240, 4)
playdate.graphics.popContext()

contextImage:setMaskImage(maskImage)

local isFFing = false

-- Setup the Crank Indicator
playdate.ui.crankIndicator:start()
playdate.setCrankSoundsDisabled(true)

-- Setup control handlers
local myInputHandlers = {
	AButtonDown = function()
		video:togglePause()
	end,
	upButtonDown = function()
		controls:toggle()
	end,
	downButtonDown = function()
		video:setRate(0)
	end,
	leftButtonDown = function()
		video:setRate(-1)
	end,
	rightButtonDown = function()
		video:setRate(1)
	end,
	cranked = function(change, acceleratedChange)
		if acceleratedChange > 1 then
			video:increaseRate()
		elseif acceleratedChange < -1 then
			video:decreaseRate()
		end

		if acceleratedChange > 10 then
			isFFing = true
		elseif acceleratedChange < -10 then
			isFFing = true
		else
			isFFing = false
		end
	end,
}
playdate.inputHandlers.push(myInputHandlers)

function playdate.update()

	playdate.timer.updateTimers() -- Required to use timers and crankIndicator

	video:update()

	if isFFing == true and video.isPlaying then
		local vcr = contextImage:vcrPauseFilterImage()
		vcr:draw(0,0)
	else
		contextImage:draw(0,0)
	end

	controls:setCurrentTime(video:getCurrentTime())
	controls:update()
end