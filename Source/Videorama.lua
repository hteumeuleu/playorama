import "CoreLibs/object"
import "CoreLibs/timer"

local kMinPlaybackRate <const> = -4
local kMaxPlaybackRate <const> = 4
local kPlaybackRateStep <const> = 0.1

class('Videorama').extends()

function createVideorama(videoPath, audioPath)
    local v = Videorama(videoPath, audioPath)
	if v ~= nil and v.error == nil then
        return v
    end
    return nil, v.error
end

function Videorama:init(videoPath, audioPath)

	Videorama.super.init(self)
	self.videoPath = videoPath
	self.audioPath = audioPath
	self.name = string.gsub(string.sub(videoPath .. '', 1, string.find(videoPath .. '', '.pdv') - 1), "_", "__")

	-- Return nil if there's no audio
	if videoPath == nil then
		self.error = "Missing video path."
		return nil, self.error
	end

	-- Open video
	self.video, videoerr = playdate.graphics.video.new(videoPath)

	-- Return nil if there's a problem when opening the video
	if videoerr ~= nil then
		self.error = "Cannot open video at `".. videoPath .. "`: [" .. videoerr .. "]"
		print(self.error)
		return self
	end

	-- No nil up til here? Alright, let's do this!

	-- Variables to keep track of the last frame played and the current playback rate
	self.lastFrame = 0
	self.playbackRate = 1
	self.playbackRateBeforePause = self.playbackRate
	self.isPaused = true
	self.lastModified = self:getLastModifiedTimestamp()

	-- Creates the graphical context to render the video
	-- I use a custom context instead of `useScreenContext` to apply a mask later on.
	self.context = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	self.video:setContext(self.context)

	-- See, there it is. (The mask.)
	-- Basically a round rectangle for a little retro style.
	local mask = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	playdate.graphics.pushContext(mask)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(0, 0, 400, 240, 16)
	playdate.graphics.popContext()
	self.context:setMaskImage(mask)

	self:unload()

	return self

end

function Videorama:load()

	-- Open video
	self.video, videoerr = playdate.graphics.video.new(self.videoPath)
	self.video:setContext(self.context)

	-- Return nil if there's a problem when opening the video
	if videoerr ~= nil then
		self.error = "Cannot open video at `".. self.videoPath .. "`: [" .. videoerr .. "]"
		print(self.error)
		return false, self.error
	end

	-- Open audio
	if self.audioPath ~= nil then
		if self:isFilePlayer() then
			self.audio, audioerr = playdate.sound.fileplayer.new(self.audioPath)
		else
			self.audio, audioerr = playdate.sound.sampleplayer.new(self.audioPath)
		end

		-- Return nil if there's a problem when opening the audio
		if audioerr ~= nil then
			self.error = "Cannot open audio at `".. self.audioPath .. "`: [" .. audioerr .. "]"
			print(self.error)
			return false, self.error
		end
	end
	return true, self

end

function Videorama:unload()

	if self.audio ~= nil then
		self.audio:stop()
	end
	self.audio = nil
	self.video = nil

end


-- draw()
--
function Videorama:draw()

	if self:isFFing() and gOptionVcrEffect then
		local contextWithVCRFilter = self.context:vcrPauseFilterImage()
		contextWithVCRFilter:draw(0,0)
	else
		self.context:draw(0,0)
	end

end

-- update()
--
-- Update and renders the frame to show.
function Videorama:update()

	local frame = self.lastFrame

	if self:isPlaying() then
		-- If it has audio, we define the frame to show based on the
		-- current audio offset and frame rate.
		if self:hasAudio() then
			if not self.audio:isPlaying() then
				local _, err = self.audio:play(0)
				if err ~= nil then
					self.error = err
					self.audioPath = nil
					self.audio = nil
					return self.error
				else
					self.isPaused = false
				end
			end

			self.audio:setRate(self.playbackRate)

			frame = math.floor(self.audio:getOffset() * self.video:getFrameRate())
		else
		-- If there's no audio and if the video is not paused,
		-- we increment the lastFrame.
			local elapsed = playdate.getElapsedTime()
			frame = math.ceil(self.lastFrame + elapsed * self.video:getFrameRate() * self.playbackRate)
		end
	end

	if frame < 0 then
		frame = self.video:getFrameCount()
	end

	if frame > self.video:getFrameCount() then
		frame = 0
	end

	if frame ~= self.lastFrame then
		self.video:renderFrame(frame)
		self.lastFrame = frame
		playdate.resetElapsedTime()
	end

	self:draw()
end

function Videorama:setFrame(frame)

	if frame ~= self.lastFrame then
		self.video:renderFrame(frame)
		self.lastFrame = frame
		playdate.resetElapsedTime()

		if self:hasAudio() then
			self.audio:setOffset(self:getCurrentTime())
		end
	end

	self:draw()

end

-- setContext(image)
--
-- Sets the given image to the video render context.
function Videorama:setContext(image)

	return self.video:setContext(image)

end

-- getContext()
--
-- Gets the video render context <image>.
function Videorama:getContext()

	return self.video:getContext()

end

-- setRate()
--
-- Sets the playback rate for the video.
-- 1.0 is normal speed, 0.5 is half speed, 0 is paused.
function Videorama:setRate(rate)

	if self.playbackRate == nil or rate == nil then
		return false
	end

	self.playbackRate = rate

	-- Watch for upper limit
	if self.playbackRate > kMaxPlaybackRate then
		self.playbackRate = kMaxPlaybackRate
	end

	-- Watch for lower limit
	if self.playbackRate < kMinPlaybackRate then
		self.playbackRate = kMinPlaybackRate
	end

	if self:isFilePlayer() and self.playbackRate < 0 then
		self.playbackRate = 0
	end

	-- Update actual audio player rate
	if self:hasAudio() then
		self.audio:setRate(self.playbackRate)
	end

end

-- getRate()
--
function Videorama:getRate()

	return self.playbackRate

end

-- toggleRate()
--
function Videorama:toggleRate(direction)

	local newRate = 0
	local roundedAbs = math.floor(math.abs(self.playbackRate) + 0.5)
	if (self.playbackRate > 0 and direction == -1) or (self.playbackRate < 0 and direction == 1) then
		newRate = 1
	elseif roundedAbs >= 4 or roundedAbs < 1 then
		newRate = 1
	elseif roundedAbs >= 2 then
		newRate = 4
	elseif roundedAbs >= 1 then
		newRate = 2
	end
	if direction ~= nil then
		newRate = newRate * direction
	end
	self:setRate(newRate)

end

-- isPlaying()
--
function Videorama:isPlaying()

	return not self.isPaused

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
		self.isPaused = true
	else
		self:setRate(self.playbackRateBeforePause)
		self.isPaused = false
		playdate.resetElapsedTime()
	end

end

-- togglePause()
--
function Videorama:togglePause()

	self:setPaused(not self.isPaused)

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
	local video = playdate.graphics.video.new(self.videoPath)
	video:setContext(thumbnail)
	local frame = math.floor(video:getFrameCount() / 4)
	video:renderFrame(frame)
	video = nil
	return thumbnail

end

-- getTotalTime()
--
-- Returns the total duration, in seconds.
function Videorama:getTotalTime()

	return (self.video:getFrameCount() / self.video:getFrameRate())

end

-- getCurrentTime()
--
-- Returns the current play time, in seconds.
function Videorama:getCurrentTime()

	return (self.lastFrame / self.video:getFrameRate())

end

-- isFFing()
--
-- Returns true if the video is fast forwarding (or "backwarding").
function Videorama:isFFing()

	if self.playbackRate > 1.2 or self.playbackRate < 0.8  then
		return true
	end
	return false

end

-- getDisplayName()
--
-- Returns a string representing the name of the video to display
function Videorama:getDisplayName()

	return string.upper(self.name)

end

-- getDisplayRate()
--
function Videorama:getDisplayRate()

	local roundedValue = math.floor(self.playbackRate * 10 + 0.5) / 10
	return roundedValue .. "x"

end

-- hasAudio()
--
-- Returns a boolean whether the current Videorama has audio.
function Videorama:hasAudio()

    return self.audio ~= nil

end

-- isAudioM4A()
--
-- Returns a boolean whether the audio stream is in `.m4a` extension.
function Videorama:isAudioM4A()

	if self.audioPath ~= nil then
		local i = string.find(string.lower(self.audioPath), '.m4a')
		if i ~= nil and i > 1 then
			return true
		end
	end
	return false

end

-- isAudioMP3()
--
-- Returns a boolean whether the audio stream is in `.mp3` extension.
function Videorama:isAudioMP3()

	if self.audioPath ~= nil then
		local i = string.find(string.lower(self.audioPath), '.mp3')
		if i ~= nil and i > 1 then
			return true
		end
	end
	return false

end

-- isFilePlayer()
--
function Videorama:isFilePlayer()

	return self:isAudioMP3() or self:isAudioM4A()

end

-- getLastModifiedTimestamp()
--
-- Gets the last modified date of the original video file.
-- Returns a number (useful for sorting).
function Videorama:getLastModifiedTimestamp()

	local timestamp = 0

	if self.videoPath then
		local d = playdate.file.modtime(self.videoPath)
		timestamp = playdate.epochFromTime(d)
	end

	return timestamp

end