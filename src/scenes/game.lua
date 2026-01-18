-- game scene --
require("consts")

local Player = require("entities.player")
local Position = require("components.position")
local MapService = require("services.map_service")

local GameScene = {}

function GameScene.New()
	return {
		players = {},
		currentLevel = 0
	}
end

function GameScene.LoadLevel(gs, level)
	local playerPositions, clampedLevel = MapService.loadLevel(level)
	gs.currentLevel = clampedLevel
	
	-- Clear existing players
	gs.players = {}
	
	-- Create players at found positions
	for _, posData in ipairs(playerPositions) do
		table.insert(gs.players, Player.New {
			playerNumber = posData.playerNumber,
			position = Position.New {
				x = posData.x,
				y = posData.y
			}
		})
	end
	
	trace("Loaded level " .. clampedLevel .. " with " .. #gs.players .. " players")
end

function GameScene.ChangeLevel(gs, level)
	GameScene.LoadLevel(gs, level)
end

function GameScene.OnEnter(gs)
	trace("GameScene:on_enter")
	-- Load level 0 by default
	GameScene.LoadLevel(gs, 0)
end

function GameScene.Update(gs)
	-- This is essentially your "System" runner
	for _, p in ipairs(gs.players) do
		Player.Update(p)
	end
	
	-- Level transition logic could go here:
	-- if PlayerAtExit(gs.players[1]) then GameScene.LoadLevel(gs, gs.currentLevel + 1) end
end

function GameScene.Draw(gs)
	cls(0)
	
	-- Draw Map
	local mx, my = MapService.getCoords(gs.currentLevel)
	map(mx, my, MAP_WIDTH, MAP_HEIGHT, 0, 0)
	
	-- Draw Entities
	for _, p in ipairs(gs.players) do
		Player.Draw(p)
	end
end

return GameScene
