import "Scripts/ui/Widget"

local pd <const> = playdate
local gfx <const> = pd.graphics
local imagetable <const> = gfx.imagetable.new("Assets/tortoise-hare")
local tortoise <const> = imagetable:getImage(1)
local hare <const> = imagetable:getImage(2)
local heldButtonInitialDelay <const> = 300 -- milliseconds
local heldButtonSecondaryDelay <const> = 50 -- milliseconds
local heldButtonCurrentDelay = heldButtonInitialDelay

class("Speed").extends(Widget)

function Speed:init(video)

	self.video = video
	self.drawOffset = pd.geometry.point.new(-40, 0)
	Speed.super.init(self, 400, 0, 40, 240)

end

function Speed:setInputHandlers()

	local playerInputHandlers = {
		BButtonUp = function()
			self:toggle()
		end,
		upButtonDown = function()
			self:increase()
		end,
		upButtonUp = function()
			self:clearTimer()
			heldButtonCurrentDelay = heldButtonInitialDelay
		end,
		downButtonDown = function()
			self:decrease()
		end,
		downButtonUp = function()
			self:clearTimer()
			heldButtonCurrentDelay = heldButtonInitialDelay
		end,
		leftButtonDown = function()
			self:toggle()
		end,
		rightButtonDown = function()
			self:toggle()
		end,
		cranked = function(change, acceleratedChange)
			if change > 0 then
				self.video:increaseRate()
			elseif change < 0 then
				self.video:decreaseRate()
			end
		end,
	}
	pd.inputHandlers.push(playerInputHandlers, true)

end

function Speed:clearTimer()

	if self.heldButtonTimer ~= nil then
		self.heldButtonTimer:remove()
		self.heldButtonTimer = nil
	end

end

function Speed:setTimer(callback)

	self:clearTimer()
	self.heldButtonTimer = pd.timer.performAfterDelay(heldButtonCurrentDelay, function()
		heldButtonCurrentDelay = heldButtonSecondaryDelay
		callback()
	end)

end

function Speed:increase()

	self.video:increaseRate()
	self:setTimer(function()
		self:increase()
	end)

end

function Speed:decrease()

	self.video:decreaseRate()
	self:setTimer(function()
		self:decrease()
	end)

end

-- draw()
--
function Speed:draw()

	if self._previousRate ~= self.video:getRate() then
		local img <const> = self:getImage()
		gfx.pushContext(img)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRect(0, 0, self.width, self.height)
			hare:draw(9, 9)
			tortoise:draw(9, 240 - 22 - 9 - 28)
			self:_drawScrobbleBar()
			self:_drawRateBox()
		gfx.popContext()
		img:draw(self.x, self.y)
		self._previousRate = self.video:getRate()
	end

end


-- _drawScrobbleBar()
--
-- Draws the speed scrobbling bar.
function Speed:_drawScrobbleBar()

	local w <const> = 4
	local h <const> = self.height - 80 - 32
	local x <const> = (40 - 4) / 2
	local y <const> = 44
	local r <const> = 4
	gfx.setLineWidth(0)
	-- Background shape
	gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	gfx.fillRoundRect(x, y, w, h, r)
	-- Scrobble shape
	gfx.setColor(gfx.kColorWhite)
	local scrobbleRadius <const> = 16
	local scrobbleX <const> = x + (w/2) - (scrobbleRadius/2)
	local scrobbleY <const> = self:_getScrobbleY(playdate.geometry.rect.new(x, y, w, h)) - (scrobbleRadius/2)
	gfx.fillCircleInRect(scrobbleX, scrobbleY, scrobbleRadius, scrobbleRadius)

end


-- _getScrobbleWidth(rect)
--
function Speed:_getScrobbleY(rect)

	local yMin = rect.y
	local yMax = rect.y + rect.height
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
