import "Scene"
import "Time"

class('Header').extends('Scene')

-- Header
--
function Header:init()

	Header.super.init(self)
	self:setSize(400, 40)
	self:initImage()
	self.time = Time()
	self.logo = self:initLogo()
	self:addSprite(self.time)
	self:addSprite(self.logo)
	return self

end

-- initImage()
function Header:initImage()

	local img = playdate.graphics.image.new(self.width, self.height)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRect(0, 0, self.width, self.height)
	playdate.graphics.popContext()
	self:setImage(img)

end

-- initLogo()
function Header:initLogo()

	local img = playdate.graphics.image.new("Assets/logo")
	local sprite = playdate.graphics.sprite.new(img)
	sprite:setZIndex(2)
	sprite:moveTo(200, 20)
	return sprite

end
