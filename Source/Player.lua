import "Videorama"
import "Controls"

class('Player').extends()

function Player:init()

	Player.super.init(self)
	self.videorama = nil
	self.controls = Controls()
	-- self:setTotalTime()

	-- Input
	self:setInputHandlers()

	return self

end

function Player:setInputHandlers()

	playdate.inputHandlers.pop()
	playdate.inputHandlers.pop()
	local playerInputHandlers = {
		AButtonDown = function()
			self.videorama:togglePause()
		end,
		upButtonDown = function()
			self.controls:toggle()
		end,
		leftButtonDown = function()
			self.videorama:setRate(-1)
		end,
		rightButtonDown = function()
			self.videorama:setRate(1)
		end,
		cranked = function(change, acceleratedChange)
			if self.videorama:hasAudio() then
				if acceleratedChange > 1 then
					self.videorama:increaseRate()
				elseif acceleratedChange < -1 then
					self.videorama:decreaseRate()
				end
				self.controls:setRate(self.videorama:getDisplayRate())
			else
				self.videorama:setPaused(true)
				local tick = playdate.getCrankTicks(self.videorama.video:getFrameRate())
				local n = self.videorama.lastFrame + tick
				self.videorama:setFrame(n)
			end
		end,
	}
	playdate.inputHandlers.push(playerInputHandlers)

end

function Player:update()

	if self.videorama ~= nil then
		self.videorama:update()
		self:setCurrentTime()
		self.controls:update()
	end

end

function Player:loadAndPlay(videorama)

	self.videorama = videorama
	self.videorama:load()
	self:setTotalTime()
	self.videorama:setPaused(false)

end

function Player:unload()

	self.videorama:setPaused(true)
	self.videorama:unload()
	self.videorama = nil

end

function Player:setCurrentTime()

	self.controls:setCurrentTime(self.videorama:getCurrentTime())

end

function Player:setTotalTime()

	self.controls:setTotalTime(self.videorama:getTotalTime())

end