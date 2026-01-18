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

-- Check if a tile is walkable (bit 0 must not be set)
function MapService.canMoveTo(level, gridX, gridY)
	-- Check bounds
	if gridX < 0 or gridX >= MAP_WIDTH or gridY < 0 or gridY >= MAP_HEIGHT then
		return false
	end

	local mapX, mapY = MapService.getCoords(level)
	local spriteId = mget(mapX + gridX, mapY + gridY)

	-- Check if sprite flag 0 (bit 0) is set (blocking movement)
	-- Use fget to check sprite flags, not the sprite ID value
	if fget(spriteId, 0) then
		return false
	end

	return true
end

-- Mark a tile as visited with the appropriate sprite (32-35 for P1-P4)
function MapService.markVisited(level, gridX, gridY, playerNumber)
	-- Check bounds
	if gridX < 0 or gridX >= MAP_WIDTH or gridY < 0 or gridY >= MAP_HEIGHT then
		return
	end

	local mapX, mapY = MapService.getCoords(level)
	-- Sprite 32 for P1, 33 for P2, 34 for P3, 35 for P4
	local visitedSprite = 31 + playerNumber
	mset(mapX + gridX, mapY + gridY, visitedSprite)
end

-- Check if level is complete (no tiles with bit 1 set)
function MapService.isLevelComplete(level)
	local mapX, mapY = MapService.getCoords(level)

	-- Scan all tiles in the level
	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			-- Check if sprite flag 1 (bit 1) is set
			-- Use fget to check sprite flags
			if fget(spriteId, 1) then
				return false
			end
		end
	end

	return true
end

return MapService
