import "Scripts/Scenes/Scene"
import "Scripts/Common/Icon"
import "Scripts/Widgets/Header/Time"
import "Scripts/Widgets/Header/Logo"
import "Scripts/Widgets/Header/Battery"

class('Header').extends('Scene')

-- Header
--
function Header:init()

	Header.super.init(self)
	self:setSize(400, 40)
	self:setZIndex(0)
	self.time = Time()
	self.logo = Logo()
	self.battery = Battery()
	self:attachSprite(self.battery)
	self:attachSprite(self.time)
	self:attachSprite(self.logo)
	return self

end
