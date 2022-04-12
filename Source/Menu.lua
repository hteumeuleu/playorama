class('Menu').extends()

-- init()
--
function Menu:init()

	Menu.super.init(self)
	print("Menu:init()")
	self.items = {"foo.bar", "baz.xyz"}
	self.gridview = nil
	local arrayCount, hashCount = table.getsize(self.items)
	print(arrayCount .. "/" .. hashCount)
	-- self:init()
	-- self:draw()

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

	function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

		-- Draw background
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(x, y, width, height, 4)

		-- First item video (temporary placeholder)
		if row == 1 and column == 1 then
			local aVideoContext = playdate.graphics.image.new(width, height, playdate.graphics.kColorBlack)
			playdate.graphics.pushContext(aVideoContext)
			local firstVideo = Videorama()
			local firstThumb = firstVideo:getThumbnail()
			firstThumb:draw(0, 0)
			playdate.graphics.popContext()
			aVideoContext:draw(x, y)
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
		local cellText = "*PLAYORAMA "..row.."-"..column.."*"
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