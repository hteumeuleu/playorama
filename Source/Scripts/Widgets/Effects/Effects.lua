import "Scripts/Widgets/Widget"
import "Scripts/Common/Icon"

class('Effects').extends('Widget')

local icons <const> = playdate.graphics.imagetable.new('Images/memory')

-- Effects
--
function Effects:init()

	Effects.super.init(self)
	self:setSize(40, 240)
	self:setImage(self:_getBackgroundImage())
	self:_drawIcons()
	self:moveTo(0, 0)
	return self

end

-- _drawIcons
--
-- Private function
function Effects:_drawIcons()

	local img = self:getImage()
	playdate.graphics.pushContext(img)
		local position = playdate.geometry.point.new((self.width - 22) / 2, 10)
		for i=1, 14, 2 do
			local icon = icons:getImage(i)
			icon:setInverted(true)
			icon:draw(position.x, position.y)
			position.y += 22 + 10
		end
	playdate.graphics.popContext()
	self:setImage(img)

end