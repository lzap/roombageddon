require("consts")
require("common")

local SizeComponent = require("components.size")
local PositionComponent = require("components.position")
local AnimationComponent = require("components.animation")
local InputComponent = require("components.input")
local MovementComponent = require("components.movement")
local PlayerComponent = require("components.player")
local BatteryComponent = require("components.battery")

local Player = {}

function Player.New(opts)
	opts = opts or {}
	local group = opts.group or GONE
	local playerNumber = opts.playerNumber or 1
	local direction = opts.direction or RIGHT

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
			frames = {
				[GONE] = { 256, 257 },   -- Group one
				[GTWO] = { 272, 273 },   -- Group two
				[GDEAD] = { 288, 289 },  -- Dead battery
			},
			speeds = {
				[GONE] = 10,
				[GTWO] = 10,
				[GDEAD] = 120,
			},
			frameGroup = group,
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
		battery = opts.battery or BatteryComponent.New(),
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
