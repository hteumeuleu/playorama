import "CoreLibs/object"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "GameState"
import "Player"
import "Menu"

local kMenuState <const> = "Menu"
local kPlayState <const> = "Play"
local menu = nil
local player = nil

local gameState = GameState({kMenuState, kPlayState})
-- gameState:set(kPlayState)

function initPlayState()
	-- Play state
	if(gameState:get() == kPlayState) then

		local myInputHandlers = {
			BButtonUp = function()
				gameState:set(kMenuState)
				initMenuState()
			end
		}
		playdate.inputHandlers.push(myInputHandlers)

	end
end

-- Menu state
function initMenuState()
	if(gameState:get() == kMenuState) then

		if menu == nil then
			menu = Menu()
		end
		menu:reinit()

		local myInputHandlers = {
			AButtonUp = function()
				gameState:set(kPlayState)
				initPlayState()
			end
		}
		playdate.inputHandlers.push(myInputHandlers)

	end
end

initMenuState()

-- Setup the Crank Indicator
playdate.ui.crankIndicator:start()
playdate.setCrankSoundsDisabled(true)

function playdate.update()

	playdate.timer.updateTimers() -- Required to use timers and crankIndicator

	-- Menu state
	if(gameState:get() == kMenuState) then
		if menu == nil then
			menu = Menu()
		end
		menu:update()
	end

	-- Play state
	if(gameState:get() == kPlayState) then
		if player == nil then
			player = Player()
		end
		player:update()
	end
end