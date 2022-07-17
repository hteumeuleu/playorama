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
		end,
		upButtonDown = function()
			self.controls:toggle()
		end,
		leftButtonDown = function()
			self.videorama:toggleRate(-1)
			self.controls:setRate(self.videorama:getDisplayRate())
		end,
		rightButtonDown = function()
			self.videorama:toggleRate(1)
			self.controls:setRate(self.videorama:getDisplayRate())
		end,
		cranked = function(change, acceleratedChange)
			if self.videorama:isPlaying() then
				if acceleratedChange > 1 then
					self.videorama:increaseRate()
				elseif acceleratedChange < -1 then
					self.videorama:decreaseRate()
				end
				self.controls:setRate(self.videorama:getDisplayRate())
			else
				-- local framerate = self.videorama.video:getFrameRate()
				-- local tick = playdate.getCrankTicks(framerate)
				-- local n = self.videorama.lastFrame + tick
				-- print(tick, n)
				-- self.videorama:setFrame(n)
				-- TODO ☝️ Y u no work?!?
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

function Player:getTimeSinceLastTick()

	local now = playdate.getCurrentTimeMilliseconds()
	if self.timeSinceLastTick ~= nil then
		return now - self.timeSinceLastTick
	else
		return 1000
	end

end

function Player:resetTimeSinceLastTick()

	self.timeSinceLastTick = playdate.getCurrentTimeMilliseconds()

end
