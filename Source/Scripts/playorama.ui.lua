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

playorama.ui.setAnimator = function(startValue, endValue, callback)

	if playorama.ui._animator == nil then
		local duration <const> = 500
		local startValue <const> = startValue or pd.geometry.point.new(0, 0)
		local endValue <const> = endValue or pd.geometry.point.new(0, -40)
		local easingFunction <const> = pd.easingFunctions.outElastic
		playorama.ui._animator = gfx.animator.new(duration, startValue, endValue, easingFunction)
		if callback then 
			playorama.ui._animatorCallback = callback
		end
	end

end

playorama.ui.update = function()

	if playorama.ui._animator ~= nil then
		local value <const> = playorama.ui._animator:currentValue()
		print(value)
		if value.x and value.y then
			gfx.setDrawOffset(value.x, value.y)
		end
		if playorama.ui._animator:ended() then
			if playorama.ui._animatorCallback ~= nil then
				playorama.ui._animatorCallback()
			end
			playorama.ui._animator = nil
			playorama.ui._animatorCallback = nil
		end
	end

end
