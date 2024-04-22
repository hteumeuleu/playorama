import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "Scripts/playorama"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- local video = playorama.video.new("Assets/sample.pdv", "Assets/sample.pda")
-- video:play()
-- print(video)
-- local player = playorama.player.new(playorama.video.new("Assets/sample.pdv", "Assets/sample.pda"))
lib = playorama.library.init()
item = lib:pop()
playorama.player.new(item.video)

-- playdate.update()
--
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()

end
