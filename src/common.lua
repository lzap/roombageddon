-- debug helper --
--- Recursively converts a value to a string representation.
-- @param o The value to dump (table, number, string, etc.)
-- @return String representation of the value
function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

-- print utils --
--- Prints text centered horizontally on the screen.
-- @param t Text to print
-- @param y Y coordinate for vertical position
-- @param c Color index
function cprint(t, y, c)
	local w = print(t, -8, -8)
	local x = (240 - w) / 2
	print(t, x, y, c)
end

-- collection utils --
--- Returns true if any element in the table satisfies the predicate function.
-- @param t Table to check
-- @param fn Predicate function that takes an element and returns boolean
-- @return true if any element satisfies the predicate, false otherwise
function any(t, fn)
	for _, v in ipairs(t) do
		if fn(v) then
			return true
		end
	end
	return false
end

--- Returns true if all elements in the table satisfy the predicate function.
-- @param t Table to check
-- @param fn Predicate function that takes an element and returns boolean
-- @return true if all elements satisfy the predicate, false otherwise
function all(t, fn)
	for _, v in ipairs(t) do
		if not fn(v) then
			return false
		end
	end
	return true
end

-- player utilities --
require("consts")
local Map = require("services.map")

--- Check if a player entity is stuck (cannot move in any direction)
-- @param entity Entity with player, movement, and position components
-- @param currentLevel Current level number for collision checking
-- @return true if player is stuck, false otherwise
function IsPlayerStuck(entity, currentLevel)
	if entity == nil or entity.movement == nil or entity.position == nil then
		return false
	end

	-- Player is stuck if they're not moving and can't move in any direction
	if #entity.movement.posQueue > 0 then
		return false -- Player is currently moving
	end

	-- Get current grid position
	local gridPos = entity.position // TILE_SIZE

	-- Check if player can move in any direction
	for direction = UP, RIGHT do
		local dirData = DIRS[direction]
		local targetGridPos = gridPos + dirData

		if Map.canMoveTo(currentLevel, targetGridPos.x, targetGridPos.y) then
			return false -- Can move in at least one direction
		end
	end

	-- Cannot move in any direction
	return true
end
