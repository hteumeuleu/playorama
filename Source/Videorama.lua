import "CoreLibs/object"
import "CoreLibs/timer"

local kMinPlaybackRate <const> = -4
local kMaxPlaybackRate <const> = 4
local kPlaybackRateStep <const> = 0.1

class('Videorama').extends()

function Videorama:init(videoPath, audioPath)

	Videorama.super.init(self)

	if videoPath == nil then
		videoPath = 'assets/sample.pdv'
	end

	if audioPath == nil then
		audioPath = 'assets/sample.wav'
	end

	self.video = playdate.graphics.video.new(videoPath)
	self.audio = playdate.sound.sampleplayer.new(audioPath)
	self.lastFrame = 0
	self.playbackRate = 1
	self.isPlaying = false

	self.video:useScreenContext()

	return self

end

-- update()
--
-- Sets the frame to show based on current audio position.
function Videorama:update()

    playdate.timer.updateTimers() -- Required to use timers and crankIndicator

	if self.audio:isPlaying() ~= true then
		self.audio:play(self.lastFrame)
		self.isPlaying = true
	end

	self.audio:setRate(self.playbackRate)

	-- Picks frame to show
	local frame = math.floor(self.audio:getOffset() * self.video:getFrameRate())

	if frame < 0 then
		frame = self.video:getFrameCount()
	end

	if frame > self.video:getFrameCount() then
		frame = 0
	end

	if frame ~= self.lastFrame then
		self.video:renderFrame(frame)
		self.lastFrame = frame
	end
end

-- setContext(image)
--
-- Sets the given image to the video render context.
function Videorama:setContext(image)

	self.video:setContext(image)

end

-- setRate()
--
-- Sets the playback rate for the video.
-- 1.0 is normal speed, 0.5 is half speed, 0 is paused.
function Videorama:setRate(rate)

	self.playbackRate = rate

	-- Watch for upper limit
	if self.playbackRate > kMaxPlaybackRate then
		self.playbackRate = kMaxPlaybackRate
	end

	-- Watch for lower limit
	if self.playbackRate < kMinPlaybackRate then
		self.playbackRate = kMinPlaybackRate
	end

	-- Update isPlaying status
	if self.playbackRate == 0 then
		self.isPlaying = false
	else
		self.isPlaying = true
	end

	-- Update actual audio player rate
	self.audio:setRate(self.playbackRate)

end

-- setPaused(flag)
--
-- Pauses the video and audio based on the boolean flag.
function Videorama:setPaused(flag)

	if self.playbackRate ~= 0 then
		self.playbackRateBeforePause = self.playbackRate
	end

	if flag == true then
		self:setRate(0)
	else
		self:setRate(self.playbackRateBeforePause)
	end

end

-- togglePause()
--
function Videorama:togglePause()

	self:setPaused(self.isPlaying)

end

-- increaseRate()
--
-- Increases the playback rate speed by kPlaybackRateStep value.
function Videorama:increaseRate()

	self:setRate(self.playbackRate + kPlaybackRateStep)

end

-- decreaseRate()
--
-- Decreases the playback rate speed by kPlaybackRateStep value.
function Videorama:decreaseRate()

	self:setRate(self.playbackRate - kPlaybackRateStep)

end

-- getThumbnail()
--
-- Returns an <image> with a preview of the video at a specific frame.
-- (Currently picks an image at precisely a quarter of the video.)
function Videorama:getThumbnail()

	local thumbnail = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	self.video:setContext(thumbnail)
	local frame = math.floor(self.video:getFrameCount() / 4)
	self.video:renderFrame(frame)
	return thumbnail

end

-- getTotalTime()
--
function Videorama:getTotalTime()

	return self.audio:getLength()

end

-- getCurrentTime()
--
function Videorama:getCurrentTime()

	return self.audio:getOffset()

end