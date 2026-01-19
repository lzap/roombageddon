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

function GameScene.OnEnter(gs)
	GameScene.LoadLevel(gs, 0)
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

	if Map.isLevelComplete(gs.currentLevel) or (btn(BUTTONS.X) and btn(BUTTONS.Y) and btnp(BUTTONS.RIGHT)) then
		if gs.currentLevel >= LEVEL_COUNT - 1 then
			Director.Switch(G.Director, "game_over")
		else
			GameScene.LoadLevel(gs, gs.currentLevel + 1)
		end
	elseif btn(BUTTONS.X) and btn(BUTTONS.Y) and btnp(BUTTONS.LEFT) then
		GameScene.LoadLevel(gs, gs.currentLevel - 1)
	elseif btn(BUTTONS.X) and btn(BUTTONS.Y) and btnp(BUTTONS.UP) then
		local newLevel = gs.currentLevel - MAPS_PER_ROW
		GameScene.LoadLevel(gs, newLevel)
	elseif btn(BUTTONS.X) and btn(BUTTONS.Y) and btnp(BUTTONS.DOWN) then
		local newLevel = gs.currentLevel + MAPS_PER_ROW
		GameScene.LoadLevel(gs, newLevel)
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
