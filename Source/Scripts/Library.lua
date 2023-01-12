import "Item"

class('Library').extends()

-- Library
--
function Library:init()

	Library.super.init(self)
	self.items = {}
	self:build()
	return self

end

-- build()
--
-- item {
-- 	type: "video",
-- 	audioPath: "/",
-- 	videoPath: "/",
-- 	error: "…",
-- }
function Library:build()

	-- List all available files on the Playdate.
	local kFiles <const> = self:getFiles()
	-- Loop through all files.
	for _, fileName in ipairs(kFiles) do
		-- Check if the file name contains '.pdv'.
		local i = string.find(fileName .. '', '.pdv')
		-- If it does, then it's a catch. We've got a video!
		-- Now we'll see if there's a sound file as well.
		if i ~= nil and i > 1 then
			local item = {}
			item.uuid = playdate.string.UUID(16)
			item.type = "video"
			item.videoPath = fileName
			-- Isolate the video file base name.
			local baseName = string.sub(fileName .. '', 1, i - 1)
			item.name = removeFormatting(baseName)
			-- Define different supported audio extensions.
			-- Contrary to what the docs say, the Playdate can not
			-- read a '.wav' file from the file system.
			-- Trust me, I spent hours figuring this out.
			local audioExtensions = {'.pda', '.mp3', '.m4a'}
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
			-- Create a Videorama and add it to the available files array.
			local videorama, verror = createVideorama(item.videoPath, item.audioPath)
			if videorama ~= nil and verror == nil then
				item.objectorama = videorama
				table.insert(self.items, item)
			end
		end
	end

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
	local currentFiles = playdate.file.listFiles(path)
	for _, currentPath in ipairs(currentFiles) do
		if playdate.file.isdir(currentPath) then
			local subfolderFiles = self:getFiles(currentPath)
			for _, subPath in ipairs(subfolderFiles) do
				table.insert(files, currentPath .. subPath)
			end
		else
			table.insert(files, currentPath)
		end
	end
	return files

end

-- toList()
--
-- Returns the library as a List object.
function Library:toList(type)

	local libraryList = {}
	for _, item in ipairs(self.items) do
		if type == nil or (item.type ~= nil and item.type == type) then
			local listItem = ListItem(item.name, function()
				local vp = VideoPlayer(item)
				local menu = getMenu()
				menu:remove()
			end)
			table.insert(libraryList, listItem)
		end
	end
	return List(libraryList)

end