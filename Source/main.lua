import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "Scripts/libraries/globals"
import "Scripts/libraries/Icon"
import "Scripts/playorama"

local pd <const> = playdate
local gfx <const> = pd.graphics

function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()
	playorama.update()

end
