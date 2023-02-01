import "Scripts/Common/Icon"

class('ListView').extends(playdate.graphics.sprite)

local arrow <const> = Icon(0, 0, IconChevronRight)
local arrowImage <const> = arrow:getImage()

-- ListView
--
function ListView:init(list)

	ListView.super.init(self)
	self.items = list.items
	self.fullScreen = false
	self:setCenter(0, 0)
	self:setZIndex(100)
	self:setSize(400, 240)
	self:moveTo(0, 0)
	self:initGridView()
	self:initImage()
	return self

end

-- update()
--
function ListView:update()

	ListView.super.update(self)
	if self.gridview ~= nil and self:needsDisplay() then
		self:forceUpdate()
	end

end

-- add()
--
function ListView:add()

	ListView.super.add(self)
	if self.selected ~= nil then
		self.selected:add()
	end
	return self

end

-- remove()
--
function ListView:remove()

	ListView.super.remove(self)
	if self.selected ~= nil then
		self.selected:remove()
	end
	return self

end

-- forceUpdate()
--
function ListView:forceUpdate()

	if self.gridview then
		playdate.graphics.pushContext(self.img)
			playdate.graphics.setClipRect(0, 0, self.width, self.height)
				self:drawGrid()
			playdate.graphics.clearClipRect()
		playdate.graphics.popContext()
		self:setImage(self.img)
	end

end

-- drawGrid()
--
function ListView:drawGrid()

	self.gridview:drawInRect(0, 0, self.width, self.height)

end

-- initImage()
--
function ListView:initImage()

	self.img = playdate.graphics.image.new(self.width, self.height, playdate.graphics.kColorClear)
	playdate.graphics.pushContext(self.img)
		if self.gridview then
			self:drawGrid()
		else
			self:drawEmptyImage()
		end
	playdate.graphics.popContext()
	self:setImage(self.img)

end

-- drawEmptyImage()
--
function ListView:drawEmptyImage()

	-- Background
	local bg = self:getBackgroundImage()
	bg:draw(0,0)
	-- Text
	local currentFont = playdate.graphics.getFont()
	playdate.graphics.setFont(kFontCuberickBold24)
	local fontHeight = kFontCuberickBold24:getHeight()
	playdate.graphics.drawTextInRect("Your library is empty :(", 10, (self.height - fontHeight - 20) / 2, self.width - 20, fontHeight, nil, nil, kTextAlignment.center)
	playdate.graphics.setFont(currentFont)

end

-- getBackgroundImage()
--
function ListView:getBackgroundImage()

	local bg = playdate.graphics.image.new(self.width, self.height, playdate.graphics.kColorClear)
	playdate.graphics.pushContext(bg)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillRoundRect(0, 0, self.width, self.height, 8)
	playdate.graphics.popContext()
	return bg

end

-- initGridView()
--
function ListView:initGridView()

	if not self.gridview and #self.items > 0 then
		self.gridview = playdate.ui.gridview.new(0, 32)
		self.gridview:setNumberOfSections(1)
		self.gridview:setNumberOfColumns(1)
		self.gridview:setNumberOfRows(#self.items)
		self.gridview:setCellPadding(0, 0, 0, 0)
		self.gridview:setContentInset(10, 10, 0, 0)
		self.gridview:setHorizontalDividerHeight(10)
		self.gridview:addHorizontalDividerAbove(1, 1)
		self.gridview:addHorizontalDividerAbove(1, #self.items+1)
		self.gridview.backgroundImage = self:getBackgroundImage()

		local that = self

		if self.selected == nil then
			self.selected = playdate.graphics.sprite.new(playdate.graphics.image.new(self.width-20, 32, playdate.graphics.kColorClear))
			playdate.graphics.pushContext(self.selected:getImage())
				playdate.graphics.setColor(playdate.graphics.kColorBlack)
				playdate.graphics.fillRoundRect(0, 0, self.width-20, 32, 4)
			playdate.graphics.popContext()
			self.selected:setCenter(0,0)
			self.selected:setZIndex(self:getZIndex()+1)
			self.selected:moveTo(10, self.y + 10)
			self.selected:setImageDrawMode(playdate.graphics.kDrawModeNXOR)
			self.selected:add()
		end

		function self.gridview:drawHorizontalDivider(section, x, y, width, height)
		end

		function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

			if section == 1 then
				-- Move selected sprite
				if selected then
					local startValue = playdate.geometry.point.new(that.selected.x, that.selected.y)
					local endValue = playdate.geometry.point.new(x + that.x, y + that.y)
					if that._animator == nil then
						local easingFunction =  playdate.easingFunctions.outElastic
						local startTimeOffset = 0
						local animator = playdate.graphics.animator.new(300, startValue, endValue, easingFunction, startTimeOffset)
						animator.easingAmplitude = 0.5
						animator.easingPeriod = 0.2
						that.selected:setAnimator(animator)
					end
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

	if #self.items > 0 then
		self.gridview:selectPreviousRow(true)
		self:setSelection(self:getSelection())
		self:forceUpdate()
	end

end

-- down()
--
-- Moves the selection down one item in the list.
function ListView:down()

	if #self.items > 0 then
		self.gridview:selectNextRow(true)
		self:setSelection(self:getSelection())
		self:forceUpdate()
	end

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

	if #self.items > 0 then
		self.items[self.gridview:getSelectedRow()].callback()
	end

end