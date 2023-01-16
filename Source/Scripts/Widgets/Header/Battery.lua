class('Battery').extends('Icon')

-- Battery
--
function Battery:init()

	Battery.super.init(self, 380, 20, IconBattery100, true)
	self:updateIcon()
	return self

end

-- update()
function Battery:updateIcon()

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

end