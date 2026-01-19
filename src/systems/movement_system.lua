-- movement system --
-- Processes movement queue and moves entities pixel by pixel

require("consts")
local World = require("world")
local Position = require("components.position")
local Movement = require("components.movement")
local Map = require("services.map")

local MovementSystem = {}

-- Process movement for a single entity
-- @param entity Entity with movement and position components
-- @param currentLevel Current level number for marking visited tiles
function MovementSystem.ProcessEntity(entity, currentLevel)
	if entity.movement == nil or entity.position == nil then
		return
	end

	local movement = entity.movement
	
	-- Move pixel by pixel towards first target in queue
	if #movement.posQueue > 0 then
		local currentTarget = movement.posQueue[1]
		movement.moveTimer = movement.moveTimer + 1

		if movement.moveTimer >= MOVE_SPEED then
			movement.moveTimer = 0

			-- Calculate direction to target
			local diff = currentTarget - entity.position

			-- Calculate normalized step (1 pixel in the direction of target)
			local step = Position.New({
				x = diff.x ~= 0 and (diff.x > 0 and 1 or -1) or 0,
				y = diff.y ~= 0 and (diff.y > 0 and 1 or -1) or 0,
			})

			-- Move one pixel towards target
			entity.position = entity.position + step

			-- Check if we've reached the target
			if entity.position == currentTarget then
				-- Mark this position as visited (use player component if available)
				local targetGridPos = currentTarget // TILE_SIZE
				local playerNumber = entity.player and entity.player.playerNumber or 1
				Map.markVisited(currentLevel, targetGridPos.x, targetGridPos.y, playerNumber)

				-- Remove completed target from queue
				table.remove(movement.posQueue, 1)
			end
		end
	end
end

-- Update all movement in the world
-- @param world World instance
function MovementSystem.Update(world)
	-- Query entities that have movement and position components
	local entities = World.Query(world, {"movement", "position"})
	
	-- Get current level from world
	local currentLevel = world.currentLevel or 0
	
	for _, entity in ipairs(entities) do
		-- Use entity's level if available, otherwise use world's level
		local level = entity.currentLevel or currentLevel
		MovementSystem.ProcessEntity(entity, level)
	end
end

return MovementSystem
