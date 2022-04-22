class('Menu').extends()

-- init()
--
function Menu:init()

	Menu.super.init(self)
	self.items = self:getFiles() or {"foo.bar", "baz.xyz"}
	self.gridview = nil
	return self

end

-- update()
--
function Menu:update()

	playdate.graphics.setClipRect(0, 50, 400, 160)
	playdate.graphics.clear(playdate.graphics.kColorBlack)
	self.gridview:drawInRect(0, 50, 400, 160)
	playdate.graphics.clearClipRect()

end

-- reinit()
--
function Menu:reinit()

	-- Grid view
	self.gridview = playdate.ui.gridview.new(360, 160)
	self.gridview:setNumberOfColumns(table.getsize(self.items))
	self.gridview:setNumberOfRows(1)
	self.gridview:setCellPadding(5, 5, 0, 0)

	local that = self
	printTable(that.items)

	function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

		print("Column:" .. column)

		-- Draw background
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(x, y, width, height, 4)

		-- Draw video thumbnail
		if that.items[column] ~= nil then
			-- local thumbnailContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			-- playdate.graphics.pushContext(thumbnailContext)
			-- local videorama = Videorama(that.items[column].video, that.items[column].audio)
			-- local thumbnail = videorama:getThumbnail()
			-- thumbnail:draw(0, 0)
			-- playdate.graphics.popContext()
			-- thumbnailContext:draw(x, y)
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
	local myInputHandlers = {
		leftButtonUp = function()
			self.gridview:selectPreviousColumn(true)
		end,
		rightButtonUp = function()
			self.gridview:selectNextColumn(true)
		end,
		cranked = function(change, acceleratedChange)
			local ticks = playdate.getCrankTicks(2)
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
			local duo = {}
			duo.video = property
			-- Isolate the file base name
			local baseName = string.sub(property .. '', 1, i - 1)
			-- Try with a '.wav' extension
			local audioExtensions = {'.wav', '.mp3'}
			for _, ext in ipairs(audioExtensions) do
				local audioFileName = baseName .. ext
				if playdate.file.exists(audioFileName) then
					duo.audio = audioFileName
					break
				end
			end
			table.insert(videoFiles, duo)
		end
	end
	return videoFiles

end