local pd <const> = playdate
local gfx <const> = pd.graphics

class("VideoPlayer").extends(gfx.sprite)

function VideoPlayer:init(video)

	VideoPlayer.super.init(self)
	-- Hides the app menu and the header
	playorama.ui.menu:remove()
	playorama.ui.header:moveBy(0, -40)
	playorama.ui.header:setVisible(false)
	-- Init drawing context with a mask
	self.context = gfx.image.new(400, 240, gfx.kColorBlack)
	local mask <const> = gfx.image.new(400, 240, gfx.kColorBlack)
	gfx.pushContext(mask)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(0, 0, 400, 240, 8)
	gfx.popContext()
	self.context:setMaskImage(mask)
	-- Init sprite
	self:setImage(self.context)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self:setZIndex(100)
	-- Start video
	self.video = video
	self.video:setContext(self.context)
	self.video:play()
	-- Add widgets
	self.controls = Controls(self.video)
	self.header = playorama.ui.header
	self.effects = Effects(self.video)
	self.speed = Speed(self.video)
	-- Add input handlers
	self:setInputHandlers()
	-- Add the sprite
	self:add()
	-- Appearance animation
	local animator <const> = gfx.animator.new(
		300,
		pd.geometry.point.new(200, 0),
		pd.geometry.point.new(0, 0),
		pd.easingFunctions.linear
	)
	self:setAnimator(animator)

end

function VideoPlayer:update()

	VideoPlayer.super.update(self)
	self.video:update()
	gfx.pushContext(self.context)
		self.video:draw()
	gfx.popContext()

end

function VideoPlayer:remove()

	VideoPlayer.super.remove(self)
	self.video:flush()
	self.controls:remove()
	self.effects:remove()
	pd.inputHandlers.pop()
	playorama.ui.menu:add()
	gfx.setDrawOffset(0, 0)
	pd.display.setRefreshRate(50)
	self.header:moveBy(0, 40)
	self.header:setVisible(true)
	collectgarbage("collect")

end

function VideoPlayer:pause()

	self.video:pause()

end

function VideoPlayer:play()

	self.video:play()

end

function VideoPlayer:setRate(rate)

	self.video:setRate(rate)

end

function VideoPlayer:setInputHandlers()

	local playerInputHandlers = {
		AButtonDown = function()
			if self.video:isPlaying() then
				self:pause()
			else
				self:play()
			end
		end,
		BButtonUp = function()
			self:remove()
		end,
		upButtonDown = function()
			self.header:toggle()
		end,
		downButtonDown = function()
			self.controls:toggle()
		end,
		leftButtonDown = function()
			self.effects:toggle()
		end,
		rightButtonDown = function()
			self.speed:toggle()
		end,
		cranked = function(change, acceleratedChange)
			local framerate = self.video.video:getFrameRate()
			local tick = pd.getCrankTicks(framerate)
			if self.video:isPlaying() then
				if tick == 1 then
					self:setRate(self.video:getRate() + playorama.player.kPlaybackRateStep)
				elseif tick == -1 then
					self:setRate(self.video:getRate() - playorama.player.kPlaybackRateStep)
				end
			else
				-- previousTimeElapsed = rateTimeElapsed or 0
				-- rateTimeElapsed = playdate.getCurrentTimeMilliseconds()
				-- if previousTimeElapsed == 0 then
				-- 	previousTimeElapsed = rateTimeElapsed
				-- end
				-- local elapsed = rateTimeElapsed - previousTimeElapsed
				-- print("elapsed", elapsed)
				-- rateValueTimer = playdate.timer.new(1/framerate, video:getRate())
				-- -- video:setRate(video:getRate() + playorama.player.kPlaybackRateStep)
				-- print(tick)
				local n = self.video.lastFrame + tick
				self.video:renderFrame(n)
			end
		end,
	}
	pd.inputHandlers.push(playerInputHandlers, true)

end
