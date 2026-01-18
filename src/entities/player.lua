-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")
local Map = require("services.map")

local Player = {}

-- Helper function to convert direction to rotation
local function directionToRotation(direction)
	if direction == UP then
		return ROTATE_270
	elseif direction == DOWN then
		return ROTATE_90
	elseif direction == LEFT then
		return ROTATE_180
	elseif direction == RIGHT then
		return ROTATE_NONE
	end
	return ROTATE_NONE -- Default to RIGHT
end

function Player.New(opts)
	opts = opts or {}

	local playerNumber = opts.playerNumber or 1
	local initialDirection = opts.direction or RIGHT -- Default to RIGHT

	-- Set default position if not provided
	local pos = opts.position or Position.New {
		x = SCREEN_WIDTH / 2 - TILE_SIZE,
		y = SCREEN_HEIGHT / 2 - TILE_SIZE
	}

	-- Use configurable sprites, default to {256, 257}
	local sprites = opts.sprites or { 256, 257 }

	-- Convert direction to rotation
	local initialRotation = directionToRotation(initialDirection)

	-- Create entity with player-specific animation
	local ent = Entity.New {
		position = pos,
		anim = {
			idle = {
				frames = sprites,
				speed = 10
			}
		},
		curAnim = "idle",
		frame = 1,
		frameTime = 0,
		keyColor = opts.keyColor or 0,
		rotate = initialRotation
	}

	return {
		entity = ent,
		playerNumber = playerNumber,
		currentLevel = opts.currentLevel or 0,
		lastDirection = initialDirection,
		positionQueue = {}, -- FIFO queue of target positions
		currentTarget = nil, -- Current target position we're moving towards
		moveTimer = 0 -- Frames counter for pixel movement
	}
end

function Player.Update(p, currentLevel)
	Entity.Update(p.entity)

	-- Get current grid position
	local gridX = math.floor(p.entity.position.x / TILE_SIZE)
	local gridY = math.floor(p.entity.position.y / TILE_SIZE)

	-- Handle input: add target positions to queue
	local dirData = nil
	if btnp(BUTTONS.RIGHT) then
		p.entity.rotate = ROTATE_NONE
		p.lastDirection = RIGHT
		dirData = DIRS[RIGHT]
	elseif btnp(BUTTONS.DOWN) then
		p.entity.rotate = ROTATE_90
		p.lastDirection = DOWN
		dirData = DIRS[DOWN]
	elseif btnp(BUTTONS.LEFT) then
		p.entity.rotate = ROTATE_180
		p.lastDirection = LEFT
		dirData = DIRS[LEFT]
	elseif btnp(BUTTONS.UP) then
		p.entity.rotate = ROTATE_270
		p.lastDirection = UP
		dirData = DIRS[UP]
	end

	-- If input detected, add target position to queue
	if dirData then
		local targetGridX = gridX + dirData.x
		local targetGridY = gridY + dirData.y

		-- Check if movement is allowed (not blocked by bit 0)
		if Map.canMoveTo(currentLevel, targetGridX, targetGridY) then
			-- Add target position to queue
			table.insert(p.positionQueue, {
				x = targetGridX * TILE_SIZE,
				y = targetGridY * TILE_SIZE
			})
		end
	end

	-- If no current target but queue has items, set next target
	if p.currentTarget == nil and #p.positionQueue > 0 then
		p.currentTarget = table.remove(p.positionQueue, 1)
		p.moveTimer = 0
	end

	-- Move pixel by pixel towards current target
	if p.currentTarget then
		p.moveTimer = p.moveTimer + 1
		
		if p.moveTimer >= MOVE_SPEED then
			p.moveTimer = 0
			
			-- Calculate direction to target
			local dx = p.currentTarget.x - p.entity.position.x
			local dy = p.currentTarget.y - p.entity.position.y
			
			-- Move one pixel towards target
			if dx ~= 0 then
				p.entity.position.x = p.entity.position.x + (dx > 0 and 1 or -1)
			end
			if dy ~= 0 then
				p.entity.position.y = p.entity.position.y + (dy > 0 and 1 or -1)
			end
			
			-- Check if we've reached the target
			if p.entity.position.x == p.currentTarget.x and p.entity.position.y == p.currentTarget.y then
				-- Mark this position as visited
				local targetGridX = math.floor(p.currentTarget.x / TILE_SIZE)
				local targetGridY = math.floor(p.currentTarget.y / TILE_SIZE)
				Map.markVisited(currentLevel, targetGridX, targetGridY, p.playerNumber)
				
				-- Get next target from queue
				if #p.positionQueue > 0 then
					p.currentTarget = table.remove(p.positionQueue, 1)
				else
					p.currentTarget = nil
				end
			end
		end
	end
end

function Player.Draw(p)
	Entity.Draw(p.entity)
end

return Player
