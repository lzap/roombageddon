-- map service --
require("consts")

local MapService = {}

-- Calculate map coordinates for a given level number (0-63)
function MapService.getCoords(level)
	level = level % MAX_LEVELS
	local mapX = (level % MAPS_PER_ROW) * MAP_WIDTH
	local mapY = math.floor(level / MAPS_PER_ROW) * MAP_HEIGHT
	return mapX, mapY
end

-- Scan map for player position sprites (16-19) and return their positions
function MapService.findPlayerPositions(level)
	local mapX, mapY = MapService.getCoords(level)
	local positions = {}
	
	-- Scan the entire level map for player position sprites
	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			-- Check if sprite is a player position marker (16-19)
			if spriteId >= PLAYER_SPRITE_START and spriteId <= PLAYER_SPRITE_START + 3 then
				local playerNum = spriteId - PLAYER_SPRITE_START + 1
				table.insert(positions, {
					playerNumber = playerNum,
					x = x * TILE_SIZE,
					y = y * TILE_SIZE
				})
			end
		end
	end
	
	return positions
end

-- Load a level: scan for player positions and return them
function MapService.loadLevel(level)
	-- Clamp level to valid range
	level = math.max(0, math.min(level, MAX_LEVELS - 1))
	
	-- Find player positions in the level
	return MapService.findPlayerPositions(level), level
end

return MapService
