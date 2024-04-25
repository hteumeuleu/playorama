local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.video = {}

-- playorama.video.new(videoPath, [audioPath])
--
-- Constructor for a video.
playorama.video.new = function(videoPath, audioPath)

    local video = Video(videoPath, audioPath)
	if video ~= nil and video.error == nil then
        return video
    end
    if video.error ~= nil then
    	print(video.error)
    end
    return nil, video.error

end

-- Video class
--
-- Combines audio and video into an object ready to play.
class("Video").extends()

function Video:init(videoPath, audioPath)

	Video.super.init(self)
	self.videoPath = videoPath
	self.audioPath = audioPath

	-- Return if there's no video.
	if self.videoPath == nil then
		self.error = "Missing video path."
		return self
	end

	-- Open video.
	local video, videoerr = gfx.video.new(self.videoPath)

	-- Return if there's a problem when opening the video.
	if videoerr ~= nil then
		self.error = "Cannot open video at `".. self.videoPath .. "`: [" .. videoerr .. "]"
		return self
	end

	-- The video might be nil even without an error. So we check that as well.
	if video == nil then
		self.error = "An unknown error occurred while opening video at `".. self.videoPath .. "`."
		return self
	end

	-- Check the video size. We expect 400x240 resolution.
	local w, h = video:getSize()
	if w ~= 400 or h ~= 240 then
		self.error = "Video at `".. self.videoPath .. "` must be 400x240. Currently is " .. w .. "x" .. h .. "."
		return self
	end

	-- No nil up til here? Alright, let's do this!
	self.video = video
	self:setMetaData()

	-- Internal Variables to keep track of the last frame played and the current playback rate.
	self.lastFrame = 0
	self.playbackRate = 1
	self.playbackRateBeforePause = self.playbackRate
	self._isPlaying = false

	return self

end

function Video:update()

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
					self._isPlaying = false
					return self.error
				else
					self._isPlaying = true
				end
			end

			self.audio:setRate(self.playbackRate)

			frame = math.floor(self.audio:getOffset() * self.video:getFrameRate())
		else
		-- If there's no audio and if the video is not paused,
		-- we increment the lastFrame.
			local elapsed <const> = playdate.getElapsedTime()
			local target <const> = 1 / (self.video:getFrameRate() * self.playbackRate)
			frame = self.lastFrame + math.floor(elapsed / target + 0.5)
		end

	end

	if frame < 0 then
		frame = self.video:getFrameCount()
	end

	if frame > self.video:getFrameCount() then
		frame = 0
	end

	self:renderFrame(frame)

end

-- renderFrame(frame)
--
-- Sets the video at the specified frame index and displays it.
function Video:renderFrame(frame)

	if frame ~= self.lastFrame then
		self.video:renderFrame(frame)
		self.lastFrame = frame
		playdate.resetElapsedTime()
	end

	self:draw()

end

function Video:draw()

	self:getContext():draw(0, 0)

end

function Video:flush()

	if self.audio ~= nil then
		self.audio:stop()
	end
	self.audio = nil
	self.video = nil
	self = nil
	collectgarbage("collect")

end

function Video:setMetaData()

	if self.error == nil then
		self.meta = {}
		-- “Last Modified” Timestamp
		local time <const> = pd.file.modtime(self.videoPath)
		self.meta.lastModified = pd.epochFromTime(time)
	end

end

function Video:getMetaData()

	return self.meta

end

function Video:isPlaying()

	return self._isPlaying

end

function Video:play()

	self._isPlaying = true

	-- Open video
	if self.video == nil then
		self.video, videoerr = gfx.video.new(self.videoPath)
		self:setContext(self:getContext())

		-- Return false if there's a problem when opening the video
		if videoerr ~= nil then
			self.error = "Cannot open video at `".. self.videoPath .. "`: [" .. videoerr .. "]"
			return false, self.error
		end
	end

	-- Open audio
	if self.audio == nil then
		self.isADPCM = false
		self.isFilePlayer = false
		if self.audioPath ~= nil then
			-- Try with a sample player first.
			-- Sample player is better because it can play sound backwards. But it's also way heavier in memory.
			self.audio, audioerr = pd.sound.sampleplayer.new(self.audioPath)
			if audioerr == nil then
				-- No error, so we got ourselves a sample player! Yay!
				-- But we need to make sure the sample format is ok to play backwards.
				-- It must not be ADPCM.
				-- (4 = ADPCMMono and 5 = ADPCMStereo)
				local sample = self.audio:getSample()
				local format = sample:getFormat()
				if format == 4 or format == 5 then
					self.isADPCM = true
				end
			else
				local errormsg = "Cannot open audio at `".. self.audioPath .. "` as a sampleplayer: [" .. audioerr .. "]"
				audioerr = nil
				self.audio, audioerr = pd.sound.fileplayer.new(self.audioPath)
				self.isFilePlayer = true
			end

			-- Return nil if there's a problem when opening the audio
			if audioerr ~= nil then
				self.error = "Cannot open audio at `".. self.audioPath .. "` as a fileplayer: [" .. audioerr .. "]"
				return false, self.error
			end
		end
	else
		self:setRate(self.playbackRateBeforePause)
	end
	return true

end

function Video:pause()

	if self.playbackRate ~= 0 then
		self.playbackRateBeforePause = self.playbackRate
	end

	self:setRate(0)
	self._isPlaying = false

end

function Video:stop()

	self._isPlaying = false
	self:flush()

end

function Video:__tostring()

	if self.videoPath ~= nil then
		return "playorama.video: " .. self.videoPath
	else
		return "nil"
	end

end

function Video:setContext(image)

	if self.video ~= nil and image ~= nil then
		self.video:setContext(image)
	end

end

function Video:getContext()

	return self.video:getContext() or gfx.image.new(400, 240, gfx.kColorBlack)

end

-- setRate(rate)
--
-- Sets the playback rate for the video.
-- 1.0 is normal speed, 0.5 is half speed, 0 is paused.
function Video:setRate(rate)

	if self.playbackRate == nil or rate == nil then
		return false
	end

	self.playbackRate = rate
	
	-- Watch for upper limit
	if self.playbackRate > playorama.player.kMaxPlaybackRate then
		self.playbackRate = playorama.player.kMaxPlaybackRate
	end

	-- Watch for lower limit
	if self.playbackRate < playorama.player.kMinPlaybackRate then
		self.playbackRate = playorama.player.kMinPlaybackRate
	end

	if not self:canPlayBackwards() and self.playbackRate < 0 then
		self.playbackRate = 0
	end

	-- Update actual audio player rate
	if self:hasAudio() then
		self.audio:setRate(self.playbackRate)
	end

end

-- getRate()
--
function Video:getRate()

	return self.playbackRate

end

-- canPlayBackwards()
--
function Video:canPlayBackwards()

	return not (self.isFilePlayer or self.isADPCM) or (self.audio == nil)

end

-- getLength()
--
-- Returns the total duration, in seconds.
function Video:getLength()

	return (self.video:getFrameCount() / self.video:getFrameRate())

end

-- getOffset()
--
-- Returns the current offset of the audio player, in seconds.
function Video:getOffset()

	return (self.lastFrame / self.video:getFrameRate())

end

-- setOffset()
--
-- Sets the current offset of the audio player, in seconds.
function Video:setOffset(seconds)

	if self.audio ~= nil and seconds ~= nil then
		self.audio:setOffset(seconds)
	end

end

-- hasAudio()
--
-- Returns a boolean whether the current Video has audio.
function Video:hasAudio()

    return self.audio ~= nil

end

-- setVolume()
--
function Video:setVolume(volume)

	if self.audio then
		self.audio:setVolume(volume)
	end

end

-- isAudioExtension(ext)
--
-- Returns a boolean whether the audio stream ends with `.ext` extension.
function Video:isAudioExtension(ext)

	if self.audioPath ~= nil then
		local i = string.find(string.lower(self.audioPath), ext)
		if i ~= nil and i > 1 then
			return true
		end
	end
	return false

end
