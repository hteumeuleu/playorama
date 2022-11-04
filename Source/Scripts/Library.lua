class('Library').extends()

-- Library
--
function Library:init()

	Library.super.init(self)
	self.items = {}
	self.errors = {}
	self:build()
	return self

end

-- build()
--
function Library:build()

	-- List all available files on the Playdate.
	local kFiles <const> = self:getFiles()
	printTable(kFiles)
	-- item {
	-- 	type: "video",
	-- 	audioPath: "/",
	-- 	videoPath: "/",
	-- }

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