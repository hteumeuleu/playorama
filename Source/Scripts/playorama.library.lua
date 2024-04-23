local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.library = {}

-- Library class
--
class('Library').extends()

function Library:init()

	Library.super.init(self)
	self.items = {}
	self:build()
	return self

end

-- Returns the first item of the library
function Library:pop()

	return self.items[#self.items]

end

function Library:build()

	-- List all available files on the Playdate.
	local kFiles <const> = self:getFiles()
	-- Loop through all files.
	for i, fileName in ipairs(kFiles) do
		-- Check if the file name contains '.pdv'.
		local n = string.find(fileName .. '', '.pdv')
		-- If it does, then it's a catch. We've got a video!
		-- Now we'll see if there's a sound file as well.
		if n ~= nil and n > 1 then
			local item = {}
			item.uuid = playdate.string.UUID(16)
			item.type = "video"
			item.videoPath = fileName
			-- Isolate the video file base name.
			local baseName = string.sub(fileName .. '', 1, n - 1)
			item.name = removeFormatting(baseName)
			-- Define different supported audio extensions.
			-- Contrary to what the docs say, the Playdate can not
			-- read a '.wav' file from the file system.
			-- Trust me, I spent hours figuring this out.
			local audioExtensions = {'.pda', '.mp3'}
			-- Loop through supported audio extensions.
			for _, ext in ipairs(audioExtensions) do
				-- Define what the audio file name might be.
				local audioFileName = baseName .. ext
				-- If this file exists, then hurray! We've got audio!
				if playdate.file.exists(audioFileName) then
					item.audioPath = audioFileName
					break
				end
			end
			-- Create a Video and add it to the available files array.
			local video, verror = playorama.video.new(item.videoPath, item.audioPath)
			if video ~= nil and verror == nil then
				item.lastModified = video.meta.lastModified
				item.callback = function()
					pd.display.setRefreshRate(30)
					playorama.player.new(playorama.video.new(item.videoPath, item.audioPath))
					print(item.videoPath)
				end
				table.insert(self.items, item)
			end
			-- Playdate limits to 64 simultaneous open files.
			-- To prevent a crash due to too much opened files, we do manual garbage collection.
			-- @see https://devforum.play.date/t/too-many-open-files-after-opening-videos/10780/3
			if (i%64 == 0) or (i==#kFiles) then
				collectgarbage("collect")
			end
		end
	end
	self:sort()

end

-- sort()
--
-- Sort library by last modified date.
function Library:sort()

	table.sort(self.items, function (left, right)
		return left.lastModified > right.lastModified
	end)

end

-- getFiles()
--
-- Recursive function.
-- Returns a list of available files.
function Library:getFiles(path)

	local files = {}
	if not path then
		path = "/"
	end
	local currentFiles = pd.file.listFiles(path)
	for _, currentPath in ipairs(currentFiles) do
		if pd.file.isdir(currentPath) then
			local subfolderFiles = self:getFiles(path .. currentPath)
			for _, subPath in ipairs(subfolderFiles) do
				table.insert(files, currentPath .. subPath)
			end
		else
			table.insert(files, currentPath)
		end
	end
	return files

end

-- get()
--
-- Returns the library as a table.
function Library:getList()

	return self.items

end
