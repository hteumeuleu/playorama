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
		if self:getZIndex() ~= 0 then
			value:setZIndex(self:getZIndex()+1)
		end
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

-- attachSprite()
--
-- Attach sprite to the scene.
function Scene:attachSprite(sprite)

	local isInTable = false
	for key, value in ipairs(self.attachedSprites) do
		if value == sprite then
			isInTable = true
			break
		end
	end
	if not isInTable then
		table.insert(self.attachedSprites, sprite)
	end
	if self:getZIndex() ~= 0 then
		sprite:setZIndex(self:getZIndex()+1)
	end
	sprite:add()
	return sprite

end

-- detachSprite()
--
-- Remove sprite from the scene.
function Scene:detachSprite(sprite)

	for key, value in ipairs(self.attachedSprites) do
		if value == sprite then
			sprite:remove()
			table.remove(self.attachedSprites, key)
		end
	end

end