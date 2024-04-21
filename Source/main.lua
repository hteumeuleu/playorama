import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "Scripts/playorama"


function clamp(val, a, b)
	return math.max(a, math.min(b, val))
end

local pd <const> = playdate
local gfx <const> = pd.graphics

gfx.setFont(playorama.ui.fonts.medium)
playorama.ui.fonts.large:drawText("Playorama", 10, 10)

local video = playorama.video.new("Assets/sample.pdv", "Assets/sample.pda")
video:play()
-- print(video)

-- playdate.update()
--
function playdate.update()

	playdate.timer.updateTimers()
	playdate.graphics.sprite.update()
	video:update()

end

function playdate.cranked(change, acceleratedChange)

	local framerate = video.video:getFrameRate()
	local tick = playdate.getCrankTicks(framerate)
	if video:isPlaying() then
		if tick == 1 then
			video:setRate(video:getRate() + playorama.player.kPlaybackRateStep)
		elseif tick == -1 then
			video:setRate(video:getRate() - playorama.player.kPlaybackRateStep)
		end
	else
		video:setRate(video:getRate() + playorama.player.kPlaybackRateStep)
		-- local n = video.lastFrame + tick
		-- video:renderFrame(n)
	end

end

function playdate.AButtonDown()

	if video:isPlaying() then
		video:pause()
	else
		video:play()
	end

end
