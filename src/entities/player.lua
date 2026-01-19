require("consts")
require("common")

local Entity = require("entities.entity")
local PositionComponent = require("components.position")
local AnimationComponent = require("components.animation")
local InputComponent = require("components.input")
local MovementComponent = require("components.movement")
local PlayerComponent = require("components.player")

local Player = {}

function Player.New(opts)
	opts = opts or {}
	local playerNumber = opts.playerNumber or 1
	local direction = opts.direction or RIGHT

	return Entity.New({
		position = opts.position or PositionComponent.New({
			x = SCREEN_WIDTH / 2 - TILE_SIZE,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE,
		}),
		animation = AnimationComponent.New({
			anim = {
				idle = {
					frames = { 256, 257 },
					speed = 10,
				},
			},
			curAnim = "idle",
			frame = 1,
			frameTime = 0,
		}),
		player = PlayerComponent.New({
			playerNumber = playerNumber,
		}),
		input = InputComponent.New({
			lastDirection = direction,
		}),
		movement = MovementComponent.New({
			posQueue = {},
			moveTimer = 0,
			sfx = SFX_NONE,
		}),
		keyColor = opts.keyColor or 0,
		rotate = DirectionToRotation(direction),
		currentLevel = opts.currentLevel or 0,
	})
end

return Player
