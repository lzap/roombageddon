-- game scene --
require("consts")
require("common")

local Player = require("entities.player")
local PositionComponent = require("components.position")
local Map = require("services.map")
local Director = require("scenes.director")
local HUD = require("services.hud")
local SFX = require("services.sfx")
local World = require("world")
local RenderSystem = require("systems.render")
local AnimationSystem = require("systems.animation")
local InputSystem = require("systems.input")
local MovementSystem = require("systems.movement")

local GameScene = {}

function GameScene.New()
	local world = World.New()

	-- Register Systems (order matters: input -> movement -> animation -> render)
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

	-- Store current level in world for systems to access
	gs.world.currentLevel = clampedLevel

	-- Clear all entities from world
	gs.world.entities = {}
	gs.world.nextEntityId = 1

	-- Create players at found positions
	for _, posData in ipairs(playerPositions) do
		-- Player.New() now returns entity directly
		local playerEntity = Player.New({
			playerNumber = posData.playerNumber,
			position = PositionComponent.New({
				x = posData.x,
				y = posData.y,
			}),
			direction = posData.direction,
			currentLevel = clampedLevel,
		})

		-- Add player entity to world
		World.AddEntity(gs.world, playerEntity)

		-- Mark starting position as visited
		local startPos = PositionComponent.New({ x = posData.x, y = posData.y })
		local startGridPos = startPos // TILE_SIZE
		Map.markVisited(clampedLevel, startGridPos.x, startGridPos.y, posData.playerNumber)
	end

	-- Query world for player count
	local players = World.Query(gs.world, { "player" })
	trace("Loaded level " .. clampedLevel .. " with " .. #players .. " players")

	-- Set level text if it exists
	if LEVEL_TEXT[clampedLevel] then
		HUD.SetText(gs.hud, LEVEL_TEXT[clampedLevel])
	else
		HUD.ClearText(gs.hud)
	end
	-- Turn off blinking when level loads
	HUD.Blink(gs.hud, false)
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
	-- Update world's current level
	gs.world.currentLevel = gs.currentLevel

	-- Update all systems (InputSystem -> MovementSystem -> AnimationSystem)
	World.Update(gs.world)

	-- Update player entities' current level (for systems to access)
	local players = World.Query(gs.world, { "player" })
	for _, entity in ipairs(players) do
		entity.currentLevel = gs.currentLevel
	end

	-- Process player movement sounds
	SFX.Process(gs.world)

	HUD.Update(gs.hud)

	-- Check if all players are stuck
	local allStuck = true
	if #players > 0 then
		for _, entity in ipairs(players) do
			if not Map.IsPlayerStuck(entity, gs.currentLevel) then
				allStuck = false
				break
			end
		end
	else
		allStuck = false
	end

	-- Update HUD if all players are stuck
	if allStuck then
		HUD.SetText(gs.hud, "You suck, you're STUCK! Press B.")
		HUD.Blink(gs.hud, true)
	end

	-- Reset level to starting position when B button is pressed
	if btnp(BUTTONS.B) then
		-- Restore original map state
		Map.restoreOriginalMap(gs.currentLevel)
		-- Reload level (which will reset player positions)
		GameScene.LoadLevel(gs, gs.currentLevel)
	end

	if Map.isLevelComplete(gs.currentLevel) or btnp(BUTTONS.A) then
		if gs.currentLevel >= LEVEL_COUNT - 1 then
			local sm = G.SM
			Director.Switch(sm, "game_over")
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

	-- Draw Entities using RenderSystem
	World.Draw(gs.world)

	-- Draw HUD
	HUD.Draw(gs.hud)
end

return GameScene
