require("consts")

local PositionComponent = require("components.position")
local Map = {}

-- Cache to store original map states for each level for reset functionality
local originalMapCache = {}

-- Visited sprite base (P1=32, P2=33, P3=34, P4=35)
local VISITED_SPRITE_BASE = 31

-- Helper: Clamp level to valid range [0, MAX_LEVELS-1]
local function clampLevel(level)
	return math.max(0, math.min(level, MAX_LEVELS - 1))
end

-- Helper: Check if grid coordinates are within bounds
local function isInBounds(gridX, gridY)
	return gridX >= 0 and gridX < MAP_WIDTH and gridY >= 0 and gridY < MAP_HEIGHT
end

-- Helper: Extract player info from sprite ID
local function getPlayerInfoFromSprite(spriteId)
	local spriteRanges = {
		{ base = PLAYER_SPRITE_UP, direction = UP },
		{ base = PLAYER_SPRITE_DOWN, direction = DOWN },
		{ base = PLAYER_SPRITE_LEFT, direction = LEFT },
		{ base = PLAYER_SPRITE_RIGHT, direction = RIGHT },
	}

	for _, range in ipairs(spriteRanges) do
		if spriteId >= range.base and spriteId <= range.base + 3 then
			return {
				playerNumber = spriteId - range.base + 1,
				direction = range.direction,
			}
		end
	end

	return nil
end

-- Calculate map coordinates for a given level number (0-63)
function Map.getCoords(level)
	level = level % MAX_LEVELS
	local mapX = (level % MAPS_PER_ROW) * MAP_WIDTH
	local mapY = math.floor(level / MAPS_PER_ROW) * MAP_HEIGHT
	return mapX, mapY
end

-- Scan map for player position sprites and return their positions with direction
-- Sprites: UP=64-67, DOWN=80-83, LEFT=96-99, RIGHT=112-115
function Map.findPlayerPositions(level)
	local mapX, mapY = Map.getCoords(level)
	local positions = {}

	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			local playerInfo = getPlayerInfoFromSprite(spriteId)

			if playerInfo then
				table.insert(positions, {
					playerNumber = playerInfo.playerNumber,
					direction = playerInfo.direction,
					x = x * TILE_SIZE,
					y = y * TILE_SIZE,
				})
			end
		end
	end

	return positions
end

-- Store original map state for a level
function Map.storeOriginalMap(level)
	level = clampLevel(level)

	if not originalMapCache[level] then
		local mapX, mapY = Map.getCoords(level)
		local tiles = {}

		for y = 0, MAP_HEIGHT - 1 do
			for x = 0, MAP_WIDTH - 1 do
				local spriteId = mget(mapX + x, mapY + y)
				tiles[y * MAP_WIDTH + x] = spriteId
			end
		end

		originalMapCache[level] = tiles
	end
end

-- Restore original map state for a level
function Map.restoreOriginalMap(level)
	level = clampLevel(level)

	if originalMapCache[level] then
		local mapX, mapY = Map.getCoords(level)
		local tiles = originalMapCache[level]

		for y = 0, MAP_HEIGHT - 1 do
			for x = 0, MAP_WIDTH - 1 do
				local spriteId = tiles[y * MAP_WIDTH + x]
				mset(mapX + x, mapY + y, spriteId)
			end
		end
	end
end

-- Replace center markers (tiles with bit 2 set) with sprite 0
function Map.replaceCenterMarkers(level)
	local mapX, mapY = Map.getCoords(level)

	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			if fget(spriteId, 2) then
				mset(mapX + x, mapY + y, 0)
			end
		end
	end
end

-- Load a level: scan for player positions and return them
-- TODO: drop MAX_LEVELS and figure out next level by scanning the map for player positions
function Map.loadLevel(level)
	level = clampLevel(level)

	-- Store original map state if not already stored
	Map.storeOriginalMap(level)

	-- Restore original map state before finding player positions
	-- This ensures we can find player sprites even if the map was modified
	Map.restoreOriginalMap(level)

	-- Replace center markers (tiles with bit 2 set) with sprite 0
	Map.replaceCenterMarkers(level)
	-- Find player positions in the level
	return Map.findPlayerPositions(level), level
end

-- Check if a tile is walkable (bit 0 must not be set)
function Map.canMoveTo(level, gridX, gridY)
	if not isInBounds(gridX, gridY) then
		return false
	end

	local mapX, mapY = Map.getCoords(level)
	local spriteId = mget(mapX + gridX, mapY + gridY)

	-- Check if sprite flag 0 (bit 0) is set (blocking movement)
	-- Use fget to check sprite flags, not the sprite ID value
	if fget(spriteId, 0) then
		return false
	end

	return true
end

-- Mark a tile as visited with the appropriate sprite (32-35 for P1-P4)
function Map.markVisited(level, gridX, gridY, playerNumber)
	if not isInBounds(gridX, gridY) then
		return
	end

	local mapX, mapY = Map.getCoords(level)
	local visitedSprite = VISITED_SPRITE_BASE + playerNumber
	mset(mapX + gridX, mapY + gridY, visitedSprite)
end

-- Check if level is complete (no tiles with bit 1 set)
function Map.isLevelComplete(level)
	local mapX, mapY = Map.getCoords(level)

	for y = 0, MAP_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local spriteId = mget(mapX + x, mapY + y)
			if fget(spriteId, 1) then
				return false
			end
		end
	end

	return true
end

-- Check if a player entity is stuck (cannot move in any direction)
-- @param entity Entity with player, movement, and position components
-- @param currentLevel Current level number for collision checking
-- @return true if player is stuck, false otherwise
function Map.isPlayerStuck(entity, currentLevel)
	if entity == nil or entity.movement == nil or entity.position == nil then
		return false
	end

	if #entity.movement.posQueue > 0 then
		return false
	end

	local gridPos = entity.position // TILE_SIZE
	for direction = UP, RIGHT do
		local dirData = DIRS[direction]
		local targetGridPos = gridPos + dirData

		if Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			return false
		end
	end

	return true
end

return Map
