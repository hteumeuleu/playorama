import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "Player"
import "Menu"
import "Log"

playdate.sound.sampleplayer.__tostring = function(this)
	local output = "{\n"
	output = output .. "\t[__name] = " .. this.__name .. ",\n"
	output = output .. "\t[length] = " .. this:getLength() .. ",\n"
	output = output .. "\t[offset] = " .. this:getOffset() .. ",\n"
	output = output .. "\t[volume] = " .. this:getVolume() .. ",\n"
	output = output .. "\t[rate] = " .. this:getRate() .. ",\n"
	output = output .. "\t[isPlaying] = " .. tostring(this:isPlaying()) .. ",\n"
	output = output .. "}"
	return output
end

-- Global variables
gOptionVcrEffect = false
gLog = Log()

-- Define global font
local kFontCuberickBold <const> = playdate.graphics.font.new("fonts/font-Cuberick-Bold", playdate.graphics.font.kVariantBold)
playdate.graphics.setFont(kFontCuberickBold)

-- App variables
local kMenuState <const> = "Menu"
local kPlayState <const> = "Play"
local kLogState <const> = "Log"
local state = kMenuState
local menu = nil
local player = nil
local lastPlayedItem = 1

-- initMenuState()
--
-- Sets the current state of the app to the Menu.
function initMenuState()

	playdate.setAutoLockDisabled(false)

	state = kMenuState

	-- If the Menu class hasn't been instanciated yet, we do it now.
	if menu == nil then
		menu = Menu()
	end
	-- We reset the menu drawing functions.
	menu:reset()
	-- We set the menu selection to the last played item.
	menu:setSelection(lastPlayedItem)

	local myInputHandlers = {
		AButtonUp = function()
			initPlayState()
		end
	}
	playdate.inputHandlers.push(myInputHandlers)

end

-- initPlayState()
--
-- Sets the current state of the app to the Player.
function initPlayState()

	playdate.setAutoLockDisabled(true)

	state = kPlayState

	-- If the Player class hasn't been instanciated yet, we do it now.
	if player == nil then
		player = Player()
	end
	-- We keep track of the video that gets played
	-- to scroll back to it when going back to the menu.
	lastPlayedItem = menu:getSelectionIndex()
	-- We load the video inside the player.
	player:setVideorama(menu:getSelection())
	player:setInputHandlers()

	local myInputHandlers = {
		BButtonUp = function()
			player:unload()
			initMenuState()
		end
	}
	playdate.inputHandlers.push(myInputHandlers)

end

-- initLogState
--
function initLogState()

	if state == kPlayState then
		player:unload()
		initMenuState()
	end
	state = kLogState

	local myInputHandlers = {
		BButtonUp = function()
			gLog:unload()
			initMenuState()
		end
	}
	playdate.inputHandlers.push(myInputHandlers, true)


end


-- initSystemMenu()
--
-- Add options in System menu.
local function initSystemMenu()

	local systemMenu = playdate.getSystemMenu()

	-- Add an option for the VCR effect.
	-- If checked, frames will get a VCR effect when accelerating.
	local checkmarkMenuItem, error = systemMenu:addCheckmarkMenuItem("VCR Effect", gOptionVcrEffect, function(value)
		gOptionVcrEffect = value
	end)
	-- Add a menu item for log infos.
	local logMenuItem, error = systemMenu:addMenuItem("Log", initLogState)

end

-- playdate.update()
--
-- Main cycle routine.
-- Updates either the menu or player accordingly.
function playdate.update()

	playdate.timer.updateTimers()

	if(state == kMenuState) then
		menu:update()
	elseif(state == kPlayState) then
		player:update()
	elseif(state == kLogState) then
		gLog:update()
	end
end

-- Startup initializations
playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
playdate.setCrankSoundsDisabled(true)
initSystemMenu()
initMenuState()
