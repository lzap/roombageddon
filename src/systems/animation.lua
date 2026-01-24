-- animation system --
-- Updates animation frames for entities with animation components

require("consts")
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
	if anim.frames == nil or anim.frameGroup == nil then
		return
	end

	-- Check if player has run out of battery and update frame group
	if entity.battery and entity.player then
		if entity.battery.currentCapacity <= 0 then
			-- Battery is out - use GDEAD (dead) animation
			if anim.frameGroup ~= GDEAD then
				anim.frameGroup = GDEAD
				anim.frame = 1
				anim.frameTime = 0
			end
		else
			-- Battery is available - use normal animation based on group
			local targetGroup = entity.player.group
			
			if targetGroup and anim.frameGroup ~= targetGroup then
				anim.frameGroup = targetGroup
				anim.frame = 1
				anim.frameTime = 0
			end
		end
	end

	local frameList = anim.frames[anim.frameGroup]
	if frameList == nil or #frameList == 0 then
		return
	end

	local speed = anim.speeds[anim.frameGroup]
	if speed == nil then
		return
	end

	anim.frameTime = anim.frameTime + 1
	if anim.frameTime >= speed then
		anim.frame = anim.frame + 1
		if anim.frame > #frameList then
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
