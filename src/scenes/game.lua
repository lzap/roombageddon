-- game scene --
require("consts")

local Scene = require("scenes.scene")
local Player = require("entities.player")
local Position = require("components.position")

local GameScene = Scene:extend("GameScene")

function GameScene:__init(table)
	self.super:__init(table)
	self.players = {}
end

function GameScene:on_enter()
	trace("GameScene:on_enter")
	
	-- Create two players
	table.insert(self.players, Player:new {
		player_number = 1,
		position = Position:new {
			x = SCREEN_WIDTH / 2 - TILE_SIZE * 2,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE
		}
	})
	
	table.insert(self.players, Player:new {
		player_number = 2,
		position = Position:new {
			x = SCREEN_WIDTH / 2 + TILE_SIZE,
			y = SCREEN_HEIGHT / 2 - TILE_SIZE
		}
	})
end

function GameScene:update()
	for _, player in ipairs(self.players) do
		player:update()
	end
end

function GameScene:draw()
	cls()
	cprint("Game Scene", 40, COLORS.RED)
	
	for _, player in ipairs(self.players) do
		player:draw()
	end
end

return GameScene
