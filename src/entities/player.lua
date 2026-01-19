-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")
local Animation = require("components.animation")
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
	local pos = opts.position
		or Position.New({
			x = SCREEN_WIDTH / 2 - TILE_SIZE,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE,
		})

	-- Use configurable sprites, default to {256, 257}
	local sprites = opts.sprites or { 256, 257 }

	-- Convert direction to rotation
	local initialRotation = directionToRotation(initialDirection)

	-- Create animation component
	local animation = Animation.New({
		anim = {
			idle = {
				frames = sprites,
				speed = 10,
			},
		},
		curAnim = "idle",
		frame = 1,
		frameTime = 0,
	})

	-- Create entity with player-specific animation
	local ent = Entity.New({
		position = pos,
		animation = animation,
		keyColor = opts.keyColor or 0,
		rotate = initialRotation,
	})

	return {
		entity = ent,
		playerNumber = playerNumber,
		currentLevel = opts.currentLevel or 0,
		lastDirection = initialDirection,
		posQueue = {}, -- FIFO queue of target positions
		moveTimer = 0, -- Frames counter for pixel movement
		sfx = SFX_NONE, -- For simplicity directly set the SFX flag
	}
end

function Player.Update(p, currentLevel)
	-- Note: Animation is now handled by AnimationSystem via World.Update()
	-- Entity.Update() is deprecated

	-- Reset SFX flag at start of update
	p.sfx = SFX_NONE
	-- Get current grid position
	local gridPos = p.entity.position // TILE_SIZE

	-- Calculate grid position at the end of the queue (where player will be after all queued moves)
	local endGridPos = gridPos

	-- If there are queued positions, use the last one in the queue
	if #p.posQueue > 0 then
		endGridPos = p.posQueue[#p.posQueue] // TILE_SIZE
	end

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
		local targetGridPos = endGridPos + dirData
		if Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			table.insert(p.posQueue, targetGridPos * TILE_SIZE)
			if #p.posQueue == 1 then
				p.moveTimer = 0
			end
			p.sfx = SFX_MOVED -- Mark as successfully moved
		else
			p.sfx = SFX_BUMPED -- Mark as bumped into wall
		end
	end

	-- Move pixel by pixel towards first target in queue
	if #p.posQueue > 0 then
		local currentTarget = p.posQueue[1]
		p.moveTimer = p.moveTimer + 1

		if p.moveTimer >= MOVE_SPEED then
			p.moveTimer = 0

			-- Calculate direction to target
			local diff = currentTarget - p.entity.position

			-- Calculate normalized step (1 pixel in the direction of target)
			local step = Position.New({
				x = diff.x ~= 0 and (diff.x > 0 and 1 or -1) or 0,
				y = diff.y ~= 0 and (diff.y > 0 and 1 or -1) or 0,
			})

			-- Move one pixel towards target
			p.entity.position = p.entity.position + step

			-- Check if we've reached the target
			if p.entity.position == currentTarget then
				-- Mark this position as visited
				local targetGridPos = currentTarget // TILE_SIZE
				Map.markVisited(currentLevel, targetGridPos.x, targetGridPos.y, p.playerNumber)

				-- Remove completed target from queue
				table.remove(p.posQueue, 1)
			end
		end
	end
end

function Player.Sound(p)
	return p.sfx
end

function Player.IsStuck(p, currentLevel)
	-- Player is stuck if they're not moving and can't move in any direction
	if #p.posQueue > 0 then
		return false -- Player is currently moving
	end

	-- Get current grid position
	local gridPos = p.entity.position // TILE_SIZE

	-- Check if player can move in any direction
	for direction = UP, RIGHT do
		local dirData = DIRS[direction]
		local targetGridPos = gridPos + dirData

		if Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			return false -- Can move in at least one direction
		end
	end

	-- Cannot move in any direction
	return true
end

function Player.Draw(p)
	Entity.Draw(p.entity)
end

return Player
