import "Scripts/Scenes/Scene"
import "Scripts/Common/Icon"
import "Scripts/Widgets/Header/Time"
import "Scripts/Widgets/Header/Logo"
import "Scripts/Widgets/Header/Battery"
import "Scripts/Widgets/Header/Reel"

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
	self:add()
	return self

end

function Header:update()

	Header.super.update(self)
	if self.logo.animator ~= nil and self.logo.animator:ended() then
		self.logo.animator = nil
		self.reel = Reel()
		self:attachSprite(self.reel)
	end
	if self.reel ~= nil then
		local change = playdate.getCrankChange()
		if change < 0 then
			self.reel:next()
		elseif change > 0 then
			self.reel:previous()
		end
	end

end
