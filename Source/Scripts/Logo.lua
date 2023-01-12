class('Logo').extends(playdate.graphics.sprite)

-- Logo
--
function Logo:init()

	Logo.super.init(self)
	local img = playdate.graphics.image.new("Assets/logo")
	self:setImage(img)
	self:moveTo(200, 20)
	self:animate()
	return self

end

function Logo:remove()

	Logo.super.remove(self)
	if self.shadow ~= nil then
		self.shadow:remove()
	end

end

function Logo:animate()

	self.shadow = self:copy()
	self.shadow:setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	self.shadow:add()
	local startValue = playdate.geometry.point.new(self.x, self.y)
	local endValue = startValue:offsetBy(4, -6)
	local easingFunction =  playdate.easingFunctions.inCubic
	local startTimeOffset = 100
	local animator = playdate.graphics.animator.new(300, startValue, endValue, easingFunction, startTimeOffset)
	animator.reverses = true
	self:setAnimator(animator)

end