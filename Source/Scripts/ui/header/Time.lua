local pd <const> = playdate
local gfx <const> = pd.graphics

class('Time').extends(gfx.sprite)

-- Time
--
function Time:init()

	Time.super.init(self)
	local width = playorama.ui.fonts.medium:getTextWidth("00:00")
	local height = playorama.ui.fonts.medium:getHeight()
	self:setSize(width, height)
	self:moveTo(10 + (width / 2), 20)
	self:setZIndex(2)
	self:draw()
	self:add()
	return self

end

-- draw()
--
function Time:draw()

	local img = gfx.image.new(self.width, self.height)
	gfx.pushContext(img)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		local time <const> = playdate.getTime()
		local hours = padNumber(time.hour)
		local minutes = padNumber(time.minute)
		gfx.setFont(playorama.ui.fonts.medium)
		gfx.drawText(hours .. ":" .. minutes, 0, 0)
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	gfx.popContext()
	self:setImage(img)
	self.timer = playdate.timer.performAfterDelay(60000, function(this)
		this:draw()
	end, self)

end
