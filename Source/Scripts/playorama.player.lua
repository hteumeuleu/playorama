import "Scripts/player/Player"
import "Scripts/player/Controls"
import "Scripts/player/Effects"
import "Scripts/player/Speed"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.player = {}

playorama.player.kMinPlaybackRate = -4
playorama.player.kMaxPlaybackRate = 4
playorama.player.kPlaybackRateStep = 0.1

-- playorama.player.new(video)
--
-- Constructor for a video player.
playorama.player.new = function(video)

   	return Player(video)

end

