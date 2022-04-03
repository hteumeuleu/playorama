import "CoreLibs/object"
import "CoreLibs/ui"
import "CoreLibs/crank"
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

		-- Black background
		playdate.graphics.clear(playdate.graphics.kColorBlack)

		-- Grid view
		gridview = playdate.ui.gridview.new(360, 160)
		gridview:setNumberOfColumns(8)
		gridview:setNumberOfRows(1)
		gridview:setCellPadding(5, 5, 0, 0)

		function gridview:drawCell(section, row, column, selected, x, y, width, height)

			-- Draw background
			playdate.graphics.setColor(playdate.graphics.kColorWhite)
			playdate.graphics.fillRoundRect(x, y, width, height, 4)

			-- First item video (temporary placeholder)
			if row == 1 and column == 1 then
				local aVideoContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
				playdate.graphics.pushContext(aVideoContext)
				local firstVideo = Videorama()
				local firstThumb = firstVideo:getThumbnail()
				firstThumb:draw(0, 0)
				playdate.graphics.popContext()
				aVideoContext:draw(x, y)
			end


			-- Draw outline if selected
			if selected then
				local outerBorderColor = playdate.graphics.kColorWhite
				local innerBorderColor = playdate.graphics.kColorBlack
				-- Outer border
				playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
				playdate.graphics.setLineWidth(2)
				playdate.graphics.setColor(outerBorderColor)
				playdate.graphics.drawRoundRect(x, y, width, height, 4)
				-- Inner border
				playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
				playdate.graphics.setLineWidth(3)
				playdate.graphics.setColor(innerBorderColor)
				playdate.graphics.drawRoundRect(x+2, y+2, width-4, height-4, 4)
			end

			-- Draw text inside
			local kControlsFont <const> = playdate.graphics.getFont()
			local textY = math.floor((height - kControlsFont:getHeight()) / 2)
			local cellText = "*PLAYORAMA "..row.."-"..column.."*"
			playdate.graphics.drawTextInRect(cellText, x, y + textY, width, height, nil, nil, kTextAlignment.center)
		end

		-- Text title
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText("*PLAYORAMA*", 20, 20)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)

		-- Setup control handlers
		playdate.inputHandlers.pop()
		local myInputHandlers = {
			AButtonUp = function()
				gameState:set(kPlayState)
				initPlayState()
			end,
			leftButtonUp = function()
				gridview:selectPreviousColumn(true)
			end,
			rightButtonUp = function()
				gridview:selectNextColumn(true)
			end,
			cranked = function(change, acceleratedChange)
				local ticks = playdate.getCrankTicks(2)
				if ticks == 1 then
					gridview:selectNextColumn(true)
				elseif ticks == -1 then
					gridview:selectPreviousColumn(true)
				end
			end,
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
		playdate.graphics.setClipRect(0, 50, 400, 160)
		playdate.graphics.clear(playdate.graphics.kColorBlack)
		gridview:drawInRect(0, 50, 400, 160)
		playdate.graphics.clearClipRect()

		-- Text title
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText("*PLAYORAMA*", 20, 20)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
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