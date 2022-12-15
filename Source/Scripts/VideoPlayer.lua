import "Scene"

class('VideoPlayer').extends('Scene')

-- VideoPlayer
--
function VideoPlayer:init(videoPath)

	VideoPlayer.super.init(self)
	print(videoPath)
	self:setInputHandlers()
	self:setImage(playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack))
	self:setZIndex(20)
	self:add()
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