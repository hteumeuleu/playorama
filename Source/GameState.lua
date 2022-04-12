import "CoreLibs/object"

class('GameState').extends()

-- init()
--
function GameState:init(states)

	GameState.super.init(self)

	self.states = states
	self:set(states[1])

	return self

end

-- set(state)
--
function GameState:set(state)

	self.current = state

end

-- get(state)
--
function GameState:get()

	return self.current

end