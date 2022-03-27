import "CoreLibs/object"
import "CoreLibs/ui"
import "GameState"
import "Videorama"
import "Controls"

local kMenuState <const> = "Menu"
local kPlayState <const> = "Play"
local kInfosState <const> = "Infos"

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

		-- Draw items on menu
		local contextImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
		contextImage:draw(0, 0)

		local videoMenuItem = Videorama()
		local videoContextImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
		videoMenuItem:setContext(videoContextImage)
		local thumb = videoMenuItem:getThumbnail()
		thumb:draw(0, 0)

		local menuItemMaskImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorWhite)
		playdate.graphics.pushContext(menuItemMaskImage)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(20, 50, 360, 160, 4)
		playdate.graphics.popContext()
		videoContextImage:setMaskImage(menuItemMaskImage)
		videoContextImage:draw(0, 0)

		-- Placeholder elements
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(390, 50, 360, 160, 4)
		playdate.graphics.fillRoundRect(-350, 50, 360, 160, 4)

		-- Placeholder video outline
		playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
		playdate.graphics.setLineWidth(2)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.drawRoundRect(20, 50, 360, 160, 4)

		-- Text title
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText("*PLAYORAMA*", 20, 20)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)

		-- Setup control handlers
		playdate.inputHandlers.pop()
		local myInputHandlers = {
			AButtonDown = function()
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