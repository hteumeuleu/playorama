import "Scripts/Scenes/Scene"
import "Scripts/Scenes/Player/Videorama"
import "Scripts/Widgets/Effects/Effects"

class('VideoPlayer').extends('Scene')

-- VideoPlayer
--
function VideoPlayer:init(libraryItem)

	VideoPlayer.super.init(self)
	self.libraryItem = libraryItem
	self:setInputHandlers()
	self:setZIndex(200)
	self:add()
	-- Widgets
	self.widgets = {}
	self.widgets.effects = Effects()
	self.widgets.effects:setVisible(false)
	self:attachSprite(self.widgets.effects)
	app.header:setVisible(false)
	-- Video
	self.videorama = self.libraryItem.objectorama
	self:attachSprite(self.videorama)
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
					endValueY = 40
					app.header:setVisible(true)
				end
				local startValue = playdate.geometry.point.new(self.videorama.x, self.videorama.y)
				local endValue = playdate.geometry.point.new(0, endValueY)
				local easingFunction =  playdate.easingFunctions.outElastic
				local startTimeOffset = 0
				self.videorama.animator = playdate.graphics.animator.new(500, startValue, endValue, easingFunction, startTimeOffset)
				self.videorama:setAnimator(self.videorama.animator)
				if endValueY == 0 then
					self.videorama.animatorCallback = function()
						app.header:setVisible(false)
					end
				end
			end
		end,
		downButtonDown = function()
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
					app.header:setVisible(false)
					self.widgets.effects:setVisible(true)
				end
				local startValue = playdate.geometry.point.new(self.videorama.x, self.videorama.y)
				local endValue = playdate.geometry.point.new(endValueX, self.videorama.y)
				local easingFunction =  playdate.easingFunctions.outElastic
				local startTimeOffset = 0
				self.videorama.animator = playdate.graphics.animator.new(500, startValue, endValue, easingFunction, startTimeOffset)
				self.videorama:setAnimator(self.videorama.animator)
				if endValueX == 0 then
					self.videorama.animatorCallback = function()
						self.widgets.effects:setVisible(false)
					end
				end
			end
			-- else
			-- 	if not self.mosaic then
			-- 		self.mosaic = playdate.geometry.point.new(0, 0)
			-- 	end
			-- 	if self.mosaic.x == 0 then
			-- 		self.mosaic = playdate.geometry.point.new(1, 1)
			-- 	elseif self.mosaic.x == 1 then
			-- 		self.mosaic = playdate.geometry.point.new(2, 2)
			-- 	elseif self.mosaic.x == 2 then
			-- 		self.mosaic = playdate.geometry.point.new(3, 3)
			-- 	else
			-- 		self.videorama:mute()
			-- 		self.mosaic = playdate.geometry.point.new(0, 0)
			-- 	end
			-- 	playdate.display.setMosaic(self.mosaic.x, self.mosaic.y)
			-- end
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

	self.videorama:setPaused(true)
	self:remove()
	playdate.inputHandlers.pop()
	app.menu:add()
	app.header:setVisible(true)

end