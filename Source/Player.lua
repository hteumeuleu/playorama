import "Videorama"
import "Controls"

class('Player').extends()

-- Player
--
-- Combines a `Videorama` object and a `Controls` object
-- to form a controllable video player.
function Player:init()

	Player.super.init(self)

	self.controls = Controls()
	self.controls:setTimerUpdateCallback(
		function(x, y, width, height)
			self:drawingCallback(x, y, width, height)
		end
	)

	return self

end

-- drawingCallback()
--
function Player:drawingCallback(x, y, width, height)
	self.isBackgroundDrawing = true
	playdate.graphics.setClipRect(x, y, width, height)
		self.videorama:update()
	playdate.graphics.clearClipRect()
	self.isBackgroundDrawing = false
end

-- update(videorama)
--
-- Method invoked on every cycle to update what needs to be updated.
-- (Mainly: trigger the video frame update and update the controls)
function Player:update()

	if self.videorama ~= nil then
		if self.videorama:isPlaying() or self.isBackgroundDrawing then
			self.videorama:update()
		end
		self:setCurrentTimeText()
		self.controls:update()
	end

end

-- setInputHandlers()
--
-- Set input handlers used during playback.
function Player:setInputHandlers()

	playdate.inputHandlers.pop() -- Menu.lua
	playdate.inputHandlers.pop() -- main.lua
	local playerInputHandlers = {
		AButtonDown = function()
			self.videorama:togglePause()
			if self.videorama:isPlaying() then
				self.controls:setPaused(false)
				self:setRateText()
				self.videorama:unmute()
			else
				self.controls:setPaused(true)
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
			if self.videorama:isPlaying() then
				self.videorama:toggleRate(-1)
				self:setRateText()
			end
		end,
		rightButtonDown = function()
			if self.videorama:isPlaying() then
				self.videorama:toggleRate(1)
				self:setRateText()
			end
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
				self:setRateText()
			else
				local n = self.videorama.lastFrame + tick
				self.videorama:setFrame(n)
			end
		end,
	}
	playdate.inputHandlers.push(playerInputHandlers)

end

-- setVideorama(videorama)
--
-- Sets the videorama object to be played.
function Player:setVideorama(videorama)

	-- Video
	self.videorama = videorama
	self.videorama:load()
	self.videorama:play()
	-- Controls
	self.controls:hideNow()
	self:setMutedIcon()
	self:setTotalTimeText()
	self:setRateText()

end

-- unload()
--
-- Stops and unloads the videorama object to free up memory.
function Player:unload()

	self.videorama:setPaused(true)
	self.videorama:unload()
	self.videorama = nil

end

-- setCurrentTimeText()
--
-- Helper method to set the current time to display inside the controls.
function Player:setCurrentTimeText()

	self.controls:setCurrentTime(self.videorama:getCurrentTime())

end

-- setTotalTimeText()
--
-- Helper method to set the total time to display inside the controls.
function Player:setTotalTimeText()

	self.controls:setTotalTime(self.videorama:getTotalTime())

end


-- setRateText()
--
-- Helper method to set the rate playback to display inside the controls.
function Player:setRateText()

	self.controls:setRate(self.videorama:getDisplayRate())

end

-- setRateText()
--
-- Helper method to set a boolean that determines if the “no audio available” icon should display inside the controls.
function Player:setMutedIcon()

	self.controls:setHasSound(self.videorama:hasAudio())

end
