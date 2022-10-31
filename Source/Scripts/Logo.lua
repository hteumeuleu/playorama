class('Logo').extends(playdate.graphics.sprite)

-- Logo
--
function Logo:init()

	Logo.super.init(self)
	local img = playdate.graphics.image.new("Assets/logo")
	self:setImage(img)
	self:setZIndex(2)
	self:moveTo(200, 20)
	return self

end