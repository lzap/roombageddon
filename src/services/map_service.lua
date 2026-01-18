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

-- Scan map for player position sprites and return their positions with direction
-- Sprites: UP=64-67, DOWN=80-83, LEFT=96-99, RIGHT=112-115
function MapService.findPlayerPositions(level)
	local mapX, mapY = MapService.getCoords(level)
	local positions = {}

	-- Scan the entire level map for player position sprites
	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			local playerNum = nil
			local direction = nil
			
			-- Check UP sprites (64-67)
			if spriteId >= PLAYER_SPRITE_UP and spriteId <= PLAYER_SPRITE_UP + 3 then
				playerNum = spriteId - PLAYER_SPRITE_UP + 1
				direction = UP
			-- Check DOWN sprites (80-83)
			elseif spriteId >= PLAYER_SPRITE_DOWN and spriteId <= PLAYER_SPRITE_DOWN + 3 then
				playerNum = spriteId - PLAYER_SPRITE_DOWN + 1
				direction = DOWN
			-- Check LEFT sprites (96-99)
			elseif spriteId >= PLAYER_SPRITE_LEFT and spriteId <= PLAYER_SPRITE_LEFT + 3 then
				playerNum = spriteId - PLAYER_SPRITE_LEFT + 1
				direction = LEFT
			-- Check RIGHT sprites (112-115)
			elseif spriteId >= PLAYER_SPRITE_RIGHT and spriteId <= PLAYER_SPRITE_RIGHT + 3 then
				playerNum = spriteId - PLAYER_SPRITE_RIGHT + 1
				direction = RIGHT
			end
			
			if playerNum then
				table.insert(positions, {
					playerNumber = playerNum,
					direction = direction,
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
