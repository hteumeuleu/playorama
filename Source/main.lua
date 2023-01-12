import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/animator"
import "CoreLibs/easing"

-- Custom Scripts
import "Scripts/globals.lua"
import "Scripts/Icon"
import "Scripts/Library"
import "Scripts/Log"
import "Scripts/Scene"
import "Scripts/Menu"
import "Scripts/VideoPlayer"

-- Global variables
gOptionVcrEffect = false
gLog = Log()
local lib <const> = Library()

function getListFromLibrary(type)
	return lib:toList(type)
end

-- Define global font
kFontCuberickBold = playdate.graphics.font.new("Fonts/Cuberick-Bold", playdate.graphics.font.kVariantBold)
kFontCuberickBold24 = playdate.graphics.font.new("Fonts/Cuberick-Bold-24", playdate.graphics.font.kVariantBold)
playdate.graphics.setFont(kFontCuberickBold)

-- App variables
local kMenuState <const> = "Menu"
local kPlayState <const> = "Play"
local kLogState <const> = "Log"
local state = kMenuState
local menu = Menu()
local player = nil
local lastPlayedItem = 1

function getMenu()
	return menu
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
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()

end

-- Startup initializations
playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
playdate.setCrankSoundsDisabled(true)
initSystemMenu()