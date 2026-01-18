-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")
local MapService = require("services.map_service")

local Player = {}

function Player.New(opts)
	opts = opts or {}
	
	local playerNumber = opts.playerNumber or 1
	
	-- Set default position if not provided
	local pos = opts.position or Position.New {
		x = SCREEN_WIDTH / 2 - TILE_SIZE,
		y = SCREEN_HEIGHT / 2 - TILE_SIZE
	}
	
	-- Use configurable sprites, default to {256, 257}
	local sprites = opts.sprites or {256, 257}
	
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
		keyColor = opts.keyColor or 0
	}
	
	return {
		entity = ent,
		playerNumber = playerNumber,
		currentLevel = opts.currentLevel or 0
	}
end

function Player.Update(p, currentLevel)
	Entity.Update(p.entity)
	
	-- Ensure player position is always aligned to grid
	local gridX = math.floor(p.entity.position.x / TILE_SIZE)
	local gridY = math.floor(p.entity.position.y / TILE_SIZE)
	p.entity.position.x = gridX * TILE_SIZE
	p.entity.position.y = gridY * TILE_SIZE
	
	-- Handle movement input (button IDs: 0=UP, 1=DOWN, 2=LEFT, 3=RIGHT)
	local dir = nil
	if btnp(0) then
		dir = 0
	elseif btnp(1) then
		dir = 1
	elseif btnp(2) then
		dir = 2
	elseif btnp(3) then
		dir = 3
	end
	
	-- If movement input detected, try to move
	if dir ~= nil then
		-- Get direction data from DIRS table
		local dirData = DIRS[dir]
		if dirData then
			local targetGridX = gridX + dirData.x
			local targetGridY = gridY + dirData.y
			
			-- Check if movement is allowed (not blocked by bit 0)
			if MapService.canMoveTo(currentLevel, targetGridX, targetGridY) then
				-- Move player
				p.entity.position.x = targetGridX * TILE_SIZE
				p.entity.position.y = targetGridY * TILE_SIZE
				
				-- Mark new tile as visited
				MapService.markVisited(currentLevel, targetGridX, targetGridY, p.playerNumber)
			end
		end
	end
end

function Player.Draw(p)
	Entity.Draw(p.entity)
end

return Player
