-- animation system --
-- Updates animation frames for entities with animation components

local World = require("world")
local AnimationComponent = require("components.animation")

local AnimationSystem = {}

-- Update animation for a single entity
-- @param entity Entity with animation component
function AnimationSystem.UpdateEntity(entity)
	if entity.animation == nil then
		return
	end

	local anim = entity.animation
	if anim.curAnim == nil or anim.anim == nil or anim.anim[anim.curAnim] == nil then
		return
	end

	anim.frameTime = anim.frameTime + 1
	if anim.frameTime >= anim.anim[anim.curAnim].speed then
		anim.frame = anim.frame + 1
		if anim.frame > #anim.anim[anim.curAnim].frames then
			anim.frame = 1
		end
		anim.frameTime = 0
	end
end

-- Update all animations in the world
-- @param world World instance
function AnimationSystem.Update(world)
	-- Query entities that have animation components
	local entities = World.Query(world, { "animation" })

	for _, entity in ipairs(entities) do
		AnimationSystem.UpdateEntity(entity)
	end
end

return AnimationSystem
