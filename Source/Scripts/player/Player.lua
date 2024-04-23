local pd <const> = playdate
local gfx <const> = pd.graphics

class("Player").extends(gfx.sprite)

function Player:init(video)

	Player.super.init(self)
	playorama.ui.menu:remove()
	self:setImage(gfx.image.new(400, 240, gfx.kColorBlack))
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self.video = video
	self.video:setContext(self:getImage())
	self.video:play()
	self.controls = Controls(self.video)
	self:setInputHandlers()
	self:setZIndex(100)
	self:add()

end

function Player:update()

	Player.super.update(self)
	self.video:update()

end

function Player:remove()

	Player.super.remove(self)
	self.video:flush()
	self.controls:remove()
	pd.inputHandlers.pop()
	playorama.ui.menu:add()

end

function Player:pause()

	self.video:pause()

end

function Player:play()

	self.video:play()

end

function Player:setRate(rate)

	self.video:setRate(rate)

end

function Player:setInputHandlers()

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
			self.controls:toggle()
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
