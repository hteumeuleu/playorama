import "Videorama"

class('Menu').extends()

-- init()
--
function Menu:init()

	Menu.super.init(self)
	self.items = self:getFiles()
	self.thumbnails = self:getThumbnails()
	self.x = 0
	self.gridWidth = 400
	self.gridHeight = 160
	self.cellWidth = 360
	self.cellHeight = self.gridHeight
	if #self.items == 1 then
		self.cellWidth = 390
	end
	self.logo = playdate.graphics.image.new("assets/logo")
	self:buildReelSprite()

	-- Background
	playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
	playdate.graphics.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			self.isBackgroundDrawing = true
			playdate.graphics.setClipRect(x, y, width, height)
				playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
				self:draw()
				self:update()
			playdate.graphics.clearClipRect()
			self.isBackgroundDrawing = false
		end
	)

	return self

end

-- update()
--
function Menu:update()

	playdate.graphics.sprite.update()
	if self:needsDisplay() then
		playdate.graphics.setClipRect(0, 60, self.gridWidth, self.gridHeight)
			playdate.graphics.clear(playdate.graphics.kColorBlack)
			self.gridview:drawInRect(0, 60, self.gridWidth, self.gridHeight)
		playdate.graphics.clearClipRect()
		self.x = self.gridview:getScrollPosition()
	end

end

-- needsDisplay()
--
-- Returns a Boolean if the grid needs to be displayed.
function Menu:needsDisplay()

	return self.gridview.needsDisplay or self.isPressed or self.isBackgroundDrawing

end

-- reset()
--
function Menu:reset()

	self.isPressed = false

	-- Grid view
	self.gridview = playdate.ui.gridview.new(self.cellWidth, self.cellHeight)
	self.gridview:setNumberOfColumns(#self.items)
	self.gridview:setNumberOfRows(1)
	self.gridview:setCellPadding(5, 5, 0, 0)

	local that = self

	function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

		local kButtonTopOffset = 0
		local kButtonBottomOffset = 2

		if selected and that.isPressed then
			kButtonTopOffset = 2
			kButtonBottomOffset = 0
		end

		-- White background
		if selected then
			playdate.graphics.setColor(playdate.graphics.kColorWhite)
		else
			playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
		end
		playdate.graphics.fillRoundRect(x, y+kButtonTopOffset, width, height-kButtonTopOffset, 4)

		-- Draw video thumbnail
		if that.items[column] ~= nil then
			-- Thumbnail context
			local thumbnailContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(thumbnailContext)
				local thumbnail = that.thumbnails[column]
				local w, h = thumbnail:getSize()
				if thumbnail ~= nil then
					thumbnail:draw((width - w) / 2 + 10, (height - h) / 2 - 10)
				end
			playdate.graphics.popContext()

			-- Thumbnail mask
			local maskImage = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(maskImage)
				playdate.graphics.setColor(playdate.graphics.kColorWhite)
				playdate.graphics.fillRoundRect(4, 4, width-8, height-8-kButtonBottomOffset, 4)
			playdate.graphics.popContext()
			thumbnailContext:setMaskImage(maskImage)

			-- Draw
			thumbnailContext:draw(x, y+kButtonTopOffset)
		end

		-- Inner border
		playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
		playdate.graphics.setLineWidth(3)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.drawRoundRect(x+2, y+2+kButtonTopOffset, width-4, height-4-kButtonTopOffset-kButtonBottomOffset, 4)

		-- Draw text inside
		local currentFont = playdate.graphics.getFont()
		playdate.graphics.setFont(gFontCuberickBold)
		local textY = math.floor(height - gFontCuberickBold:getHeight() - 9 - kButtonBottomOffset)
		local cellText = that.items[column]:getDisplayName()
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(x+9, y + textY - 1, gFontCuberickBold:getTextWidth(cellText) + 5, gFontCuberickBold:getHeight() + 2, 3)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawText(cellText, x+12, y + textY)
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
		playdate.graphics.setFont(currentFont)
	end

	-- Setup control handlers
	playdate.inputHandlers.pop()
	playdate.inputHandlers.pop()
	local myInputHandlers = {
		AButtonDown = function()
			self.isPressed = true
		end,
		AButtonUp = function()
			self.isPressed = false
		end,
		leftButtonUp = function()
			self.gridview:selectPreviousColumn(true)
		end,
		rightButtonUp = function()
			self.gridview:selectNextColumn(true)
		end,
		cranked = function(change, acceleratedChange)
			local cols = self.gridview:getNumberOfColumns()
			local maxScroll = (self.cellWidth * (cols - 1)) + (self.gridWidth - self.cellWidth)
			local newX = math.floor(self.x + change)
			if (newX <= maxScroll) and (newX >= 0) then
				self.x = newX
				self.gridview:setScrollPosition(self.x, 0, false)
				-- Sets the currently most visible item as the selection
				local _, _, column = self.gridview:getSelection()
				local index = math.floor((self.x / (self.cellWidth / 2)) / 2 + 0.5) + 1
				if(column ~= index) then
					self.gridview:setSelection(1, 1, index)
				end
				-- Sets a timer to detect the end of cranking
				local function autoScrollAfterCrank(index)
					self.gridview:setSelection(1, 1, index)
					-- Because of the lack of callback after grid view animations,
					-- we save the current x position of the grid view…
					local oldX = self.x
					-- Then we move it to its desired value, without animation.
					self.gridview:scrollCellToCenter(1, 1, index, false)
					-- We save the x value as the new self.x.
					self.x = self.gridview:getScrollPosition()
					-- Then we position the grid back to its previous position…
					self.gridview:setScrollPosition(oldX, 0, false)
					-- And animate it to its new one.
					self.gridview:scrollCellToCenter(1, 1, index, true)
				end
				if(self.crankTimer ~= nil) then
					self.crankTimer:remove()
				end
				self.crankTimer = playdate.timer.performAfterDelay(300, autoScrollAfterCrank, index)
			end
			-- Sprite rotation
			if self.sprite then
				local r = self.sprite:getRotation()
				self.sprite:setRotation(r + change)
			end
		end,
	}
	playdate.inputHandlers.push(myInputHandlers)

	self:draw()

end

-- draw()
--
function Menu:draw()

	-- Logo
	self.logo:drawCentered(200, 30)

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
				table.insert(availableFiles, videorama)
			end
		end
	end

	-- If no videos were found, we add a secret sample video.
	if #(availableFiles) == 0 then
		local defaultVideo = "assets/sample.pdv"
		local defaultAudio = "assets/sample.pda"
		local defaultVideorama, verror = createVideorama(defaultVideo, defaultAudio)
		if defaultVideorama ~= nil and verror == nil then
			table.insert(availableFiles, defaultVideorama)
		end
	end

	table.sort(availableFiles, function (left, right)
		return left.lastModified > right.lastModified
	end)

	return availableFiles

end

-- getThumbnails()
--
function Menu:getThumbnails()

	local thumbs = {}
	for _, videorama in ipairs(self.items) do
		local thumbnail = videorama:getThumbnail()
		table.insert(thumbs, thumbnail)
	end
	return thumbs

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

-- buildReelSprite()
--
function Menu:buildReelSprite()

	local img = playdate.graphics.image.new(21, 21)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillCircleInRect(0, 0, 21, 21)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillCircleInRect(8, 1, 6, 6)
		playdate.graphics.fillCircleInRect(1, 6, 6, 6)
		playdate.graphics.fillCircleInRect(14, 6, 6, 6)
		playdate.graphics.fillCircleInRect(4, 13, 6, 6)
		playdate.graphics.fillCircleInRect(11, 13, 6, 6)
	playdate.graphics.popContext()
	self.sprite = playdate.graphics.sprite.new(img)
	self.sprite:moveTo(196, 33)
	self.sprite:add()
	self.sprite:update()

end