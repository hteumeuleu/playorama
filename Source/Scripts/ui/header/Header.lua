import "Scripts/ui/header/Battery"
import "Scripts/ui/header/Time"
import "Scripts/ui/header/Reel"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Header").extends(gfx.sprite)

function Header:init()

	Header.super.init(self)
	self:setImage(gfx.image.new(400, 40, gfx.kColorClear))
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self:draw()
	self.battery = Battery()
	self.time = Time()
	self.reel = Reel()
	self:add()

end

function Header:update()

	Header.super.update(self)
	if self.reel ~= nil then
		local change <const> = playdate.getCrankChange()
		if change < 0 then
			self.reel:next()
		elseif change > 0 then
			self.reel:previous()
		end
	end

end

function Header:remove()

	Header.super.remove(self)
	self.battery:remove()
	self.time:remove()
	self.reel:remove()

end

function Header:draw()

	gfx.pushContext(self:getImage())
		local logo <const> = playdate.graphics.image.new("Assets/logo")
		logo:draw((400 - logo.width) / 2, 0)
	gfx.popContext()

end
