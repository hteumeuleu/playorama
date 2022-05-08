class('VideoPlayer').extends(playdate.graphics.video)

function VideoPlayer:init(path)

	VideoPlayer.super.init(self)

	if path == nil then
		path = 'assets/sample.pdv'
	end

	self.videoPath = path
	self.audioPath = nil
	self.videoPlayer = nil
	self.audioPlayer = nil

	return self

end

function VideoPlayer:update()

end