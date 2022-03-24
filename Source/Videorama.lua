import "CoreLibs/object"

class('Videorama').extends()

function Videorama:init(videoPath)

	Videorama.super.init(self)
	self.video = playdate.graphics.video.new(videoPath)
	return self

end

function Videorama:getThumbnail()

	local thumbnail = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	self.video:setContext(thumbnail)
	local halfFrame = math.floor(self.video:getFrameCount() / 4)
	self.video:renderFrame(halfFrame)
	thumbnail = thumbnail:vcrPauseFilterImage()
	return thumbnail

end