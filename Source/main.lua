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
import "Scripts/Widgets/Header/Header.lua"
import "Scripts/Playorama.lua"

-- Init app
app = Playorama()

-- playdate.update()
--
-- Main cycle routine.
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()

end