import "Scene"

class('VideoPlayer').extends('Scene')

-- VideoPlayer
--
function VideoPlayer:init(libraryItem)

	VideoPlayer.super.init(self)
	self.libraryItem = libraryItem
	self:setInputHandlers()
	self:setImage(playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack))
	self:setZIndex(20)
	self:addSprite(self.libraryItem.objectorama)
	self:add()
	return self

end

-- update()
--
function VideoPlayer:update()

	VideoPlayer.super.update(self)
	if self.libraryItem ~= nil and self.libraryItem.objectorama ~= nil then
		if self.libraryItem.objectorama:isPlaying() or self.isBackgroundDrawing then
			self.libraryItem.objectorama:update()
		end
		-- self:setCurrentTimeText()
		-- self.controls:update()
	end
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