-- input system --
-- Processes input and queues movement requests

require("consts")
local World = require("world")
local PositionComponent = require("components.position")
local MovementComponent = require("components.movement")
local Map = require("services.map")

local InputSystem = {}

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
	return ROTATE_NONE
end

-- Process input for a single entity
-- @param entity Entity with input and movement components
-- @param currentLevel Current level number for collision checking
function InputSystem.ProcessEntity(entity, currentLevel)
	if entity.input == nil or entity.movement == nil or entity.position == nil then
		return
	end

	local input = entity.input
	local movement = entity.movement

	-- Reset SFX flag at start of update
	movement.sfx = SFX_NONE

	-- Get current grid position
	local gridPos = entity.position // TILE_SIZE

	-- Calculate grid position at the end of the queue (where entity will be after all queued moves)
	local endGridPos = gridPos
	if #movement.posQueue > 0 then
		endGridPos = movement.posQueue[#movement.posQueue] // TILE_SIZE
	end

	-- Handle input: detect button presses
	local dirData = nil
	local newDirection = nil

	if btnp(RIGHT) then
		newDirection = RIGHT
		dirData = DIRS[RIGHT]
	elseif btnp(DOWN) then
		newDirection = DOWN
		dirData = DIRS[DOWN]
	elseif btnp(LEFT) then
		newDirection = LEFT
		dirData = DIRS[LEFT]
	elseif btnp(UP) then
		newDirection = UP
		dirData = DIRS[UP]
	end

	-- If input detected, process it
	if dirData and newDirection then
		input.direction = newDirection
		input.lastDirection = newDirection

		-- Update entity rotation
		entity.rotate = directionToRotation(newDirection)

		-- Check if movement is valid
		local targetGridPos = endGridPos + dirData
		if Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			-- Queue valid movement
			local targetPos = targetGridPos * TILE_SIZE
			MovementComponent.QueuePosition(movement, targetPos)
			movement.sfx = SFX_MOVED
		else
			-- Bumped into wall
			movement.sfx = SFX_BUMPED
		end
	else
		-- No input, clear direction
		input.direction = nil
	end
end

-- Update all input in the world
-- @param world World instance
function InputSystem.Update(world)
	-- Query entities that have input and movement components
	local entities = World.Query(world, { "input", "movement", "position" })

	-- Get current level from world
	local currentLevel = world.currentLevel or 0

	for _, entity in ipairs(entities) do
		-- Use entity's level if available, otherwise use world's level
		local level = entity.currentLevel or currentLevel
		InputSystem.ProcessEntity(entity, level)
	end
end

return InputSystem
