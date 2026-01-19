-- render system --
-- Renders entities with position and animation components

local World = require("world")
local AnimationComponent = require("components.animation")

local RenderSystem = {}

-- Draw a single entity
-- @param entity Entity with position and animation components
function RenderSystem.DrawEntity(entity)
	if entity.animation == nil or entity.position == nil then
		return
	end

	local sprite = AnimationComponent.GetCurrentSprite(entity.animation)
	if sprite == nil then
		return
	end

	local rotate = entity.rotate or 0
	local keyColor = entity.keyColor or 0
	spr(sprite, entity.position.x, entity.position.y, keyColor, 1, 0, rotate)
end

-- Draw all renderable entities in the world
-- @param world World instance
function RenderSystem.Draw(world)
	-- Query entities that have position and animation components
	local entities = World.Query(world, { "position", "animation" })

	for _, entity in ipairs(entities) do
		RenderSystem.DrawEntity(entity)
	end
end

return RenderSystem
