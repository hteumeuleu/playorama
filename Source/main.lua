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
import "Scripts/Scenes/Player/VideoPlayer.lua"
import "Scripts/Common/Library.lua"
import "Scripts/Scenes/Menu/Menu.lua"
import "Scripts/Playorama.lua"

-- Init app
local p <const> = Playorama()

function getMenu()

	return p:getMenu()

end

-- playdate.update()
--
-- Main cycle routine.
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()
	p:update()

end