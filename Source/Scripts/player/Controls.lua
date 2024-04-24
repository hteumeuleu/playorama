local pd <const> = playdate
local gfx <const> = pd.graphics
local kPadding <const> = 8

class("Controls").extends(gfx.sprite)

function Controls:init(video)

	Controls.super.init(self)
	self.video = video
	self._leftOffset = kPadding
	self._rightOffset = kPadding
	self:setImage(gfx.image.new(400, 40, gfx.kColorClear))
	self:setCenter(0, 0)
	self:moveTo(0, 240)
	self:setZIndex(1000)
	self:draw()
	self:setVisible(false)
	self:add()

end

function Controls:update()

	Controls.super.update(self)
	self._leftOffset = kPadding
	self._rightOffset = kPadding
	self:draw()

end

function Controls:toggle()

	local _, startY = gfx.getDrawOffset()
	local endY = startY
	local callback
	if startY ~= 0 then
		endY = 0
		callback = function()
			self:setVisible(false)
		end
	else
		endY = -40
		self:setVisible(true)
	end
	playorama.ui.setAnimator(pd.geometry.point.new(0, startY), pd.geometry.point.new(0, endY), callback)

end


-- draw()
--
function Controls:draw()

	local img <const> = self:getImage()
	gfx.pushContext(img)
		self:_drawBackgroundImage()
		self:_drawCurrentTime()
		self:_drawTotalTime()
		self:_drawScrobbleBar()
	gfx.popContext()
	img:draw(self.x, self.y)

end


-- _drawBackgroundImage()
--
-- Draws the black background image.
function Controls:_drawBackgroundImage()

	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0, 0, self.width, self.height)

end

-- _drawCurrentTime()
--
function Controls:_drawCurrentTime()

	local x <const> = self._leftOffset
	local y <const> = math.ceil((self.height - playorama.ui.fonts.medium:getHeight()) / 2)
	local currentTimeString <const> = formatTime(self.video:getOffset())
	local w <const> = playorama.ui.fonts.medium:getTextWidth(currentTimeString)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText(currentTimeString, x, y)
	self._leftOffset += kPadding + w

end

-- _drawTotalTime()
--
function Controls:_drawTotalTime()

	local y <const> = math.ceil((self.height - playorama.ui.fonts.medium:getHeight()) / 2)
	local totalTimeString <const> = formatTime(self.video:getLength())
	local w <const> = playorama.ui.fonts.medium:getTextWidth(totalTimeString)
	local x <const> = self.width - self._rightOffset - w
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextAligned(totalTimeString, x, y, kTextAlignment.left)
	self._rightOffset += kPadding + w

end

-- _drawScrobbleBar()
--
-- Draws the black background image.
function Controls:_drawScrobbleBar()

	local w <const> = self.width - self._leftOffset - self._rightOffset
	local h <const> = 4
	local x <const> = self._leftOffset
	local y <const> = math.floor((self.height - h) / 2)
	local r <const> = 4
	gfx.setLineWidth(0)
	-- Background shape
	gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	gfx.fillRoundRect(x, y, w, h, r)
	-- Current shape
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(x, y, self:_getScrobbleWidth(w), h, r)

end



-- _getScrobbleWidth(maxBarWidth)
--
function Controls:_getScrobbleWidth(maxBarWidth)

	local xMin = 0
	local xMax = maxBarWidth
	local x = math.floor((self.video:getOffset() * xMax) / self.video:getLength())
	if x > xMax then
		x = xMax
	end
	if x < xMin then
		x = xMin
	end
	return x

end
