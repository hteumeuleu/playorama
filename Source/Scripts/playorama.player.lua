import "Scripts/player/VideoPlayer"
import "Scripts/player/Controls"
import "Scripts/player/Effects"
import "Scripts/player/Speed"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.player = {}
playorama.player.video = {}

playorama.player.kMinPlaybackRate = -4
playorama.player.kMaxPlaybackRate = 4
playorama.player.kPlaybackRateStep = 0.1

-- playorama.player.video.new(video)
--
-- Constructor for a video player.
playorama.player.video.new = function(video)

   	return VideoPlayer(video)

end

