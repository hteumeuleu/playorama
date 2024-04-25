local pd <const> = playdate
local gfx <const> = pd.graphics
local imagetable <const> = gfx.imagetable.new("Assets/tortoise-hare")
local tortoise <const> = imagetable:getImage(1)
local hare <const> = imagetable:getImage(2)

class("Speed").extends(gfx.sprite)

function Speed:init(video)

	Speed.super.init(self)
	self.video = video
	self:setImage(gfx.image.new(40, 240, gfx.kColorClear))
	self:setCenter(0, 0)
	self:moveTo(400, 0)
	self:setZIndex(1000)
	self:draw()
	self:setVisible(false)
	self:add()

end

function Speed:update()

	Speed.super.update(self)
	self:draw()

end

function Speed:toggle()

	local startX, _ = gfx.getDrawOffset()
	local endX = startX
	local callback
	if startX ~= 0 then
		endX = 0
		callback = function()
			self:setVisible(false)
		end
		pd.inputHandlers.pop()
	else
		endX = -40
		self:setVisible(true)
		self:setInputHandlers()
	end
	playorama.ui.setAnimator(pd.geometry.point.new(startX, 0), pd.geometry.point.new(endX, 0), callback)

end

function Speed:setInputHandlers()

	local playerInputHandlers = {
		BButtonUp = function()
			self:toggle()
		end,
		upButtonDown = function()
			print("upButtonDown")
		end,
		downButtonDown = function()
			print("downButtonDown")
		end,
		leftButtonDown = function()
			self:toggle()
		end,
		rightButtonDown = function()
			self:toggle()
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


-- draw()
--
function Speed:draw()

	local img <const> = self:getImage()
	gfx.pushContext(img)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(0, 0, 40, 240)
		hare:draw(9, 9)
		tortoise:draw(9, 240 - 22 - 9 - 28)
		self:_drawScrobbleBar()
		self:_drawRateBox()
	gfx.popContext()
	img:draw(self.x, self.y)

end


-- _drawScrobbleBar()
--
-- Draws the speed scrobbling bar.
function Speed:_drawScrobbleBar()

	local w <const> = 4
	local h <const> = self.height - 80 - 28
	local x <const> = (40 - 4) / 2
	local y <const> = 40
	local r <const> = 4
	gfx.setLineWidth(0)
	-- Background shape
	gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	gfx.fillRoundRect(x, y, w, h, r)
	-- Current shape
	gfx.setColor(gfx.kColorWhite)
	local scrobbleY <const> = self:_getScrobbleY(playdate.geometry.rect.new(x, y, w, h))
	gfx.fillCircleInRect(x-6, scrobbleY, w+12, w+12)

end


-- _getScrobbleWidth(rect)
--
function Speed:_getScrobbleY(rect)

	local yMin = rect.y
	local yMax = rect.y + rect.height - 12
	local y = math.floor(map(self.video:getRate(), playorama.player.kMinPlaybackRate, playorama.player.kMaxPlaybackRate, yMax, yMin))
	if y > yMax then
		y = yMax
	end
	if y < yMin then
		y = yMin
	end
	return y

end

function Speed:_drawRateBox()

	local w <const> = 32
	local h <const> = 24
	local x <const> = 4
	local y <const> = self.height - h - 4
	local textY = y + math.floor((h - playorama.ui.fonts.medium:getHeight()) / 2)
	local roundedRateValue = math.floor(self.video:getRate() * 10 + 0.5) / 10
	local text = roundedRateValue .. "x"
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(x, y, w, h, 4)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeFillBlack)
		gfx.drawTextInRect(text, x, textY, w, h, nil, nil, kTextAlignment.center)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)


end
