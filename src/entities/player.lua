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
	local group = opts.group or GONE
	local playerNumber = opts.playerNumber or 1
	local direction = opts.direction or RIGHT

	-- Use animated sprites: 256-257 for group one, 272-273 for group two
	local animSpriteBase = 256
	if group == GTWO then
		animSpriteBase = 272
	end
	local animSprite1 = animSpriteBase
	local animSprite2 = animSpriteBase + 1

	-- Determine initial animation based on direction
	local initialAnim = "right"
	if direction == UP then
		initialAnim = "up"
	elseif direction == DOWN then
		initialAnim = "down"
	elseif direction == LEFT then
		initialAnim = "left"
	end

	return Entity.New({
		position = opts.position or PositionComponent.New({
			x = SCREEN_WIDTH / 2 - TILE_SIZE,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE,
		}),
		animation = AnimationComponent.New({
			anim = {
				up = {
					frames = { animSprite1, animSprite2 },
					speed = 10,
				},
				down = {
					frames = { animSprite1, animSprite2 },
					speed = 10,
				},
				left = {
					frames = { animSprite1, animSprite2 },
					speed = 10,
				},
				right = {
					frames = { animSprite1, animSprite2 },
					speed = 10,
				},
			},
			curAnim = initialAnim,
			frame = 1,
			frameTime = 0,
		}),
		player = PlayerComponent.New({
			playerNumber = playerNumber,
			group = group,
		}),
		input = InputComponent.New({
			direction = direction,
			lastDirection = direction,
		}),
		movement = MovementComponent.New(),
		keyColor = opts.keyColor or 0,
		rotate = DirectionToRotation(direction),
		currentLevel = opts.currentLevel or 0,
	})
end

return Player
