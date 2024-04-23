local pd <const> = playdate
local gfx <const> = pd.graphics
local arrowImage <const> = gfx.image.new("Assets/arrow")

class('ListView').extends(gfx.sprite)

-- ListView
--
function ListView:init(list)

	ListView.super.init(self)
	self.items = list
	self:setCenter(0, 0)
	self:setZIndex(100)
	self:setSize(400, 200)
	self:moveTo(0, 40)
	self:add()
	self:initGridView()
	self:initImage()
	return self

end

-- update()
--
function ListView:update()

	ListView.super.update(self)
	if self.updateAnimator ~= nil then
		self:updateAnimator()
	end
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
		gfx.pushContext(self.img)
			gfx.setClipRect(0, 0, self.width, self.height)
				self:drawGrid()
			gfx.clearClipRect()
		gfx.popContext()
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

	self.img = gfx.image.new(self.width, self.height, gfx.kColorClear)
	gfx.pushContext(self.img)
		if self.gridview then
			self:drawGrid()
		else
			self:drawEmptyImage()
		end
	gfx.popContext()
	self:setImage(self.img)

end

-- drawEmptyImage()
--
function ListView:drawEmptyImage()

	-- Background
	local bg = self:getBackgroundImage()
	bg:draw(0,0)
	-- Text
	local currentFont = gfx.getFont()
	gfx.setFont(playorama.ui.fonts.large)
	local fontHeight = playorama.ui.fonts.large:getHeight()
	gfx.drawTextInRect("Your library is empty :(", 10, (self.height - fontHeight - 20) / 2, self.width - 20, fontHeight, nil, nil, kTextAlignment.center)
	gfx.setFont(currentFont)

end

-- getBackgroundImage()
--
function ListView:getBackgroundImage()

	local bg = gfx.image.new(self.width, self.height, gfx.kColorClear)
	gfx.pushContext(bg)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRoundRect(0, 0, self.width, self.height, 8)
	gfx.popContext()
	return bg

end

-- initGridView()
--
function ListView:initGridView()

	if not self.gridview and #self.items > 0 then
		self.gridview = pd.ui.gridview.new(0, 32)
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
			self.selected = gfx.sprite.new(gfx.image.new(self.width-20, 32, gfx.kColorClear))
			gfx.pushContext(self.selected:getImage())
				gfx.setColor(gfx.kColorBlack)
				gfx.fillRoundRect(0, 0, self.width-20, 32, 4)
			gfx.popContext()
			self.selected:setCenter(0,0)
			self.selected:setZIndex(self:getZIndex()+1)
			self.selected:moveTo(10, self.y + 10)
			self.selected:setImageDrawMode(gfx.kDrawModeNXOR)
			self.selected:add()
		end

		function self.gridview:drawHorizontalDivider(section, x, y, width, height)
		end

		function self.gridview:drawCell(section, row, column, selected, x, y, width, height)

			if section == 1 then
				-- Move selected sprite
				if selected then
					local startValue = pd.geometry.point.new(that.selected.x, that.selected.y)
					local endValue = pd.geometry.point.new(x + that.x, y + that.y)
					if that._animator == nil then
						local easingFunction =  pd.easingFunctions.outElastic
						local startTimeOffset = 0
						local animator = gfx.animator.new(300, startValue, endValue, easingFunction, startTimeOffset)
						animator.easingPeriod = 1
						that.selected:setAnimator(animator)
					end
				end

				-- Draw text
				if that.items[row] ~= nil then
					local currentFont = gfx.getFont()
					gfx.setFont(playorama.ui.fonts.large)
					local fontHeight = playorama.ui.fonts.large:getHeight()
					gfx.drawTextInRect(that.items[row].name, x + 10, y + ((height - fontHeight) / 2), width - 20, fontHeight, nil, "…")
					gfx.setFont(currentFont)
				end

				-- Draw arrow
				if that.items[row].type ~= "video" then
					arrowImage:draw(width - 11, y + 5)
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
		self:setSelection(self.gridview:getSelectedRow())
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

-- updateAnimator()
--
function ListView:updateAnimator()

	if self._animator ~= nil then
		-- Update ListView size
		local currentPoint = self._animator:currentValue()
		local height = math.floor(240 - currentPoint.y + 0.5)
		self:setSize(self.width, height)
		-- Update gridview background and sprite image
		if self.gridview ~= nil then
			self.gridview.backgroundImage = self:getBackgroundImage()
		end
		self:initImage()
		-- Move selected sprite
		if self.selected ~= nil then
			self.selected:removeAnimator()
			self.selected:moveTo(self.selected.x, currentPoint.y + 10)
		end
	end

end

-- isSelectionAPlayer()
--
-- Returns a Boolean if the current selection is a playable item. (And not another ListView item.)
function ListView:isSelectionAPlayer()

	local section, row, column = self.gridview:getSelection()
	return self.items[row].type == "video"

end
