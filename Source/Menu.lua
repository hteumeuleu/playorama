import "Videorama"

class('Menu').extends()

-- Menu
--
-- This class get all playable files from the System
-- and display them in a slide show.
-- Each item can then be clicked to play a video.
function Menu:init()

	Menu.super.init(self)
	-- The logo image displayed at the top of the screen.
	self.logo = playdate.graphics.image.new("Assets/logo.png")
	-- Get all playable files from the System.
	self.items = self:getFiles()
	-- Get all the thumbnail images from the above items.
	-- This is not optimal, as it can get big the more files there are.
	-- But creating thumbnails within a grid view triggers a memory leak.
	self.thumbnails = self:getThumbnails()
	-- The grid view width and height.
	self.gridWidth = 400
	self.gridHeight = 160
	-- An individual cell, inside the grid view, width and height.
	self.cellWidth = 360
	self.cellHeight = self.gridHeight
	self.cellPadding = 5
	-- If there’s only one playable item, we make the cell’s width larger.
	if #self.items == 1 then
		self.cellWidth = 390
	end
	-- Creates the grid view.
	self:initGridView()
	-- Creates the reel sprite visible in the `O` of the logo.
	self:initReelSprite()
	-- Background drawing callback.
	-- Because we use a sprite (for the reel), we need to have this callback.
	playdate.graphics.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			-- Mark the flag as currently drawing the background.
			-- This is used inside `needsDisplay()` to then trigger a valid `update()`.
			self.isBackgroundDrawing = true
			playdate.graphics.setClipRect(x, y, width, height)
				self:drawLogo() -- The logo is below the reel sprite.
				self:update() -- Update the grid view.
			playdate.graphics.clearClipRect()
			-- We’re done so we can mark this flag as false.
			self.isBackgroundDrawing = false
		end
	)

	return self

end

-- update()
--
-- Method invoked on every cycle to update what needs to be updated.
-- (Mainly: the reel sprite and the grid view if needed.)
function Menu:update()

	-- Update all sprites. (I mean, the only one — the reel in the logo.)
	playdate.graphics.sprite.update()
	-- Update the grid view if needed.
	if self:needsDisplay() then
		playdate.graphics.setClipRect(0, 60, self.gridWidth, self.gridHeight)
			-- Clear the screen. (Otherwise we'd see traces of previous items.)
			playdate.graphics.clear(playdate.graphics.kColorBlack)
			-- Draw the grid view.
			self.gridview:drawInRect(0, 60, self.gridWidth, self.gridHeight)
		playdate.graphics.clearClipRect()
		-- Saves the x scroll position of the grid. This is useful when using the crank.
		self.gridX = self.gridview:getScrollPosition()
	end

end

-- needsDisplay()
--
-- Returns a Boolean if the grid needs to be displayed.
function Menu:needsDisplay()

	return self.gridview.needsDisplay or self.isPressed or self.isBackgroundDrawing

end

-- initGridView()
--
-- Creates the grid view object used throughout the menu.
function Menu:initGridView()

	-- Creates the grid view.
	self.gridview = playdate.ui.gridview.new(self.cellWidth, self.cellHeight)
	self.gridview:setNumberOfColumns(#self.items)
	self.gridview:setNumberOfRows(1)
	self.gridview:setCellPadding(self.cellPadding, self.cellPadding, 0, 0)
	-- The current scroll position inside the grid view.
	self.gridX = 0
	-- Copy the current instance of Menu to use within the grid drawCell method.
	local that = self
	-- drawCell callback method.
	function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

		-- Variables to create a pressed button effect on the current item.
		local kButtonTopOffset = 0
		local kButtonBottomOffset = 2
		if selected and that.isPressed then
			kButtonTopOffset = 2
			kButtonBottomOffset = 0
		end

		-- Item outline.
		-- White if the current item is selected. Checkboard pattern otherwise.
		if selected then
			playdate.graphics.setColor(playdate.graphics.kColorWhite)
		else
			playdate.graphics.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
		end
		playdate.graphics.fillRoundRect(x, y+kButtonTopOffset, width, height-kButtonTopOffset, 4)

		-- Thumbnail image.
		if that.items[column] ~= nil then
			-- Creates a context and draw the thumbnail image inside.
			local thumbnailContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(thumbnailContext)
				local thumbnail = that.thumbnails[column]
				local thumbnailWidth, thumbnailHeight = thumbnail:getSize()
				if thumbnail ~= nil then
					thumbnail:draw((width - thumbnailWidth) / 2 + 10, (height - thumbnailHeight) / 2 - 10)
				end
			playdate.graphics.popContext()
			-- Creates a rounded rectangle mask and add it to the previous context.
			local maskImage = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(maskImage)
				playdate.graphics.setColor(playdate.graphics.kColorWhite)
				playdate.graphics.fillRoundRect(4, 4, width-8, height-8-kButtonBottomOffset, 4)
			playdate.graphics.popContext()
			thumbnailContext:setMaskImage(maskImage)
			-- Draws the context.
			thumbnailContext:draw(x, y+kButtonTopOffset)
		end

		-- Black inner outline.
		playdate.graphics.setStrokeLocation(playdate.graphics.kStrokeInside)
		playdate.graphics.setLineWidth(3)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.drawRoundRect(x+2, y+2+kButtonTopOffset, width-4, height-4-kButtonTopOffset-kButtonBottomOffset, 4)

		-- Text badge with the video title.
		local font = playdate.graphics.getFont()
		local textY = math.floor(height - font:getHeight() - 9 - kButtonBottomOffset)
		local cellText = that.items[column]:getDisplayName()
		-- Black rectangle background.
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRoundRect(x+9, y + textY - 1, math.min(font:getTextWidth(cellText) + 5, width - 18), font:getHeight() + 2, 3)
		-- White text over it.
		local previousDrawMode = playdate.graphics.getImageDrawMode()
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawTextInRect(cellText, x+12, y + textY, width - 24, font:getHeight(), nil, "…")
		playdate.graphics.setImageDrawMode(previousDrawMode)
	end

end

-- setInputHandlers()
--
-- Set input handlers used in the Menu.
function Menu:setInputHandlers()

	playdate.inputHandlers.pop() -- Player.lua
	playdate.inputHandlers.pop() -- main.lua
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
			local maxScroll = ((self.cellWidth + (self.cellPadding * 2)) * (cols - 1))
			local newX = math.floor(self.gridX + change)
			if (newX < maxScroll) and (newX >= 0) then
				self.gridX = newX
				local err = self.gridview:setScrollPosition(self.gridX, 0, false)
				-- Sets the currently most visible item as the selection.
				local _, _, column = self.gridview:getSelection()
				local index = math.floor((self.gridX / (self.cellWidth / 2)) / 2 + 0.5) + 1
				if(column ~= index) then
					self.gridview:setSelection(1, 1, index)
				end
				-- Sets a timer to detect the end of cranking.
				local function autoScrollAfterCrank(index)
					self.gridview:setSelection(1, 1, index)
					-- Because of the lack of callback after grid view animations,
					-- we save the current x position of the grid view…
					local oldX = self.gridX
					-- Then we move it to its desired value, without animation.
					self.gridview:scrollCellToCenter(1, 1, index, false)
					-- We save the x value as the new self.gridX.
					self.gridX = self.gridview:getScrollPosition()
					-- Then we position the grid back to its previous position…
					self.gridview:setScrollPosition(oldX, 0, false)
					-- And animate it to its new one.
					self.gridview:scrollCellToCenter(1, 1, index, true)
					self.crankTimer:remove()
				end
				if(self.crankTimer ~= nil) then
					self.crankTimer:remove()
				end
				self.crankTimer = playdate.timer.performAfterDelay(100, autoScrollAfterCrank, index)
			end
			-- Sprite rotation.
			if self.sprite then
				local r = self.sprite:getRotation()
				self.sprite:setRotation(r + change)
			end
		end,
	}
	playdate.inputHandlers.push(myInputHandlers)

end

-- reset()
--
function Menu:reset()

	self.isPressed = false
	self:setInputHandlers()
	self:drawLogo()

end

-- getFilesRecursive(path)
--
-- Returns a list of available files recursively.
local function getFilesRecursive(path)

	local files = {}
	if not path then
		path = "/"
	end
	local currentFiles = playdate.file.listFiles(path)
	for _, currentPath in ipairs(currentFiles) do
		if playdate.file.isdir(path .. currentPath) then
			local subfolderFiles = getFilesRecursive(path .. currentPath)
			for _, subPath in ipairs(subfolderFiles) do
				table.insert(files, subPath)
			end
		else
			table.insert(files, path .. currentPath)
		end
	end
	return files

end

-- getFiles()
--
-- Returns an array of Videorama objects.
function Menu:getFiles()

	-- List all available files on the Playdate.
	local kFiles <const> = getFilesRecursive("Bundle/")
	-- Init the array we’ll return.
	local availableFiles = {}
	-- Loop through all files.
	for _, fileName in ipairs(kFiles) do
		-- Check if the file name contains '.pdv'.
		local i = string.find(fileName .. '', '.pdv')
		-- If it does, then it's a catch. We've got a video!
		-- Now we'll see if there's a sound file as well.
		-- But we’re also excluding the sample video from here for now.
		-- (We only want it to appear if there’s no user video.)
		if i ~= nil and i > 1 and fileName ~= "assets/sample.pdv" then
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

	return availableFiles

end

-- getThumbnails()
--
-- Returns an array with still images from every videos.
function Menu:getThumbnails()

	local thumbs = {}
	for i, videorama in ipairs(self.items) do
		local thumbnail = videorama:getThumbnail()
		table.insert(thumbs, thumbnail)
		if (i%64 == 0) or (i==#self.items) then
			collectgarbage("collect")
		end
	end
	return thumbs

end

-- getSelection()
--
-- Returns the `Videorama` object corresponding to the current selection.
function Menu:getSelection()

	local section, row, column = self.gridview:getSelection()
	return self.items[column]

end

-- getSelectionIndex()
--
-- Returns a number corresponding to the current selection index.
function Menu:getSelectionIndex()

	local section, row, column = self.gridview:getSelection()
	return column

end

-- setSelection(index)
--
-- Set the `index` value as the selected item inside the grid view
-- and scrolls the grid view to show it.
function Menu:setSelection(index)

	self.gridview:setSelection(1, 1, index)
	self.gridview:scrollCellToCenter(1, 1, index, false)

end

-- initReelSprite()
--
-- Creates the sprite for the reel on the logo.
function Menu:initReelSprite()

	local img = playdate.graphics.image.new(21, 21)
	playdate.graphics.pushContext(img)
		-- The reel consists of one main white circle…
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillCircleInRect(0, 0, 21, 21)
		-- … And five smaller inner black circles.
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

end

-- drawLogo()
--
-- Draw the Playorama logo image, at the top of the screen,
-- centered within a 400x60 rectangle.
function Menu:drawLogo()

	if self.logo ~= nil then
		self.logo:drawCentered(200, 30)
	end

end