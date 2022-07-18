import "Videorama"
import "Controls"

class('Player').extends()

function Player:init()

	Player.super.init(self)
	self.videorama = nil
	self.controls = Controls()
	self:setInputHandlers()

	return self

end

function Player:setInputHandlers()

	playdate.inputHandlers.pop()
	playdate.inputHandlers.pop()
	local playerInputHandlers = {
		AButtonDown = function()
			self.videorama:togglePause()
			if self.videorama:isPlaying() then
				self:setRate()
				self.videorama:unmute()
			else
				self.controls:setRate("CRK!")
				self.videorama:mute()
			end
		end,
		upButtonDown = function()
			self.controls:toggle()
		end,
		upButtonUp = function()
			self.videorama:draw()
		end,
		leftButtonDown = function()
			self.videorama:toggleRate(-1)
			self:setRate()
		end,
		rightButtonDown = function()
			self.videorama:toggleRate(1)
			self:setRate()
		end,
		cranked = function(change, acceleratedChange)
			local framerate = self.videorama.video:getFrameRate()
			local tick = playdate.getCrankTicks(framerate)
			if self.videorama:isPlaying() then
				if tick == 1 then
					self.videorama:increaseRate()
				elseif tick == -1 then
					self.videorama:decreaseRate()
				end
				self:setRate()
			else
				local n = self.videorama.lastFrame + tick
				self.videorama:setFrame(n)
			end
		end,
	}
	playdate.inputHandlers.push(playerInputHandlers)

end

function Player:update()

	if self.videorama ~= nil then
		if self.videorama:isPlaying() then
			self.videorama:update()
		end
		self:setCurrentTime()
		self.controls:update()
	end

end

function Player:loadAndPlay(videorama)

	self.videorama = videorama
	self.videorama:load()
	self:setTotalTime()
	self.videorama:setPaused(false)
	self.controls:hideNow()
	self.controls:setRate(self.videorama:getDisplayRate())

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

function Player:setRate()

	self.controls:setRate(self.videorama:getDisplayRate())

end
