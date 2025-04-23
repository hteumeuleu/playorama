import "Scripts/ui/header/Header"
import "Scripts/ui/menu/Menu"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.ui = {}
playorama.ui.fonts = {}
playorama.ui.fonts.medium = gfx.font.new("Fonts/Cuberick-Bold", playdate.graphics.font.kVariantBold)
playorama.ui.fonts.large = gfx.font.new("Fonts/Cuberick-Bold-24", playdate.graphics.font.kVariantBold)
playorama.ui.fonts.numbers = gfx.font.new("Fonts/Cuberick-Numbers", playdate.graphics.font.kVariantBold)
playorama.ui.homeList = {
	MenuItem("This is a very long list item label that should be truncated", function()
		playorama.ui.menu:goTo(1)
	end),
	MenuItem("Videos", function()
		playorama.ui.menu:push(ListView(playorama.library:getList()))
	end),
	MenuItem("Camera", function() print("Camera") end),
	MenuItem("Settings", function()
		local settingsListArray = {
			MenuItem("About", function()
				playorama.ui.menu:goTo(1)
			end),
			MenuItem("Audio", function()
				playorama.ui.menu:goTo(2)
			end),
			MenuItem("Language", function()
				playorama.ui.menu:goTo(3)
			end),
			MenuItem("Home Screen", function()
				playorama.ui.menu:goTo(4)
			end)
		}
		playorama.ui.menu:push(ListView(settingsListArray))
	end),
}

playorama.ui.setScreenAnimator = function(startValue, endValue, callback)

	if playorama.ui._animator == nil then
		local duration <const> = 300
		local startValue <const> = startValue or pd.geometry.point.new(0, 0)
		local endValue <const> = endValue or pd.geometry.point.new(0, -40)
		local easingFunction <const> = pd.easingFunctions.outBack
		playorama.ui._animator = gfx.animator.new(duration, startValue, endValue, easingFunction)
		playorama.ui._animatorType = "screen"
		if callback then 
			playorama.ui._animatorCallback = callback
		end
	end

end

playorama.ui.setMenuAnimator = function(callback)

	if playorama.ui._animator == nil then
		local duration <const> = 100
		local startValue <const> = 0
		local endValue <const> = 1
		local easingFunction <const> = pd.easingFunctions.linear
		playorama.ui._animator = gfx.animator.new(duration, startValue, endValue,  easingFunction)
		playorama.ui._animator.reverses = true
		playorama.ui._animatorType = "menu"
		playorama.ui._animatorCallback = callback

		-- White flash effect
		local bg = gfx.image.new(400, 200, gfx.kColorClear)
		gfx.pushContext(bg)
			gfx.setColor(gfx.kColorWhite)
			gfx.fillRoundRect(0, 0, 400, 200, 8)
		gfx.popContext()
		local flash = gfx.sprite.new(bg)
		flash:setCenter(0, 0)
		flash:moveTo(0, 40)
		flash:setZIndex(999)
		flash:add()
		flash.update = function(that)
			if playorama.ui._animator ~= nil and not playorama.ui._animator:ended() then
				that:setImage(bg:fadedImage(playorama.ui._animator:currentValue(), gfx.image.kDitherTypeBayer8x8))
			else
				that:remove()
			end
		end

	end

end


playorama.ui.setOutroAnimator = function(callback)

	if playorama.ui._animator == nil then
		local duration <const> = 300
		local startValue <const> = 0
		local endValue <const> = 1
		local easingFunction <const> = pd.easingFunctions.outBack
		playorama.ui._animator = gfx.animator.new(duration, startValue, endValue,  easingFunction)
		playorama.ui._animatorType = "outro"
		playorama.ui._animatorCallback = callback

		local screenshot = gfx.getDisplayImage()
		local black = gfx.image.new(400, 240, gfx.kColorBlack)
		local header = gfx.image.new(400, 40, gfx.kColorClear)
		gfx.pushContext(header)
			screenshot:draw(0, 0)
		gfx.popContext()
		local body = gfx.image.new(400, 200, gfx.kColorClear)
		gfx.pushContext(body)
			screenshot:draw(0, -40)
		gfx.popContext()

		local blackSprite = gfx.sprite.new(black)
		local headerSprite = gfx.sprite.new(header)
		local bodySprite = gfx.sprite.new(body)

		blackSprite:setCenter(0, 0)
		blackSprite:moveTo(0, 0)
		blackSprite:setZIndex(9998)
		blackSprite:add()

		bodySprite:setCenter(0, 0)
		bodySprite:moveTo(0, 40)
		bodySprite:setZIndex(9999)
		bodySprite:add()
		bodySprite.update = function(that)
			if playorama.ui._animator ~= nil and not playorama.ui._animator:ended() then
				that:moveTo(0, math.floor(playorama.ui._animator:progress() * 0.5 * 200 + 40))
			else
				bodySprite:remove()
				blackSprite:remove()
				headerSprite:remove()
			end
		end

		headerSprite:setCenter(0, 0)
		headerSprite:moveTo(0, 0)
		headerSprite:setZIndex(9999)
		headerSprite:add()
		headerSprite.update = function(that)
			if playorama.ui._animator ~= nil and not playorama.ui._animator:ended() then
				that:moveTo(0, math.floor(playorama.ui._animator:progress() * -40))
			else
				bodySprite:remove()
				blackSprite:remove()
				headerSprite:remove()
			end
		end

		-- Black flash effect
		local flash = gfx.sprite.new(black)
		flash:setCenter(0, 0)
		flash:moveTo(0, 0)
		flash:setZIndex(10000)
		flash:add()
		flash.update = function(that)
			if playorama.ui._animator ~= nil and not playorama.ui._animator:ended() then
				that:setImage(black:fadedImage(playorama.ui._animator:currentValue(), gfx.image.kDitherTypeBayer8x8))
			else
				that:remove()
			end
		end

	end

end

playorama.ui.isAnimating = function()

	return playorama.ui._animator ~= nil and not playorama.ui._animator:ended()

end

playorama.ui.removeAnimator = function()

	if playorama.ui._animator ~= nil then
		playorama.ui._animator = nil
		playorama.ui._animatorType = nil
		playorama.ui._animatorCallback = nil
	end

end

playorama.ui.update = function()

	if playorama.ui._animator ~= nil then
		if playorama.ui._animatorType == "screen" then
			local value <const> = playorama.ui._animator:currentValue()
			if value.x and value.y then
				gfx.setDrawOffset(value.x, value.y)
			end
		elseif playorama.ui._animatorType == "menu" then
			local progress <const> = playorama.ui._animator:progress()
			if progress >= 0.5 and playorama.ui._animatorCallback ~= nil then
				playorama.ui._animatorCallback()
				playorama.ui._animatorCallback = nil
			end
		end
		if playorama.ui._animator:ended() then
			if playorama.ui._animatorCallback ~= nil then
				playorama.ui._animatorCallback()
			end
			playorama.ui.removeAnimator()
		end
	end

end
