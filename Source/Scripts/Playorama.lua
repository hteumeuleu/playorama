class('Playorama').extends()

-- Playorama
--
function Playorama:init()

	Playorama.super.init(self)
	-- Init app settings for the Playdate
	self:initBackgroundDrawingCallback()
	playdate.setCrankSoundsDisabled(true)
	-- Init widgets
	self:initWidgets()
	-- Init library
	self:initLibrary()
	-- Init menu
	self:initMenu()
	return self

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