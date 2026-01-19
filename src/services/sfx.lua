-- sfx --
require("consts")
require("common")

local World = require("world")

local SFX = {}

-- Process player movement sounds
-- @param world World instance
function SFX.Process(world)
	-- Query entities with movement components
	local entities = World.Query(world, {"movement"})
	
	if #entities == 0 then
		return
	end
	
	-- Check if all have no sound
	if all(entities, function(e)
		return e.movement.sfx == SFX_NONE
	end) then
		return
	end

	-- at least one player moved
	local hasMoved = any(entities, function(e)
		return e.movement.sfx == SFX_MOVED
	end)

	if hasMoved then
		sfx(0, 48, 5, 0, 6)
		return
	end

	-- at least one player bumped
	local hasBumped = any(entities, function(e)
		return e.movement.sfx == SFX_BUMPED
	end)

	if hasBumped then
		sfx(1, 48, 5, 0, 6)
	end
end

-- Legacy function for backward compatibility (deprecated)
-- @param players Array of player objects (deprecated)
function SFX.ProcessPlayers(players)
	-- This function is deprecated. Use SFX.Process(world) instead.
	-- Kept for backward compatibility only.
end

return SFX
