-- player factory --
-- Creates player entities with all necessary components

require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")
local Animation = require("components.animation")
local Input = require("components.input")
local Movement = require("components.movement")
local PlayerComponent = require("components.player")

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

	-- Create player component
	local player = PlayerComponent.New({
		playerNumber = playerNumber,
	})

	-- Create input component
	local input = Input.New({
		lastDirection = initialDirection,
	})

	-- Create movement component
	local movement = Movement.New({
		posQueue = {},
		moveTimer = 0,
		sfx = SFX_NONE,
	})

	-- Create and return entity directly (no wrapper)
	return Entity.New({
		position = pos,
		animation = animation,
		input = input,
		movement = movement,
		player = player,
		keyColor = opts.keyColor or 0,
		rotate = initialRotation,
		currentLevel = opts.currentLevel or 0,
	})
end

return Player
