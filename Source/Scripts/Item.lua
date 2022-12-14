class('Item').extends()

-- Item
--
-- An item from the library.
-- May be an audio or video for example.
-- item {
-- 	type: "video",
-- 	audioPath: "/",
-- 	videoPath: "/",
-- 	error: "…",
-- }
function Item:init(audioPath, videoPath)

	Item.super.init(self)
	self.uuid = playdate.string.UUID(16)
	self.audioPath = audioPath
	self.videoPath = videoPath
	self:setType()
	return self

end

-- setAudio()
--
function Item:setAudio(audioPath)

	self.audioPath = audioPath
	self:setType()

end

-- setVideo()
--
function Item:setVideo(videoPath)

	self.videoPath = videoPath
	self:setType()

end

-- setType()
--
-- Sets the `type` variable to `audio` or `video`.
function Item:setType()

	if self.videoPath ~= nil then
		self.type = "video"
	elseif self.audioPath ~= nil then
		self.type = "audio"
	else
		self.type = nil
	end

end

-- getType()
--
-- Returns the type of content (either `audio` or `video`).
function Item:getType()

	return self.type

end