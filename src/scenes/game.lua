-- game scene --
require("consts")

local Player = require("entities.player")
local Position = require("components.position")
local Map = require("services.map")
local SceneManager = require("scenes.scene_manager")
local HUD = require("services.hud")

local GameScene = {}

function GameScene.New()
	return {
		players = {},
		currentLevel = 0,
		hud = HUD.New()
	}
end

function GameScene.LoadLevel(gs, level)
	local playerPositions, clampedLevel = Map.loadLevel(level)
	gs.currentLevel = clampedLevel

	-- Clear existing players
	gs.players = {}

	-- Create players at found positions
	for _, posData in ipairs(playerPositions) do
		local player = Player.New {
			playerNumber = posData.playerNumber,
			position = Position.New {
				x = posData.x,
				y = posData.y
			},
			direction = posData.direction,
			currentLevel = clampedLevel
		}
		table.insert(gs.players, player)

		-- Mark starting position as visited
		local startGridX = math.floor(posData.x / TILE_SIZE)
		local startGridY = math.floor(posData.y / TILE_SIZE)
		Map.markVisited(clampedLevel, startGridX, startGridY, posData.playerNumber)
	end

	trace("Loaded level " .. clampedLevel .. " with " .. #gs.players .. " players")

	-- Set level text if it exists
	if LEVEL_TEXT[clampedLevel] then
		HUD.SetText(gs.hud, LEVEL_TEXT[clampedLevel])
	else
		HUD.ClearText(gs.hud)
	end
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
	for _, p in ipairs(gs.players) do
		Player.Update(p, gs.currentLevel)
	end

	HUD.Update(gs.hud)

	if Map.isLevelComplete(gs.currentLevel) or btnp(BUTTONS.A) then
		if gs.currentLevel >= LEVEL_COUNT - 1 then
			local sm = G.SM
			SceneManager.Switch(sm, "game_over")
		else
			GameScene.LoadLevel(gs, gs.currentLevel + 1)
		end
	end
end

function GameScene.Draw(gs)
	cls(0)

	-- Draw Map
	local mx, my = Map.getCoords(gs.currentLevel)
	map(mx, my, MAP_WIDTH, MAP_HEIGHT, 0, 0)

	-- Draw Entities
	for _, p in ipairs(gs.players) do
		Player.Draw(p)
	end

	-- Draw HUD
	HUD.Draw(gs.hud)
end

return GameScene
