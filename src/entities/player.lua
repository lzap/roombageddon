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
	local sprites = opts.sprites or { 256, 257 }

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
		currentLevel = opts.currentLevel or 0,
		lastDirection = 3 -- Default to RIGHT (rotate = 0)
	}
end

function Player.Update(p, currentLevel)
	Entity.Update(p.entity)

	-- Ensure player position is always aligned to grid
	local gridX = math.floor(p.entity.position.x / TILE_SIZE)
	local gridY = math.floor(p.entity.position.y / TILE_SIZE)
	p.entity.position.x = gridX * TILE_SIZE
	p.entity.position.y = gridY * TILE_SIZE

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

function Player.Draw(p)
	Entity.Draw(p.entity)
end

return Player
