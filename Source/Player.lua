import "Videorama"
import "Controls"

class('Player').extends()

function Player:init()

	Player.super.init(self)
	self.videorama = Videorama()
	self.controls = Controls()
	self.controls:show() -- for debug
	self:setTotalTime()
	self.isFFing = false -- Not sure if still useful

	-- Context
	self.context = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	self.context:draw(0,0)
	self.videorama:setContext(self.context)

	-- Add mask
	local mask = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	playdate.graphics.pushContext(mask)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(0, 0, 400, 240, 16)
	playdate.graphics.popContext()
	self.context:setMaskImage(mask)

	-- Input
	self:setInputHandlers()

	return self

end

function Player:setInputHandlers()

	playdate.inputHandlers.pop()
	local playerInputHandlers = {
		AButtonDown = function()
			self.videorama:togglePause()
		end,
		BButtonDown = function()
			self.videorama:setPaused(true)
			-- gameState:set(kMenuState)
			-- initMenuState()
		end,
		upButtonDown = function()
			self.controls:toggle()
		end,
		downButtonDown = function()
			self.videorama:setPaused(true)
		end,
		leftButtonDown = function()
			self.videorama:setRate(-1)
		end,
		rightButtonDown = function()
			self.videorama:setRate(1)
		end,
		cranked = function(change, acceleratedChange)
			if acceleratedChange > 1 then
				self.videorama:increaseRate()
			elseif acceleratedChange < -1 then
				self.videorama:decreaseRate()
			end

			if acceleratedChange > 10 then
				self.isFFing = true
			elseif acceleratedChange < -10 then
				self.isFFing = true
			else
				self.isFFing = false
			end
		end,
	}
	playdate.inputHandlers.push(playerInputHandlers, true)

end

function Player:update()

	self.videorama:update()

	if self.isFFing == true and self.videorama.isPlaying then
		local contextWithVCRFilter = self.context:vcrPauseFilterImage()
		contextWithVCRFilter:draw(0,0)
	else
		self.context:draw(0,0)
	end

	self:setCurrentTime()
	self.controls:update()

end

function Player:setVideo(videorama)

	self.videorama = videorama

end

function Player:setCurrentTime()

	self.controls:setCurrentTime(self.videorama:getCurrentTime())

end

function Player:setTotalTime()

	self.controls:setTotalTime(self.videorama:getTotalTime())

end