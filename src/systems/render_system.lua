-- render system --
-- Renders entities with position and animation components

local World = require("world")

local RenderSystem = {}

-- Draw a single entity
-- @param entity Entity with position, anim, curAnim, frame, keyColor, rotate
function RenderSystem.DrawEntity(entity)
	if entity.curAnim == nil or entity.anim == nil or entity.anim[entity.curAnim] == nil then
		return
	end

	if entity.position == nil then
		return
	end

	local sprite = entity.anim[entity.curAnim].frames[entity.frame]
	local rotate = entity.rotate or 0
	local keyColor = entity.keyColor or 0
	spr(sprite, entity.position.x, entity.position.y, keyColor, 1, 0, rotate)
end

-- Draw all renderable entities in the world
-- @param world World instance
function RenderSystem.Draw(world)
	-- Query entities that have position and animation components
	local entities = World.Query(world, {"position", "anim"})
	
	for _, entity in ipairs(entities) do
		RenderSystem.DrawEntity(entity)
	end
end

return RenderSystem
