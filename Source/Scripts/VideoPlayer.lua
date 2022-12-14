import "Scene"

class('VideoPlayer').extends('Scene')

-- VideoPlayer
--
function VideoPlayer:init(videoPath)

	VideoPlayer.super.init(self)
	print(videoPath)
	self:setInputHandlers()
	return self

end

-- setInputHandlers()
--
function VideoPlayer:setInputHandlers()

	local myInputHandlers = {
		AButtonUp = function()
		end,
		BButtonUp = function()
			self:close()
		end,
		upButtonUp = function()
		end,
		downButtonUp = function()
		end,
	}
	playdate.inputHandlers.push(myInputHandlers, true)

end

-- close()
--
function VideoPlayer:close()

	self:remove()
	playdate.inputHandlers.pop()

end