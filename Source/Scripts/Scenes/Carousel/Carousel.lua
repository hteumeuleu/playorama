import "Scripts/Scenes/Scene"

class('Carousel').extends('Scene')

-- Carousel
--
function Carousel:init(library)

	Carousel.super.init(self)
	-- Get all playable files from the System.
	if library ~= nil and library.items ~= nil then
		self.items = library.items
	end
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
	-- The actual sprite where we'll draw everything
	local img <const> = playdate.graphics.image.new(self.gridWidth, self.gridHeight, playdate.graphics.kColorClear)
	self:setImage(img)
	self:moveTo(0, 40)
	-- Creates the grid view.
	self:initGridView()
	-- Add the carousel to the screen
	self:add()
	return self

end

-- update()
--
function Carousel:update()

	Carousel.super.update(self)

	-- Update the grid view if needed.
	if self:needsDisplay() then
		local img <const> = self:getImage()
		playdate.graphics.pushContext(img)
			-- Clear the screen. (Otherwise we'd see traces of previous items.)
			playdate.graphics.clear(playdate.graphics.kColorBlack)
			-- Draw the grid view.
			self.gridview:drawInRect(0, 0, self.gridWidth, self.gridHeight)
		playdate.graphics.popContext()
		-- Saves the x scroll position of the grid. This is useful when using the crank.
		self.gridX = self.gridview:getScrollPosition()
	end

end

-- initGridView()
--
-- Creates the grid view object used throughout the menu.
function Carousel:initGridView()

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
		local cellText = that.items[column].objectorama:getDisplayName()
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

-- needsDisplay()
--
-- Returns a Boolean if the grid needs to be displayed.
function Carousel:needsDisplay()

	return self.gridview.needsDisplay or self.isPressed

end



-- getThumbnails()
--
-- Returns an array with still images from every videos.
function Carousel:getThumbnails()

	local thumbs = {}
	for i, item in ipairs(self.items) do
		local videorama = item.objectorama
		if videorama ~= nil then
			local thumbnail = videorama:getThumbnail()
			table.insert(thumbs, thumbnail)
		end
		if (i%64 == 0) or (i==#self.items) then
			collectgarbage("collect")
		end
	end
	return thumbs

end
