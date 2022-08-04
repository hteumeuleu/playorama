class('Log').extends()

-- Log
--
-- This class keeps track of I/O errors.
function Log:init()

	Log.super.init(self)
	self.data = {}
	self.sprite = playdate.graphics.sprite.new()
	self.sprite:setVisible(false)
	self.sprite:setSize(400, 240)
	self.sprite:moveTo(200, 120)
	self.sprite:setZIndex(1)
	return self

end

-- update
--
function Log:update()

	playdate.graphics.sprite.update()

	if not self.sprite:isVisible() then
		self:setImage()
		self.sprite:setVisible(true)
		self.sprite:add()
	end

end

-- unload
--
function Log:unload()

	self.sprite:setVisible(false)
	self.sprite:remove()

end

-- setImage
--
function Log:setImage()

	local text = ""
	for _, line in ipairs(self.data) do
		text = text .. line .. "\n"
	end

	if text == "" then
		text = "No errors."
	end

	local img = playdate.graphics.image.new(self.sprite.width, self.sprite.height)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRect(0, 0, self.sprite.width, self.sprite.height)
		-- Draw text
		local font = playdate.graphics.getFont()
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		playdate.graphics.drawTextInRect(text, 8, 8, 400 - 16, 240 - 24 - font:getHeight(), nil, "…")
		-- Draw back to menu indication
		local previousfont = playdate.graphics.getFont()
		font = playdate.graphics.getSystemFont()
		playdate.graphics.setFont(font)
		playdate.graphics.drawTextInRect("Ⓑ *Back to menu*", 8, 240 - 8 - font:getHeight(), 400 - 16, font:getHeight(), nil, "…")
		-- Reset previous Font and DrawMode
		playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeCopy)
		playdate.graphics.setFont(previousfont)
	playdate.graphics.popContext()
	self.sprite:setImage(img)

end

-- add
--
-- Adds a new entry into the log
function Log:add(item)

	table.insert(self.data, item)

end

-- reset
--
-- Resets all data logged
function Log:reset()

	self.data = {}

end