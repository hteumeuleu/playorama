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

function Header:moveBy(x, y)

	Header.super.moveBy(self, x, y)
	self.battery:moveBy(x, y)
	self.time:moveBy(x, y)
	self.reel:moveBy(x, y)

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

function Header:setVisible(flag)

	Header.super.setVisible(self, flag)
	self.battery:setVisible(flag)
	self.time:setVisible(flag)
	self.reel:setVisible(flag)

end

function Header:draw()

	gfx.pushContext(self:getImage())
		local logo <const> = playdate.graphics.image.new("Assets/logo")
		logo:draw((400 - logo.width) / 2, 0)
	gfx.popContext()

end

function Header:toggle()

	local _, startY = gfx.getDrawOffset()
	local endY = startY
	local callback
	self:setVisible(true)
	if startY ~= 0 then
		endY = 0
		callback = function()
			self:setVisible(false)
		end
	else
		endY = 40
	end
	playorama.ui.setAnimator(pd.geometry.point.new(0, startY), pd.geometry.point.new(0, endY), callback)

end
