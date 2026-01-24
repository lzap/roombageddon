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
local TXT = require("services.txt")
local BatteryComponent = require("components.battery")

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
	gs.world.movementBuffer = ""

	-- Get battery configuration for this level
	local levelData = LEVELS[clampedLevel + 1]
	local batOneConfig = nil
	local batTwoConfig = nil
	if levelData then
		batOneConfig = levelData.BatOne
		batTwoConfig = levelData.BatTwo
	end

	for _, posData in ipairs(playerPositions) do
		local group = posData.group or GONE
		local playerNumber = posData.playerNumber or 1
		local batteryCapacity = 0

		-- Initialize battery from level config if available
		if group == GONE and batOneConfig then
			-- Get battery for this player number in group one
			if batOneConfig[playerNumber] then
				batteryCapacity = batOneConfig[playerNumber]
			end
		elseif group == GTWO and batTwoConfig then
			-- Get battery for this player number in group two
			if batTwoConfig[playerNumber] then
				batteryCapacity = batTwoConfig[playerNumber]
			end
		end

		-- If capacity is 0, set to 99999 to allow movement
		if batteryCapacity == 0 then
			batteryCapacity = 99999
		end

		local playerEntity = Player.New({
			playerNumber = posData.playerNumber,
			group = group,
			position = PositionComponent.New({
				x = posData.x,
				y = posData.y,
			}),
			direction = posData.direction,
			battery = BatteryComponent.New({
				initialCapacity = batteryCapacity,
				currentCapacity = batteryCapacity,
			}),
			currentLevel = clampedLevel,
		})
		World.AddEntity(gs.world, playerEntity)

		local startPos = PositionComponent.New({ x = posData.x, y = posData.y })
		local startGridPos = startPos // TILE_SIZE
		Map.markVisited(clampedLevel, startGridPos.x, startGridPos.y, posData.playerNumber)
	end

	if LEVELS[clampedLevel + 1] then
		HUD.SetText(gs.hud, LEVELS[clampedLevel + 1].Text)
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

-- Calculate total battery charge for a group
-- @param world World instance
-- @param group Group number (GONE or GTWO)
-- @return Total current capacity for the group
function GameScene.GetTotalBatteryCharge(gs, group)
	local players = World.Query(gs.world, { "player", "battery" })
	local total = 0
	for _, entity in ipairs(players) do
		if entity.player and entity.player.group == group and entity.battery then
			total = total + entity.battery.currentCapacity
		end
	end
	return total
end

-- Calculate total battery capacity for a group
-- @param world World instance
-- @param group Group number (GONE or GTWO)
-- @return Total initial capacity for the group
function GameScene.GetTotalBatteryCapacity(gs, group)
	local players = World.Query(gs.world, { "player", "battery" })
	local total = 0
	for _, entity in ipairs(players) do
		if entity.player and entity.player.group == group and entity.battery then
			total = total + entity.battery.initialCapacity
		end
	end
	return total
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
		HUD.SetText(gs.hud, { "YOU SUCK, YOU'RE STUCK!", SPR_Z, "OR", SPR_X, "TO RESET" })
		HUD.Blink(gs.hud, true)
	end

	if btnp(BUTTONS.A) or btnp(BUTTONS.B) then
		Map.restoreOriginalMap(gs.currentLevel)
		GameScene.LoadLevel(gs, gs.currentLevel)
	end

	if Map.isLevelComplete(gs.currentLevel) or keyp(16) then -- P key for next level
		-- Print movement buffer: auto solving not implemented
		if Map.isLevelComplete(gs.currentLevel) and gs.world.movementBuffer ~= "" then
			trace(gs.world.movementBuffer)
		end
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

	-- Draw battery indicators for each group
	local totalCapacity1 = GameScene.GetTotalBatteryCapacity(gs, GONE)
	local totalCapacity2 = GameScene.GetTotalBatteryCapacity(gs, GTWO)

	-- Only render if both capacities are not above 99999
	if not (totalCapacity1 > 99999 and totalCapacity2 > 99999) then
		local textY = SCREEN_HEIGHT - 8
		local spriteY = textY - 9 -- Sprite above the text with 1px gap

		-- Group one (GONE) - bottom left
		if totalCapacity1 > 0 and totalCapacity1 <= 99999 then
			local totalCharge1 = GameScene.GetTotalBatteryCharge(gs, GONE)
			local percentage = math.floor((totalCharge1 / totalCapacity1) * 100)
			local text = percentage .. "%"
			local textWidth = print(text, -8, -8)
			-- Center sprite relative to text (sprite is 8px wide)
			local spriteX = (textWidth - 8) / 2
			spr(258, spriteX, spriteY, 0, 1, 0, ROTATE_90) -- Facing down
			print(text, 0, textY, COLORS.GREEN)
		end

		-- Group two (GTWO) - bottom right
		if totalCapacity2 > 0 and totalCapacity2 <= 99999 then
			local totalCharge2 = GameScene.GetTotalBatteryCharge(gs, GTWO)
			local percentage = math.floor((totalCharge2 / totalCapacity2) * 100)
			local text = percentage .. "%"
			local textWidth = print(text, -8, -8)
			local textX = SCREEN_WIDTH - textWidth
			-- Center sprite relative to text (sprite is 8px wide)
			local spriteX = textX + (textWidth - 8) / 2
			spr(274, spriteX, spriteY, 0, 1, 0, ROTATE_90) -- Facing down
			print(text, textX, textY, COLORS.GREEN)
		end
	end

	HUD.Draw(gs.hud)
end

return GameScene
