require("consts")
require("common")

local Player = require("entities.player")
local PositionComponent = require("components.position")
local Map = require("services.map")
local Director = require("scenes.director")
local HUD = require("services.hud")
local SoundSystem = require("systems.sound")
local World = require("world")
local RenderSystem = require("systems.render")
local AnimationSystem = require("systems.animation")
local InputSystem = require("systems.input")
local MovementSystem = require("systems.movement")
local InputComponent = require("components.input")

local GameScene = {}

function GameScene.New()
	local world = World.New()

	-- Order matters: input -> movement -> animation -> render
	World.AddSystem(world, InputSystem)
	World.AddSystem(world, MovementSystem)
	World.AddSystem(world, AnimationSystem)
	World.AddSystem(world, RenderSystem)

	return {
		currentLevel = 0,
		hud = HUD.New(),
		world = world,
	}
end

function GameScene.LoadLevel(gs, level)
	local playerPositions, clampedLevel = Map.loadLevel(level)
	gs.currentLevel = clampedLevel

	gs.world.currentLevel = clampedLevel

	gs.world.entities = {}
	gs.world.nextEntityId = 1

	for _, posData in ipairs(playerPositions) do
		local playerEntity = Player.New({
			playerNumber = posData.playerNumber,
			group = posData.group or GONE,
			position = PositionComponent.New({
				x = posData.x,
				y = posData.y,
			}),
			direction = posData.direction,
			currentLevel = clampedLevel,
		})
		World.AddEntity(gs.world, playerEntity)

		local startPos = PositionComponent.New({ x = posData.x, y = posData.y })
		local startGridPos = startPos // TILE_SIZE
		Map.markVisited(clampedLevel, startGridPos.x, startGridPos.y, posData.playerNumber)
	end

	if LEVEL_TEXT[clampedLevel] then
		HUD.SetText(gs.hud, LEVEL_TEXT[clampedLevel])
	else
		HUD.ClearText(gs.hud)
	end
	HUD.Blink(gs.hud, false)
end

function GameScene.ChangeLevel(gs, level)
	GameScene.LoadLevel(gs, level)
end

-- Load the next available level or switch to game over if none found
-- startLevel: nil to find first level, or a level number to find next level
function GameScene.LoadNextAvailableLevel(gs, startLevel)
	local level = Map.getLevelToLoad(startLevel)
	if level then
		GameScene.LoadLevel(gs, level)
	else
		Director.Switch(G.Director, "game_over")
	end
end

function GameScene.OnEnter(gs)
	GameScene.LoadNextAvailableLevel(gs, nil)
end

function GameScene.Update(gs)
	gs.world.currentLevel = gs.currentLevel
	World.Update(gs.world)

	local players = World.Query(gs.world, { "player" })
	for _, entity in ipairs(players) do
		entity.currentLevel = gs.currentLevel
	end

	SoundSystem.Update(gs.world)
	HUD.Update(gs.hud)

	local allStuck = #players > 0
		and All(players, function(entity)
			return Map.isPlayerStuck(entity, gs.currentLevel)
		end)

	if allStuck then
		local buttonText = InputComponent.ButtonText(BUTTONS.B)
		HUD.SetText(gs.hud, "You suck, you're STUCK! Press " .. buttonText .. ".")
		HUD.Blink(gs.hud, true)
	end

	if btnp(BUTTONS.B) then
		Map.restoreOriginalMap(gs.currentLevel)
		GameScene.LoadLevel(gs, gs.currentLevel)
	end

	if Map.isLevelComplete(gs.currentLevel) or keyp(16) then -- P key for next level
		GameScene.LoadNextAvailableLevel(gs, gs.currentLevel)
	elseif keyp(15) then -- O key for previous level
		local previousLevel = Map.findPreviousLevel(gs.currentLevel)
		if previousLevel then
			GameScene.LoadLevel(gs, previousLevel)
		end
	end
end

function GameScene.Draw(gs)
	cls(0)

	local mx, my = Map.getCoords(gs.currentLevel)
	map(mx, my, MAP_WIDTH, MAP_HEIGHT, 0, 0)

	World.Draw(gs.world)

	HUD.Draw(gs.hud)
end

return GameScene
