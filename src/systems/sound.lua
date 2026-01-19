require("consts")
require("common")

local World = require("world")

local SoundSystem = {}

-- Update sound effects for all entities in the world
-- @param world World instance
function SoundSystem.Update(world)
	local entities = World.Query(world, { "movement" })

	if #entities == 0 then
		return
	end

	-- Check if all have no sound
	if All(entities, function(e)
		return e.movement.sfx == SFX_NONE
	end) then
		return
	end

	-- at least one player moved
	local hasMoved = Any(entities, function(e)
		return e.movement.sfx == SFX_MOVED
	end)

	if hasMoved then
		sfx(0, 48, 5, 0, 6)
		return
	end

	-- at least one player bumped
	local hasBumped = Any(entities, function(e)
		return e.movement.sfx == SFX_BUMPED
	end)

	if hasBumped then
		sfx(1, 48, 5, 0, 6)
	end
end

return SoundSystem
