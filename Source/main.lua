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
import "Scripts/Libs/Signal"
import "Scripts/Scenes/Player/VideoPlayer"
import "Scripts/Common/Library"
import "Scripts/Scenes/Menu/Menu"
import "Scripts/Widgets/Header/Header"
import "Scripts/Playorama"

-- Init app
NotificationCenter = Signal()
app = Playorama()

-- playdate.update()
--
-- Main cycle routine.
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()

end