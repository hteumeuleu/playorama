import "Videorama"

-- Fonts
local kFontCuberickBold <const> = playdate.graphics.font.new("fonts/font-Cuberick-Bold")
local kFontRoobertBold <const> = playdate.graphics.font.new("fonts/Roobert-11-Bold")

class('Menu').extends()

-- init()
--
function Menu:init()

	Menu.super.init(self)
	self.items = self:getFiles()
	return self

end

-- update()
--
function Menu:update()

	if self.gridview.needsDisplay == true then
		playdate.graphics.setClipRect(0, 50, 400, 160)
		playdate.graphics.clear(playdate.graphics.kColorBlack)
		self.gridview:drawInRect(0, 50, 400, 160)
		playdate.graphics.clearClipRect()
	end

end

-- reset()
--
function Menu:reset()

	-- Grid view
	self.gridview = playdate.ui.gridview.new(360, 160)
	self.gridview:setNumberOfColumns(#self.items)
	self.gridview:setNumberOfRows(1)
	self.gridview:setCellPadding(5, 5, 0, 0)

	local that = self

	function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

		-- Draw background
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(x, y, width, height, 4)

		-- Draw video thumbnail
		if that.items[column] ~= nil then
			-- Thumbnail context
			local thumbnailContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(thumbnailContext)
				local thumbnail = that.items[column].videorama:getThumbnail()
				local w, h = thumbnail:getSize()
				if thumbnail ~= nil then
					thumbnail:draw((width - w) / 2 + 10, (height - h) / 2 - 10)
				end
			playdate.graphics.popContext()

			-- Thumbnail mask
			local maskImage = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(maskImage)
				playdate.graphics.setColor(playdate.graphics.kColorWhite)
				playdate.graphics.fillRoundRect(0, 0, width, height, 4)
			playdate.graphics.popContext()
			thumbnailContext:setMaskImage(maskImage)

			-- Draw
			thumbnailContext:draw(x, y)
		end

		-- Draw outline if selected
		if selected then
			local outerBorderColor = playdate.graphics.kColorWhite
			local innerBorderColor = playdate.graphics.kColorBlack
			-- Outer border
			playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
			playdate.graphics.setLineWidth(2)
			playdate.graphics.setColor(outerBorderColor)
			playdate.graphics.drawRoundRect(x, y, width, height, 4)
			-- Inner border
			playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
			playdate.graphics.setLineWidth(3)
			playdate.graphics.setColor(innerBorderColor)
			playdate.graphics.drawRoundRect(x+2, y+2, width-4, height-4, 4)
		end

		-- Draw text inside
		local currentFont = playdate.graphics.getFont()
		playdate.graphics.setFont(kFontCuberickBold)
		local textY = math.floor(height - kFontCuberickBold:getHeight() - 9)
		local cellText = that.items[column].videorama:getDisplayName()
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(x+9, y + textY - 1, kFontCuberickBold:getTextWidth(cellText) + 5, kFontCuberickBold:getHeight() + 2, 3)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText(cellText, x+12, y + textY)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
		playdate.graphics.setFont(currentFont)
	end

	-- Setup control handlers
	playdate.inputHandlers.pop()
	playdate.inputHandlers.pop()
	local myInputHandlers = {
		leftButtonUp = function()
			self.gridview:selectPreviousColumn(true)
		end,
		rightButtonUp = function()
			self.gridview:selectNextColumn(true)
		end,
		cranked = function(change, acceleratedChange)
			local ticks = playdate.getCrankTicks(4)
			if ticks == 1 then
				self.gridview:selectNextColumn(true)
			elseif ticks == -1 then
				self.gridview:selectPreviousColumn(true)
			end
		end,
	}
	playdate.inputHandlers.push(myInputHandlers)

	self:draw()

end

-- draw()
--
function Menu:draw()

	-- Black background
	playdate.graphics.clear(playdate.graphics.kColorBlack)

	-- Text title
	local currentFont = playdate.graphics.getFont()
	playdate.graphics.setFont(kFontRoobertBold)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText("playorama", 20, 16)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	playdate.graphics.setFont(currentFont)

end

-- drawError()
--
function Menu:drawError(message)

	local cuberick = playdate.graphics.font.new("fonts/font-Cuberick-Bold")
	playdate.graphics.setFont(cuberick)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText(message, 20, 220)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)

end


-- getFiles()
-- Returns an array of Videorama objects.
--
function Menu:getFiles()

	-- List all available files on the Playdate.
	local kFiles <const> = playdate.file.listFiles()
	-- Init the array we’ll return.
	local availableFiles = {}
	-- Loop through all files.
	for _, fileName in ipairs(kFiles) do
		-- Check if the file name contains '.pdv'.
		local i = string.find(fileName .. '', '.pdv')
		-- If it does, then it's a catch. We've got a video!
		-- Now we'll see if there's a sound file as well.
		if i ~= nil and i > 1 then
			local item = {}
			item.videoPath = fileName
			-- Isolate the video file base name.
			local baseName = string.sub(fileName .. '', 1, i - 1)
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
			-- Create a Videorama and add it to the available files array.
			local videorama, verror = createVideorama(item.videoPath, item.audioPath)
			printTable(item, verror)
			if videorama ~= nil and verror == nil then
				item.videorama = videorama
				table.insert(availableFiles, item)
			end
		end
	end

	-- If no videos were found, we add a secret sample video.
	if #(availableFiles) == 0 then
		local defaultVideo = "assets/sample.pdv"
		local defaultAudio = "assets/sample.pda"
		local defaultVideorama, verror = createVideorama(defaultVideo, defaultAudio)
		local item = {}
		if defaultVideorama ~= nil and verror == nil then
			item.videorama = defaultVideorama
			table.insert(availableFiles, item)
		end
	end

	return availableFiles

end

-- getSelection()
--
function Menu:getSelection()

	local section, row, column = self.gridview:getSelection()
	return self.items[column]

end

-- getSelectionIndex()
--
function Menu:getSelectionIndex()

	local section, row, column = self.gridview:getSelection()
	return column

end

-- setSelection(index)
--
function Menu:setSelection(index)

	self.gridview:setSelection(1, 1, index)
	self.gridview:scrollCellToCenter(1, 1, index, false)

end