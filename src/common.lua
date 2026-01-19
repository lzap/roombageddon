-- debug helper --
--- Recursively converts a value to a string representation.
-- @param o The value to dump (table, number, string, etc.)
-- @return String representation of the value
function Dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. Dump(v) .. ","
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
function CPrint(t, y, c)
	local w = print(t, -8, -8)
	local x = (240 - w) / 2
	print(t, x, y, c)
end

-- collection utils --
--- Returns true if any element in the table satisfies the predicate function.
-- @param t Table to check
-- @param fn Predicate function that takes an element and returns boolean
-- @return true if any element satisfies the predicate, false otherwise
function Any(t, fn)
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
function All(t, fn)
	for _, v in ipairs(t) do
		if not fn(v) then
			return false
		end
	end
	return true
end

