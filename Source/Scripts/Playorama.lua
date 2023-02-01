class('Playorama').extends()

-- Playorama
--
function Playorama:init()

	Playorama.super.init(self)
	-- Init app settings for the Playdate
	self:initBackgroundDrawingCallback()
	playdate.setCrankSoundsDisabled(true)
	-- Init mask
	self:initMask()
	-- Init widgets
	self:initWidgets()
	-- Init library
	self:initLibrary()
	-- Init menu
	self:initMenu()
	return self

end

function Playorama:update()

	local current, pressed, released = playdate.getButtonState()
	if released == playdate.kButtonA|playdate.kButtonUp then
		print("A+Up")
	elseif released == playdate.kButtonUp then
		print("Up")
	elseif released == playdate.kButtonDown then
		print("Down")
	elseif released == playdate.kButtonA then
		print("A")
	elseif released == playdate.kButtonB then
		print("B")
	end

end

-- initMask()
--
function Playorama:initMask()

	local img = playdate.graphics.image.new(400, 240, playdate.graphics.kColorClear)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRect(0, 0, 400, 240)
		playdate.graphics.setColor(playdate.graphics.kColorClear)
		playdate.graphics.fillRoundRect(0, 0, 400, 240, 8)
	playdate.graphics.popContext()
	self.mask = playdate.graphics.sprite.new(img)
	self.mask:setCenter(0, 0)
	self.mask:moveTo(0, 0)
	self.mask:setZIndex(999)
	self.mask:setUpdatesEnabled(false)
	self.mask:add()

end

-- initWidgets()
--
function Playorama:initWidgets()

	-- TODO

end

-- initLibrary()
--
function Playorama:initLibrary()

	self.library = Library()

end

-- initMenu()
--
function Playorama:initMenu()

	local homeList <const> = {
		ListItem("Music", function()
			self.menu:push(ListView(self.library:toList("audio")))
		end),
		ListItem("Videos", function()
			self.menu:push(ListView(self.library:toList("video")))
		end),
		ListItem("Extras", function() self.menu:goTo(3) end),
		ListItem("Settings", function()
			local settingsListArray = {
				ListItem("Foo", function()
					self.menu:goTo(1)
				end),
				ListItem("Bar", function()
					self.menu:goTo(2)
				end),
				ListItem("Baz", function()
					self.menu:goTo(3)
				end)
			}
			self.menu:push(ListView(List(settingsListArray)))
		end),
		ListItem("Sync", function() self.menu:goTo(5) end),
	}
	local list <const> = List(homeList)
	self.menu = Menu(list)

end

function Playorama:getMenu()

	return self.menu

end

-- initBackgroundDrawingCallback()
--
-- Inits an empty drawing callback function to always draw a black background.
function Playorama:initBackgroundDrawingCallback()

	playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
	playdate.graphics.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
		end
	)

end