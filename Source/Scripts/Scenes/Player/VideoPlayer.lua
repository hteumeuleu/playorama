import "Scripts/Scenes/Scene"
import "Scripts/Scenes/Player/Videorama"

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
	-- Intro animation
	self:intro()
	return self

end

-- update()
--
function VideoPlayer:update()

	VideoPlayer.super.update(self)
	if self.videorama ~= nil and self.videorama:isPlaying() then
		-- self:setCurrentTimeText()
		-- self:setMutedIcon()
		-- self:setTotalTimeText()
		-- self:setRateText()
	end
	-- Intro animation
	if self._introAnimator ~= nil and not self._introAnimator:ended() then
		self._introSprite:setScale(self._introAnimator:currentValue())
	elseif self._introAnimator ~= nil and self._introAnimator:ended() then
		self:detachSprite(self._introSprite)
		self._introAnimator = nil
		self._introSprite = nil
	end

end

-- setInputHandlers()
--
function VideoPlayer:setInputHandlers()

	local myInputHandlers = {
		AButtonDown = function()
			self.videorama:togglePause()
			if self.videorama:isPlaying() then
				self.videorama:unmute()
			else
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
		downButtonDown = function()
			if self.videorama._animator == nil then
				local endValueY = 0
				if self.videorama.y == 0 then
					endValueY = 40
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
			-- if self.videorama:isPlaying() then
			-- 	self.videorama:toggleRate(-1)
			-- 	-- self:setRateText()
			-- else
			-- 	local n = self.videorama.lastFrame - 1
			-- 	self.videorama:setFrame(n)
			-- end
			if self.videorama._animator == nil then
				local endValueX = 0
				if self.videorama.x == 0 then
					endValueX = 40
				end
				local startValue = playdate.geometry.point.new(self.videorama.x, self.videorama.y)
				local endValue = playdate.geometry.point.new(endValueX, self.videorama.y)
				local easingFunction =  playdate.easingFunctions.outElastic
				local startTimeOffset = 0
				local animator = playdate.graphics.animator.new(500, startValue, endValue, easingFunction, startTimeOffset)
				self.videorama:setAnimator(animator)
			end
		end,
		rightButtonDown = function()
			if self.videorama:isPlaying() then
				self.videorama:toggleRate(1)
				-- self:setRateText()
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
				-- self:setRateText()
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
	app.menu:add()

end

-- intro()
--
-- Adds an iris like intro animation when opening the video player.
function VideoPlayer:intro()

	local mask = playdate.graphics.image.new(500, 500)
	playdate.graphics.pushContext(mask)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillCircleAtPoint(250, 250, 250)
	playdate.graphics.popContext()
	self._introSprite = playdate.graphics.sprite.new(mask)
	self._introSprite:moveTo(200, 120)
	self:attachSprite(self._introSprite)
	self._introSprite:setZIndex(300)
	-- Create animator
	self._introAnimator = playdate.graphics.animator.new(300, 1, 0)

end