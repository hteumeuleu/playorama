import "playorama.ui.lua"
import "playorama.library.lua"
import "playorama.player.lua"
import "playorama.video.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics

function clamp(val, a, b)
	return math.max(a, math.min(b, val))
end

math.randomseed(pd.getSecondsSinceEpoch())
pd.setCrankSoundsDisabled(true)
pd.display.setRefreshRate(30)
gfx.setBackgroundColor(gfx.kColorBlack)
gfx.setFont(playorama.ui.fonts.medium)
playorama.ui.fonts.large:drawText("Playorama", 10, 10)

playorama = playorama or {}
