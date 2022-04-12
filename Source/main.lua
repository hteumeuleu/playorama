import "CoreLibs/object"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "GameState"
import "Videorama"
import "Controls"
import "Menu"

local kMenuState <const> = "Menu"
local kPlayState <const> = "Play"
local kInfosState <const> = "Infos"
local menu = Menu()

local gameState = GameState({kMenuState, kPlayState, kInfosState})
-- gameState:set(kPlayState)

function initPlayState()
	-- Play state
	if(gameState:get() == kPlayState) then

		video = Videorama()
		controls = Controls()
		controls:setTotalTime(video:getTotalTime())

		contextImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
		contextImage:draw(0, 0)
		video:setContext(contextImage)

		local maskImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
		playdate.graphics.pushContext(maskImage)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(0, 0, 400, 240, 4)
		playdate.graphics.popContext()

		contextImage:setMaskImage(maskImage)

		isFFing = false

		-- Setup control handlers
		playdate.inputHandlers.pop()
		local myInputHandlers = {
			AButtonDown = function()
				video:togglePause()
			end,
			BButtonDown = function()
				video:setRate(0)
				gameState:set(kMenuState)
				initMenuState()
			end,
			upButtonDown = function()
				controls:toggle()
			end,
			downButtonDown = function()
				video:setRate(0)
			end,
			leftButtonDown = function()
				video:setRate(-1)
			end,
			rightButtonDown = function()
				video:setRate(1)
			end,
			cranked = function(change, acceleratedChange)
				if acceleratedChange > 1 then
					video:increaseRate()
				elseif acceleratedChange < -1 then
					video:decreaseRate()
				end

				if acceleratedChange > 10 then
					isFFing = true
				elseif acceleratedChange < -10 then
					isFFing = true
				else
					isFFing = false
				end
			end,
		}
		playdate.inputHandlers.push(myInputHandlers)
	end
end

-- Menu state
function initMenuState()
	if(gameState:get() == kMenuState) then

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
		menu:update()
	end

	-- Play state
	if(gameState:get() == kPlayState) then

		video:update()

		if isFFing == true and video.isPlaying then
			local vcr = contextImage:vcrPauseFilterImage()
			vcr:draw(0,0)
		else
			contextImage:draw(0,0)
		end

		controls:setCurrentTime(video:getCurrentTime())
		controls:update()

	end
end