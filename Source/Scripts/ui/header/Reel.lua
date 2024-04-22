local pd <const> = playdate
local gfx <const> = pd.graphics
local imagetable <const> = gfx.imagetable.new("Assets/reel")

class('Reel').extends(gfx.sprite)

-- Reel
--
function Reel:init()

	Reel.super.init(self)
	self.n = 1
	self:setImage(imagetable:getImage(self.n))
	self:moveTo(196, 22)
	self:setZIndex(2)
	self:add()
	return self

end

function Reel:next()

	if self.n == imagetable:getLength() then
		self.n = 1
	else
		self.n += 1
	end
	self:setImage(imagetable:getImage(self.n))

end

function Reel:previous()

	if self.n == 1 then
		self.n = imagetable:getLength()
	else
		self.n -= 1
	end
	self:setImage(imagetable:getImage(self.n))

end
