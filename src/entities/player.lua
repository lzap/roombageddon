-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")
local Animation = require("components.animation")
local Input = require("components.input")
local Movement = require("components.movement")
local Map = require("services.map")

local Player = {}

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

	-- Convert direction to rotation (helper function)
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

	-- Create input component
	local input = Input.New({
		playerNumber = playerNumber,
		lastDirection = initialDirection,
	})

	-- Create movement component
	local movement = Movement.New({
		playerNumber = playerNumber,
		posQueue = {},
		moveTimer = 0,
		sfx = SFX_NONE,
	})

	-- Create entity with player-specific components
	local ent = Entity.New({
		position = pos,
		animation = animation,
		input = input,
		movement = movement,
		keyColor = opts.keyColor or 0,
		rotate = initialRotation,
		currentLevel = opts.currentLevel or 0,
	})

	return {
		entity = ent,
		playerNumber = playerNumber,
		currentLevel = opts.currentLevel or 0,
	}
end

function Player.Update(p, currentLevel)
	-- Note: Input and Movement are now handled by InputSystem and MovementSystem via World.Update()
	-- This function is kept for backward compatibility but does nothing
	-- Update entity's current level
	if p.entity then
		p.entity.currentLevel = currentLevel
	end
end

function Player.Sound(p)
	if p.entity and p.entity.movement then
		return p.entity.movement.sfx
	end
	return SFX_NONE
end

function Player.IsStuck(p, currentLevel)
	if p.entity == nil or p.entity.movement == nil or p.entity.position == nil then
		return false
	end

	-- Player is stuck if they're not moving and can't move in any direction
	if #p.entity.movement.posQueue > 0 then
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
