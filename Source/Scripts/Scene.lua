class('Scene').extends(playdate.graphics.sprite)

-- Scene
--
function Scene:init()

	Scene.super.init(self)
	self:setSize(400, 240)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self.attachedSprites = {}
	return self

end

-- add()
--
function Scene:add()

	Scene.super.add(self)
	for key, value in ipairs(self.attachedSprites) do
		value:setZIndex(self:getZIndex()+1)
		value:add()
	end
	return self

end

-- remove()
--
function Scene:remove()

	Scene.super.remove(self)
	for key, value in ipairs(self.attachedSprites) do
		value:remove()
	end
	return self

end

-- addSprite()
--
-- Attach sprite to the scene.
function Scene:addSprite(sprite)

	for key, value in ipairs(self.attachedSprites) do
		-- `sprite` is already there. We just return it.
		if value == sprite then
			return sprite
		end
	end
	table.insert(self.attachedSprites, sprite)
	sprite:setZIndex(self:getZIndex()+1)
	sprite:add()

end

-- removeSprite()
--
-- Remove sprite from the scene.
function Scene:removeSprite(sprite)

	for key, value in ipairs(self.attachedSprites) do
		if value == sprite then
			sprite:remove()
			table.remove(self.attachedSprites, key)
		end
	end

end