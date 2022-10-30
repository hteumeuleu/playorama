import "Scene"
import "Header"

class('MenuScene').extends('Scene')

-- MenuScene
--
function MenuScene:init()

	MenuScene.super.init(self)
	self.header = Header()
	self:addSprite(self.header)
	return self

end