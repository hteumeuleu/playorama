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

playorama.ui.transition = {}
playorama.ui.transition.new = function(type, callback, startValue, endValue)
	if playorama.ui.transition._animator == nil then
		if callback then 
			playorama.ui.transition._animatorCallback = callback
		else
			playorama.ui.transition._animatorCallback = nil
		end
		playorama.ui.transition._animatorSprites = {}
		if type == "screen" then
			playorama.ui.transition._screen(callback, startValue, endValue)
		elseif type == "menu" then
			playorama.ui.transition._menu(callback)
		elseif type == "outro" then
			playorama.ui.transition._outro(callback)
		elseif type == "fadein" then
			playorama.ui.transition._fadein()
		end
	end
end

playorama.ui.transition._fadein = function()

	if playorama.ui.transition._animator == nil then
		local duration <const> = 300
		local startValue <const> = 1
		local endValue <const> = 0
		local easingFunction <const> = pd.easingFunctions.linear
		playorama.ui.transition._animator = gfx.animator.new(duration, startValue, endValue,  easingFunction)
		playorama.ui.transition._animatorType = "fadein"

		local blackRectangle = gfx.image.new(400, 240, gfx.kColorBlack)
		local blackForegroundSprite = playorama.sprite.new(blackRectangle)
		table.insert(playorama.ui.transition._animatorSprites, blackForegroundSprite)
		blackForegroundSprite:setZIndex(10000)
		blackForegroundSprite.update = function(that)
			if playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended() then
				print("fadein", playorama.ui.transition._animator:currentValue(), playorama.ui.transition._animatorCallback)
				that:setImage(blackRectangle:fadedImage(playorama.ui.transition._animator:currentValue(), gfx.image.kDitherTypeBayer8x8))
			end
		end
	end

end

playorama.ui.transition._screen = function(callback, startValue, endValue)

	if playorama.ui.transition._animator == nil then
		local duration <const> = 300
		local startValue <const> = startValue or pd.geometry.point.new(0, 0)
		local endValue <const> = endValue or pd.geometry.point.new(0, -40)
		local easingFunction <const> = pd.easingFunctions.outBack
		playorama.ui.transition._animator = gfx.animator.new(duration, startValue, endValue, easingFunction)
		playorama.ui.transition._animatorType = "screen"
	end

end

playorama.ui.transition._menu = function(callback)

	if playorama.ui.transition._animator == nil then
		local duration <const> = 100
		local startValue <const> = 0
		local endValue <const> = 1
		local easingFunction <const> = pd.easingFunctions.linear
		playorama.ui.transition._animator = gfx.animator.new(duration, startValue, endValue,  easingFunction)
		playorama.ui.transition._animator.reverses = true
		playorama.ui.transition._animatorType = "menu"

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
			if playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended() then
				that:setImage(bg:fadedImage(playorama.ui.transition._animator:currentValue(), gfx.image.kDitherTypeBayer8x8))
			else
				that:remove()
			end
		end

	end

end

playorama.ui.transition._outro = function(callback)

	if playorama.ui.transition._animator == nil then
		local duration <const> = 300
		local startValue <const> = 0
		local endValue <const> = 1
		local easingFunction <const> = pd.easingFunctions.outBack
		playorama.ui.transition._animator = gfx.animator.new(duration, startValue, endValue,  easingFunction)
		playorama.ui.transition._animatorType = "outro"
		playorama.ui.transition._animatorCallback = callback
		playorama.ui.transition._animatorSprites = {}

		-- Take a screenshot
		local screenshot = gfx.getDisplayImage()
		-- And split it into header and body
		local header = gfx.image.new(400, 40, gfx.kColorClear)
		gfx.pushContext(header)
			screenshot:draw(0, 0)
		gfx.popContext()
		local body = gfx.image.new(400, 200, gfx.kColorClear)
		gfx.pushContext(body)
			screenshot:draw(0, -40)
		gfx.popContext()
		-- We’ll use a black screen as a background and a foreground fade effect
		local blackRectangle = gfx.image.new(400, 240, gfx.kColorBlack)
		-- We create sprites from these images
		local blackBackgroundSprite = playorama.sprite.new(blackRectangle)
		local blackForegroundSprite = playorama.sprite.new(blackRectangle)
		local headerSprite = playorama.sprite.new(header)
		local bodySprite = playorama.sprite.new(body)
		table.insert(playorama.ui.transition._animatorSprites, blackBackgroundSprite)
		table.insert(playorama.ui.transition._animatorSprites, blackForegroundSprite)
		table.insert(playorama.ui.transition._animatorSprites, headerSprite)
		table.insert(playorama.ui.transition._animatorSprites, bodySprite)
		-- We order these sprites ZIndex
		blackBackgroundSprite:setZIndex(9998)
		blackForegroundSprite:setZIndex(10000)
		bodySprite:setZIndex(9999)
		headerSprite:setZIndex(9999)

		bodySprite.update = function(that)
			if playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended() then
				that:moveTo(0, math.floor(playorama.ui.transition._animator:progress() * 0.5 * 200 + 40))
			end
		end

		headerSprite.update = function(that)
			if playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended() then
				that:moveTo(0, math.floor(playorama.ui.transition._animator:progress() * -40))
			end
		end

		blackForegroundSprite.update = function(that)
			if playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended() then
				that:setImage(blackRectangle:fadedImage(playorama.ui.transition._animator:currentValue(), gfx.image.kDitherTypeBayer8x8))
			end
		end

	end

end

playorama.ui.isAnimating = function()

	return playorama.ui.transition._animator ~= nil and not playorama.ui.transition._animator:ended()

end

playorama.ui.removeAnimator = function()

	if playorama.ui.transition._animator ~= nil then
		playorama.ui.transition._animator = nil
		playorama.ui.transition._animatorType = nil
		if playorama.ui.transition._animatorSprites ~= nil then
			gfx.sprite.removeSprites(playorama.ui.transition._animatorSprites)
		end
		playorama.ui.transition._animatorSprites = nil
	end

end

playorama.ui.update = function()

	if playorama.ui.transition._animator ~= nil then
		if playorama.ui.transition._animatorType == "screen" then
			local value <const> = playorama.ui.transition._animator:currentValue()
			if value.x and value.y then
				gfx.setDrawOffset(value.x, value.y)
			end
		elseif playorama.ui.transition._animatorType == "menu" then
			local progress <const> = playorama.ui.transition._animator:progress()
			if progress >= 0.5 and playorama.ui.transition._animatorCallback ~= nil then
				playorama.ui.transition._animatorCallback()
				playorama.ui.transition._animatorCallback = nil
			end
		end
		if playorama.ui.transition._animator:ended() then
			playorama.ui.removeAnimator()
			print("ended", playorama.ui.transition._animatorCallback)
			if playorama.ui.transition._animatorCallback ~= nil then
				playorama.ui.transition._animatorCallback()
				playorama.ui.transition._animatorCallback = nil
			end
		end
	end

end
