require("consts")
require("common")

local SizeComponent = require("components.size")
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

	local entity = {
		size = SizeComponent.New({
			width = TILE_SIZE,
			height = TILE_SIZE,
		}),
		position = opts.position or PositionComponent.New({
			x = SCREEN_WIDTH / 2 - TILE_SIZE,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE,
		}),
		animation = AnimationComponent.New({
			frames = { animSprite1, animSprite2 },
			speed = 10,
			frame = 1,
			frameTime = 0,
		}),
		keyColor = opts.keyColor or 0,
		rotate = DirectionToRotation(direction),
		player = PlayerComponent.New({
			playerNumber = playerNumber,
			group = group,
		}),
		input = InputComponent.New({
			direction = direction,
			lastDirection = direction,
		}),
		movement = MovementComponent.New(),
		currentLevel = opts.currentLevel or 0,
	}

	for key, value in pairs(opts) do
		if entity[key] == nil then
			entity[key] = value
		end
	end

	return entity
end

return Player
