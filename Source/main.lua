import "CoreLibs/object"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "State"
import "Player"
import "Menu"

-- Fonts
kFontCuberickBold = playdate.graphics.font.new("fonts/font-Cuberick-Bold", playdate.graphics.font.kVariantBold)

local state = State()
local menu = nil
local player = nil
local current = 1

function initPlayState()
	-- Play state
	if(state:get() == state.kPlayState) then

		local selection = menu:getSelection()

		if player == nil then
			player = Player()
		end
		-- I keep track of the current video played
		-- to scroll back to it when going back to the menu
		current = menu:getSelectionIndex()
		player:loadAndPlay(selection)
		player:setInputHandlers()

		local myInputHandlers = {
			BButtonUp = function()
				state:set(state.kMenuState)
				player:unload()
				initMenuState()
			end
		}
		playdate.inputHandlers.push(myInputHandlers)

	end
end

-- Menu state
function initMenuState()
	if(state:get() == state.kMenuState) then

		if menu == nil then
			menu = Menu()
		end
		menu:reset()
		menu:setSelection(current)

		local myInputHandlers = {
			AButtonUp = function()
				state:set(state.kPlayState)
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
	if(state:get() == state.kMenuState) then
		menu:update()
	end

	-- Play state
	if(state:get() == state.kPlayState) then
		player:update()
	end
end