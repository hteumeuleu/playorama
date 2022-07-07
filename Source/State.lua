import "CoreLibs/object"

class('State').extends()

-- init()
--
function State:init()

	State.super.init(self)

	self.kMenuState = "Menu"
	self.kPlayState = "Play"
	self:set(self.kMenuState)

	return self

end

-- set(state)
--
function State:set(state)

	self.current = state

end

-- get(state)
--
function State:get()

	return self.current

end