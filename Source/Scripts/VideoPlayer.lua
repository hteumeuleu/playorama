import "Scripts/Scene"
import "Scripts/Videorama"
import "Scripts/Controls"

class('VideoPlayer').extends('Scene')

-- VideoPlayer
--
function VideoPlayer:init(libraryItem)

	VideoPlayer.super.init(self)
	self.libraryItem = libraryItem
	self:setInputHandlers()
	self:setImage(playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack))
	self:setZIndex(200)
	self:add()
	-- Video
	self.videorama = self.libraryItem.objectorama
	self:attachSprite(self.videorama)
	self.videorama:setZIndex(202)
	-- Controls
	self.controls = Controls()
	self:attachSprite(self.controls)
	self.controls:setZIndex(201)
	self:setMutedIcon()
	self:setTotalTimeText()
	self:setRateText()
	return self

end

-- update()
--
function VideoPlayer:update()

	VideoPlayer.super.update(self)
	if self.videorama ~= nil and self.videorama:isPlaying() then
		self:setCurrentTimeText()
		self:setMutedIcon()
		self:setTotalTimeText()
		self:setRateText()
	end

end

-- setInputHandlers()
--
function VideoPlayer:setInputHandlers()

	local myInputHandlers = {
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
		BButtonUp = function()
			self:close()
		end,
		upButtonDown = function()
			if self.videorama._animator == nil then
				local endValueY = 0
				if self.videorama.y == 0 then
					endValueY = -40
				end
				local startValue = playdate.geometry.point.new(self.videorama.x, self.videorama.y)
				local endValue = playdate.geometry.point.new(self.videorama.x, endValueY)
				local easingFunction =  playdate.easingFunctions.outElastic
				local startTimeOffset = 0
				local animator = playdate.graphics.animator.new(500, startValue, endValue, easingFunction, startTimeOffset)
				self.videorama:setAnimator(animator)
			end
		end,
		leftButtonDown = function()
			if self.videorama:isPlaying() then
				self.videorama:toggleRate(-1)
				self:setRateText()
			else
				local n = self.videorama.lastFrame - 1
				self.videorama:setFrame(n)
			end
		end,
		rightButtonDown = function()
			if self.videorama:isPlaying() then
				self.videorama:toggleRate(1)
				self:setRateText()
			else
				local n = self.videorama.lastFrame + 1
				self.videorama:setFrame(n)
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
	playdate.inputHandlers.push(myInputHandlers, true)

end

-- close()
--
function VideoPlayer:close()

	self:remove()
	playdate.inputHandlers.pop()
	local menu = getMenu()
	menu:add()

end

-- setCurrentTimeText()
--
-- Helper method to set the current time to display inside the controls.
function VideoPlayer:setCurrentTimeText()

	self.controls:setCurrentTime(self.videorama:getCurrentTime())

end

-- setTotalTimeText()
--
-- Helper method to set the total time to display inside the controls.
function VideoPlayer:setTotalTimeText()

	self.controls:setTotalTime(self.videorama:getTotalTime())

end

-- setRateText()
--
-- Helper method to set the rate playback to display inside the controls.
function VideoPlayer:setRateText()

	self.controls:setRate(self.videorama:getDisplayRate())

end

-- setMutedIcon()
--
-- Helper method to set a boolean that determines if the “no audio available” icon should display inside the controls.
function VideoPlayer:setMutedIcon()

	print("setMutedIcon", self.videorama:hasAudio())
	self.controls:setHasSound(self.videorama:hasAudio())

end