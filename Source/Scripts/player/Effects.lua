import "Scripts/ui/Widget"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Effects").extends(Widget)

function Effects:init(video)

	self.video = video
	self.drawOffset = pd.geometry.point.new(40, 0)
	Effects.super.init(self, -40, 0, 40, 240)

end



function Effects:setInputHandlers()

	local playerInputHandlers = {
		BButtonUp = function()
			self:toggle()
		end,
		upButtonDown = function()
			print("upButtonDown")
		end,
		downButtonDown = function()
			print("downButtonDown")
		end,
		leftButtonDown = function()
			self:toggle()
		end,
		rightButtonDown = function()
			self:toggle()
		end,
		cranked = function(change, acceleratedChange)
		end,
	}
	pd.inputHandlers.push(playerInputHandlers, true)

end


-- draw()
--
function Effects:draw()

	local img <const> = self:getImage()
	gfx.pushContext(img)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(0, 0, self.width, self.height, 8)
	gfx.popContext()
	img:draw(self.x, self.y)

end
