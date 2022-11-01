import "Scene"
import "Header"
import "ListView"

class('MenuScene').extends('Scene')

-- MenuScene
--
function MenuScene:init()

	MenuScene.super.init(self)
	self.header = Header()
	self.listview = ListView()
	self:addSprite(self.header)
	self:addSprite(self.listview)
	self:setInputHandlers()
	return self

end

function MenuScene:setInputHandlers()

	local myInputHandlers = {
		upButtonUp = function()
			self.listview:up()
			self.listview:forceUpdate()
		end,
		downButtonUp = function()
			self.listview:down()
			self.listview:forceUpdate()
		end,
	}
	playdate.inputHandlers.push(myInputHandlers, true)

end