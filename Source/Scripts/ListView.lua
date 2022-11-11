class('ListView').extends(playdate.graphics.sprite)

local arrow <const> = Icon(0, 0, IconChevronRight)
local arrowImage <const> = arrow:getImage()

-- ListView
--
function ListView:init(list)

	ListView.super.init(self)
	self.items = list.items
	self:setSize(400, 200)
	self:setCenter(0, 0)
	self:moveTo(0, 40)
	self:setZIndex(9999)
	self:initGridView()
	self:initImage()
	return self

end

-- update()
--
function ListView:update()

	ListView.super.update(self)
	if self.gridview ~= nil and self:needsDisplay() then
		playdate.graphics.pushContext(self.img)
			playdate.graphics.setClipRect(0, 0, self.width, self.height)
				self:drawStuff()
			playdate.graphics.clearClipRect()
		playdate.graphics.popContext()
		self:setImage(self.img)
	end

end

-- forceUpdate()
--
function ListView:forceUpdate()

	playdate.graphics.pushContext(self.img)
		playdate.graphics.setClipRect(0, 0, self.width, self.height)
			self:drawStuff()
		playdate.graphics.clearClipRect()
	playdate.graphics.popContext()
	self:setImage(self.img)

end

-- drawStuff()
--
function ListView:drawStuff()

	playdate.graphics.clear(playdate.graphics.kColorClear)
	-- Background
	playdate.graphics.setColor(playdate.graphics.kColorWhite)
	playdate.graphics.fillRoundRect(0, 0, self.width, self.height, 8)
	-- GridView
	self.gridview:drawInRect(0, 0, self.width, self.height)

end

-- initImage()
--
function ListView:initImage()

	self.img = playdate.graphics.image.new(self.width, self.height, playdate.graphics.kColorClear)
	playdate.graphics.pushContext(self.img)
		self:drawStuff()
	playdate.graphics.popContext()
	self:setImage(self.img)

end

-- initGridView()
--
function ListView:initGridView()

	if not self.gridview then
		self.gridview = playdate.ui.gridview.new(0, 32)
		self.gridview:setNumberOfSections(1)
		self.gridview:setNumberOfColumns(1)
		self.gridview:setNumberOfRows(#self.items)
		self.gridview:setCellPadding(0, 0, 0, 0)
		self.gridview:setContentInset(10, 10, 0, 0)

		local that = self

		function self.gridview:drawSectionHeader(section, x, y, width, height)

				playdate.graphics.setColor(playdate.graphics.kColorWhite)
				playdate.graphics.fillRect(x, y, width, height)

		end

		function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

			if section == 1 then
				-- Draw selected background
				if selected then
					playdate.graphics.setColor(playdate.graphics.kColorBlack)
					playdate.graphics.fillRoundRect(x, y, width, height, 4)
					playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
				end

				-- Draw text
				if that.items[row] ~= nil then
					local currentFont = playdate.graphics.getFont()
					playdate.graphics.setFont(kFontCuberickBold24)
					local fontHeight = kFontCuberickBold24:getHeight()
					playdate.graphics.drawTextInRect(that.items[row].name, x + 10, y + ((height - fontHeight) / 2), width - 20, fontHeight, nil, "…")
					playdate.graphics.setFont(currentFont)
				end

				-- Draw arrow
				arrowImage:draw(width - 11, y + 5)

				-- Reinit DrawMode if selected
				if selected then
					playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
				end
			end

		end
	end
end

-- needsDisplay()
--
function ListView:needsDisplay()

	return self.gridview.needsdisplay

end

-- up()
--
-- Moves the selection up one item in the list.
function ListView:up()

	self.gridview:selectPreviousRow(true)
	self:setSelection(self.gridview:getSelectedRow())
	self:forceUpdate()

end

-- down()
--
-- Moves the selection down one item in the list.
function ListView:down()

	self.gridview:selectNextRow(true)
	self:setSelection(self.gridview:getSelectedRow())
	self:forceUpdate()

end

-- setSelection(index)
--
-- Set the `index` value as the selected item inside the grid view
-- and scrolls the grid view to show it.
function ListView:setSelection(index)

	if index >= 1 and index <= #self.items then
		self.gridview:setSelection(1, index, 1)
		self.gridview:scrollToCell(1, index, 1, false)
	end

end

-- getSelection()
--
-- Returns the `index` of the row currently selected.
function ListView:getSelection()

	return self.gridview:getSelectedRow()

end

-- doSelectionCallback()
--
-- Calls the currently selected row callback function.
function ListView:doSelectionCallback()

	self.items[self.gridview:getSelectedRow()].callback()

end