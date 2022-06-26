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
local current = 1

local gameState = GameState({kMenuState, kPlayState})
gameState:set(kMenuState)

function initPlayState()
	-- Play state
	if(gameState:get() == kPlayState) then

		local selection = menu:getSelection()
		local v = Videorama(selection.video, selection.audio)

		if v ~= nil and v.error == nil then
			if player == nil then
				player = Player()
			end
			-- I keep track of the current video played
			-- to scroll back to it when going back to the menu
			current = menu:getSelectionIndex()
			player:setVideo(v)
			player.videorama:setPaused(false)
			player:setInputHandlers()

			local myInputHandlers = {
				BButtonUp = function()
					gameState:set(kMenuState)
					player.videorama:setPaused(true)
					initMenuState()
				end
			}
			playdate.inputHandlers.push(myInputHandlers)
		else
			gameState:set(kMenuState)
			menu:drawError(v.error)
		end

	end
end

-- Menu state
function initMenuState()
	if(gameState:get() == kMenuState) then

		if menu == nil then
			menu = Menu()
		end
		menu:reset()
		menu:setSelection(current)

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
		menu:update()
	end

	-- Play state
	if(gameState:get() == kPlayState) then
		player:update()
	end
end