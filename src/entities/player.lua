-- player entity --
require("consts")

local Entity = require("entities.entity")
local Position = require("components.position")

---@class Player : Entity
---@field player_number number
local Player = Entity:extend("Player")

---@param table? {player_number?: number, position?: Position, key_color?: number, sprites?: number[]}
function Player:__init(table)
	table = table or {}
	
	self.player_number = table.player_number or 1
	
	-- Set default position if not provided
	local position = table.position or Position:new {
		x = SCREEN_WIDTH / 2 - TILE_SIZE,
		y = SCREEN_HEIGHT / 2 - TILE_SIZE
	}
	
	-- Use configurable sprites, default to {256, 257}
	local sprites = table.sprites or {256, 257}
	
	-- Initialize parent Entity with player-specific animation
	self.super:__init {
		position = position,
		anim = {
			idle = {
				frames = sprites,
				speed = 10
			}
		},
		cur_anim = "idle",
		frame = 1,
		frame_time = 0,
		key_color = table.key_color or 0
	}
end

return Player
