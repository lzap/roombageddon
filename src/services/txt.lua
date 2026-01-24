require("consts")
local InputComponent = require("components.input")
local World = require("world")

local TXT = {}

-- Get button text representation based on gamepad state
-- @param button Button constant (BUTTONS.A, BUTTONS.B, BUTTONS.X, BUTTONS.Y)
-- @return String representation of the button
function TXT.Button(button)
	if InputComponent.Gamepad then
		if button == BUTTONS.A then
			return "(A)"
		elseif button == BUTTONS.B then
			return "(B)"
		elseif button == BUTTONS.X then
			return "(X)"
		elseif button == BUTTONS.Y then
			return "(Y)"
		end
	else
		if button == BUTTONS.A then
			return "Z"
		elseif button == BUTTONS.B then
			return "X"
		elseif button == BUTTONS.X then
			return "A"
		elseif button == BUTTONS.Y then
			return "S"
		end
	end
	return ""
end

-- Print mixed text and sprites together, centered on screen
function TXT.PrintMixed(y, elements, col)
	-- Calculate width first
	local width
	if type(elements) == "string" then
		width = print(elements, -8, -8)
	else
		width = 0
		for _, e in ipairs(elements) do
			if type(e) == "string" then
				width = width + print(e, -8, -8)
			elseif type(e) == "number" then
				width = width + 8 -- 8px sprite
			end
		end
	end

	-- Calculate centered x position
	local x = (SCREEN_WIDTH - width) / 2

	-- Render the content
	if type(elements) == "string" then
		print(elements, x, y, col or 15)
	else
		local cur_x = x
		for _, e in ipairs(elements) do
			if type(e) == "string" then
				cur_x = cur_x + print(e, cur_x, y, col or 15)
			elseif type(e) == "number" then
				local sprite_id = e
				if not InputComponent.Gamepad then
					sprite_id = sprite_id + 16
				end
				spr(sprite_id, cur_x, y - 1, 0)
				cur_x = cur_x + 8
			end
		end
	end

	return width
end

-- Get battery values as string for all players in both groups
-- @param world World instance
-- @return String like "0,0,1 2,4,2"
function TXT.Batteries(world)
	local players = World.Query(world, { "player", "battery" })
	local g1, g2 = {}, {}
	for _, e in ipairs(players) do
		if e.player.group == GONE then
			table.insert(g1, math.floor(e.battery.currentCapacity))
		elseif e.player.group == GTWO then
			table.insert(g2, math.floor(e.battery.currentCapacity))
		end
	end
	local s1 = table.concat(g1, ",")
	local s2 = table.concat(g2, ",")
	return s1 .. " " .. s2
end

return TXT
