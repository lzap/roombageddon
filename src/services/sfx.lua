-- sfx --
require("consts")
require("common")

local Player = require("entities.player")

local SFX = {}

-- Process player movement sounds
-- @param players Array of player objects
function SFX.ProcessPlayers(players)
	if all(players, function(p)
		return Player.Sound(p) == SFX_NONE
	end) then
		return
	end

	-- at least one player moved
	local hasMoved = any(players, function(p)
		return Player.Sound(p) == SFX_MOVED
	end)

	if hasMoved then
		sfx(0, 48, 5, 0, 6)
		return
	end

	-- at least one player bumped
	local hasBumped = any(players, function(p)
		return Player.Sound(p) == SFX_BUMPED
	end)

	if hasBumped then
		sfx(1, 48, 5, 0, 6)
	end
end

return SFX
