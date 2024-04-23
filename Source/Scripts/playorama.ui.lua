import "Scripts/ui/header/Header"
import "Scripts/ui/menu/Menu"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.ui = {}
playorama.ui.fonts = {}
playorama.ui.fonts.medium = gfx.font.new("Fonts/Cuberick-Bold", playdate.graphics.font.kVariantBold)
playorama.ui.fonts.large = gfx.font.new("Fonts/Cuberick-Bold-24", playdate.graphics.font.kVariantBold)
playorama.ui.homeList = {
	ListItem("Videos", function()
		playorama.ui.menu:push(ListView(playorama.library:getList()))
	end),
	-- ListItem("Extras", function() print("Extras") end),
	ListItem("Settings", function()
		local settingsListArray = {
			ListItem("Foo", function()
				playorama.ui.menu:goTo(1)
			end),
			ListItem("Bar", function()
				playorama.ui.menu:goTo(2)
			end),
			ListItem("Baz", function()
				playorama.ui.menu:goTo(3)
			end)
		}
		playorama.ui.menu:push(ListView(settingsListArray))
	end),
	ListItem("Sync", function() print("Sync") end),
	ListItem("Camera", function() print("Camera") end),
}
