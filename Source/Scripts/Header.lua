import "Scene"
import "Time"
import "Logo"
import "Battery"

class('Header').extends('Scene')

-- Header
--
function Header:init()

	Header.super.init(self)
	self:setSize(400, 40)
	self.time = Time()
	self.logo = Logo()
	self.battery = Battery()
	self:attachSprite(self.battery)
	self:attachSprite(self.time)
	self:attachSprite(self.logo)
	return self

end
