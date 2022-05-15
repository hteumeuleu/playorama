class('Menu').extends()

-- init()
--
function Menu:init()

	Menu.super.init(self)
	self.items = self:getFiles()
	self.gridview = nil
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
				local thumbnail = that.items[column].thumbnail
				if thumbnail ~= nil then
					thumbnail:draw(0, 0)
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
		local kControlsFont <const> = playdate.graphics.getFont()
		local textY = math.floor((height - kControlsFont:getHeight()) / 2)
		local cellText = that.items[column].video..""
		playdate.graphics.drawTextInRect(cellText, x, y + textY, width, height, nil, nil, kTextAlignment.center)
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
	local roobert = playdate.graphics.font.new("fonts/Roobert-11-Bold")
	playdate.graphics.setFont(roobert)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	playdate.graphics.drawText("playorama", 20, 16)
	playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)

end


-- getFiles()
--
function Menu:getFiles()

	local files = playdate.file.listFiles()
	local videoFiles = {}
	for key, property in ipairs(files) do
		-- Get the index of the '.pdv' extension
		local i = string.find(property .. '', '.pdv')
		-- If this is a video, check if there’s a sound file
		if i ~= nil and i > 1 then
			local duo = nil
			-- Isolate the file base name
			local baseName = string.sub(property .. '', 1, i - 1)
			-- Try with different audio extensions
			local audioExtensions = {'.pda', '.wav', '.mp3'}
			for _, ext in ipairs(audioExtensions) do
				local audioFileName = baseName .. ext
				if playdate.file.exists(audioFileName) then
					duo = {}
					duo.video = property
					duo.thumbnail = getThumbnail(property)
					duo.audio = audioFileName
					if duo ~= nil then
						table.insert(videoFiles, duo)
					end
					break
				end
			end
		end
	end

	-- Add default sample video
	duo = {}
	duo.video = "assets/sample.pdv"
	duo.thumbnail = getThumbnail("assets/sample.pdv")
	duo.audio = "assets/sample.pda"
	table.insert(videoFiles, duo)

	return videoFiles

end

-- getThumbnail()
--
function getThumbnail(videoPath)

	local thumbnail = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
	local video, videoerr = playdate.graphics.video.new(videoPath)
	if videoerr ~= nil then
		return nil
	end
	video:setContext(thumbnail)
	local frame = math.floor(video:getFrameCount() / 4)
	video:renderFrame(frame)
	return thumbnail

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