import "playorama.ui.lua"
import "playorama.library.lua"
import "playorama.player.lua"
import "playorama.video.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics

math.randomseed(pd.getSecondsSinceEpoch())
pd.setCrankSoundsDisabled(true)
pd.display.setRefreshRate(50)
gfx.setFont(playorama.ui.fonts.medium)
gfx.setBackgroundColor(gfx.kColorBlack)
playdate.graphics.sprite.setBackgroundDrawingCallback(
	function(x, y, width, height)
	end
)

playorama = playorama or {}
playorama.init = function()
	playorama.library = Library()
	playorama.ui.header = Header()
	playorama.ui.menu = Menu(playorama.ui.homeList)
end
playorama.update = function()
	playorama.ui.update()
end

playorama.init()
