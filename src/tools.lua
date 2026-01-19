-- rarely used one-time tools (you are probably looking for common.lua)

local Tools = {}

--- Creates a grid of markers on the map.
function Tools.MarkCenters(tile_id)
	for i = 0, 63 do
		local x = (i % 8) * 30 + 15
		local y = math.floor(i / 8) * 17 + 8
		mset(x, y, tile_id)
	end
	sync(4, 0, true)
	trace("SUCCESS: Markers created and synced!")
end

--- Swaps two horizontal rows of rooms in the map memory.
-- @param rowA index of the first row (0-7)
-- @param rowB index of the second row (0-7)
function Tools.SwapRows(rowA, rowB)
	-- 1. Validation (Go-style: check your inputs)
	if rowA == rowB then
		return
	end
	if rowA < 0 or rowA > 7 or rowB < 0 or rowB > 7 then
		trace("ERROR: Row index must be between 0 and 7", 2)
		return
	end

	local MAP_WIDTH = 240
	local ROOM_HEIGHT = 17
	local startY_A = rowA * ROOM_HEIGHT
	local startY_B = rowB * ROOM_HEIGHT

	-- 2. Buffer for Row A
	local buffer = {}

	-- Read Row A into the buffer
	for y = 0, ROOM_HEIGHT - 1 do
		buffer[y] = {}
		for x = 0, MAP_WIDTH - 1 do
			buffer[y][x] = mget(x, startY_A + y)
		end
	end

	-- 3. Overwrite Row A with Row B data
	for y = 0, ROOM_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			local tileFromB = mget(x, startY_B + y)
			mset(x, startY_A + y, tileFromB)
		end
	end

	-- 4. Overwrite Row B with the Buffer (Original Row A)
	for y = 0, ROOM_HEIGHT - 1 do
		for x = 0, MAP_WIDTH - 1 do
			mset(x, startY_B + y, buffer[y][x])
		end
	end

	-- 5. Commit changes to Cartridge/ROM
	sync(4, 0, true)
	trace("SWAP COMPLETE: Row " .. rowA .. " <-> Row " .. rowB, 6)
end

return Tools
