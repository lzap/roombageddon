-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")

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
		playerNumber = playerNumber
	}
end

function Player.Update(p)
	Entity.Update(p.entity)
end

function Player.Draw(p)
	Entity.Draw(p.entity)
end

return Player
