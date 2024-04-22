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

-- local video = playorama.video.new("Assets/sample.pdv", "Assets/sample.pda")
-- video:play()
-- print(video)
-- local player = playorama.player.new(playorama.video.new("Assets/sample.pdv", "Assets/sample.pda"))

-- local item <const> = lib:pop()
-- playorama.player.new(playorama.video.new(item.videoPath, item.audioPath))

-- playdate.update()
--
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()

end
