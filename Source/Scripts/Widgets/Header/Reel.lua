class('Reel').extends(playdate.graphics.sprite)

-- Reel
--
function Reel:init()

	Reel.super.init(self)
	self.n = 1
	self.imagetable = playdate.graphics.imagetable.new("Assets/reel")
	self:setImage(self.imagetable:getImage(self.n))
	self:moveTo(196, 22)
	return self

end

function Reel:next()

	if self.n == self.imagetable:getLength() then
		self.n = 1
	else
		self.n += 1
	end
	self:setImage(self.imagetable:getImage(self.n))

end

function Reel:previous()

	if self.n == 1 then
		self.n = self.imagetable:getLength()
	else
		self.n -= 1
	end
	self:setImage(self.imagetable:getImage(self.n))

end