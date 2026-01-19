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
			playerNumber = opts.playerNumber or 1,
		}),
		input = InputComponent.New(),
		movement = MovementComponent.New(),
		keyColor = opts.keyColor or 0,
		rotate = DirectionToRotation(RIGHT),
		currentLevel = opts.currentLevel or 0,
	})
end

return Player
