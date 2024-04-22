local pd <const> = playdate
local gfx <const> = pd.graphics

class('Battery').extends('Icon')

-- Battery
--
function Battery:init()

	Battery.super.init(self, 380, 20, IconBattery100, true)
	self:setUpdatesEnabled(false)
	self:update()
	self:setZIndex(2)
	self:add()
	return self

end

-- update()
function Battery:update()

	Battery.super.update(self)
	local level = playdate.getBatteryPercentage()
	local iconIndex = IconBattery100
	if level <= 90 and level >= 65 then
		iconIndex = IconBattery75
	elseif level < 65 and level >= 40 then
		iconIndex = IconBattery50
	elseif level < 40 and level >= 15 then
		iconIndex = IconBattery25
	elseif level < 15 then
		iconIndex = IconBattery0
	end
	self:setIcon(iconIndex)
	self.timer = playdate.timer.performAfterDelay(600000, function(this)
		self:update()
	end, self)

end
