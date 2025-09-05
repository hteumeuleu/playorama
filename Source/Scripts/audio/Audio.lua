local pd <const> = playdate
local gfx <const> = pd.graphics

-- Audio class
--
class("Audio").extends()

function Audio:init(audioPath)

	Audio.super.init(self)
	self.audioPath = audioPath

	-- Return if there's no audio.
	if self.audioPath == nil then
		self.error = "Missing audio path."
		return self
	end

	-- No nil up til here? Alright, let's do this!
	self:setMetaData()

	return self

end

function Audio:setMetaData()

	if self.error == nil then
		self.meta = {}
		-- “Last Modified” Timestamp
		local time <const> = pd.file.modtime(self.audioPath)
		self.meta.lastModified = pd.epochFromTime(time)
		-- “On drive” versus “On cartridge”
		-- To know this, we try to open the file with a different writing mode.
		-- A local (“on cartridge”) file cannot be rewritten so it should throw an error.
		local file, fileError = pd.file.open(self.audioPath, pd.file.kSeekFromCurrent)
		if not fileError then
			self.meta.onCartridge = true
			self.meta.onDrive = false
			file:close()
			file = nil
		else
			self.meta.onCartridge = false
			self.meta.onDrive = true
		end
	end

end

function Audio:getMetaData()

	return self.meta

end
