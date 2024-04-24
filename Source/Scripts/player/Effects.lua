local pd <const> = playdate
local gfx <const> = pd.graphics

class("Effects").extends(gfx.sprite)

function Effects:init(video)

	Effects.super.init(self)
	self.video = video
	self:setImage(gfx.image.new(40, 240, gfx.kColorClear))
	self:setCenter(0, 0)
	self:moveTo(-40, 0)
	self:setZIndex(1000)
	self:draw()
	self:setVisible(false)
	self:add()

end

function Effects:update()

	Effects.super.update(self)
	self:draw()

end

function Effects:toggle()

	local startX, _ = gfx.getDrawOffset()
	local endX = startX
	local callback
	if startX ~= 0 then
		endX = 0
		callback = function()
			self:setVisible(false)
		end
	else
		endX = 40
		self:setVisible(true)
	end
	playorama.ui.setAnimator(pd.geometry.point.new(startX, 0), pd.geometry.point.new(endX, 0), callback)

end


-- draw()
--
function Effects:draw()

	local img <const> = self:getImage()
	gfx.pushContext(img)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(0, 0, 40, 240, 8)
	gfx.popContext()
	img:draw(self.x, self.y)

end
