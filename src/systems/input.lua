-- input system --
-- Processes input and queues movement requests

require("consts")
require("common")
local World = require("world")
local PositionComponent = require("components.position")
local MovementComponent = require("components.movement")
local AnimationComponent = require("components.animation")
local Map = require("services.map")

local InputSystem = {}

-- Process input for a single entity
-- @param entity Entity with input and movement components
-- @param currentLevel Current level number for collision checking
-- @param world World instance for querying other players
function InputSystem.ProcessEntity(entity, currentLevel, world)
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

	-- Handle input: detect button presses based on group
	local dirData = nil
	local newDirection = nil
	local group = (entity.player and entity.player.group) or GONE

	if group == GONE then
		-- Group one: arrow keys / D-pad
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
	elseif group == GTWO then
		-- Group two: ASDW keys (codes: A=01, S=19, D=04, W=23)
		if keyp(4) then -- D key
			newDirection = RIGHT
			dirData = DIRS[RIGHT]
		elseif keyp(19) then -- S key
			newDirection = DOWN
			dirData = DIRS[DOWN]
		elseif keyp(1) then -- A key
			newDirection = LEFT
			dirData = DIRS[LEFT]
		elseif keyp(23) then -- W key
			newDirection = UP
			dirData = DIRS[UP]
		end
	end

	-- If input detected, process it
	if dirData and newDirection then
		input.direction = newDirection
		input.lastDirection = newDirection

		-- Update entity rotation
		entity.rotate = DirectionToRotation(newDirection)

		-- Check if movement is valid
		local targetGridPos = endGridPos + dirData
		local targetPos = targetGridPos * TILE_SIZE

		-- Check for battery - if current capacity is 0, cannot move
		local hasBattery = true
		if entity.battery then
			if entity.battery.currentCapacity <= 0 then
				hasBattery = false
			end
		end

		-- Check for wall collision
		if not Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			-- Bumped into wall
			movement.sfx = SFX_BUMPED
		elseif not hasBattery then
			-- Out of battery - cannot move
			movement.sfx = SFX_BUMPED
		else
			-- Check for player collision by querying all players
			local players = World.Query(world, { "player", "position" })
			local hasCollision = false

			for _, otherPlayer in ipairs(players) do
				-- Skip self
				if otherPlayer ~= entity then
					local otherGridPos = otherPlayer.position // TILE_SIZE
					-- Check if target position matches another player's current position
					if targetGridPos.x == otherGridPos.x and targetGridPos.y == otherGridPos.y then
						hasCollision = true
						break
					end
					-- Also check if target position matches another player's queued end position
					if otherPlayer.movement and #otherPlayer.movement.posQueue > 0 then
						local otherEndPos = otherPlayer.movement.posQueue[#otherPlayer.movement.posQueue] // TILE_SIZE
						if targetGridPos.x == otherEndPos.x and targetGridPos.y == otherEndPos.y then
							hasCollision = true
							break
						end
					end
				end
			end

			if hasCollision then
				-- Bumped into another player
				movement.sfx = SFX_BUMPED
			else
				-- Queue valid movement
				MovementComponent.QueuePosition(movement, targetPos)
				movement.sfx = SFX_MOVED
			end
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
		InputSystem.ProcessEntity(entity, level, world)
	end
end

return InputSystem
