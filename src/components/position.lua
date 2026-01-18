-- position --
require("consts")

local Object = require("object")

---@class Position : Object
---@field x number
---@field y number
local Position = Object:extend("Position")

---@param table? {x?: number, y?: number}
function Position:__init(table)
	self.x = table.x or 0
	self.y = table.y or 0
end

---@return Position
function Position:copy()
	---@type Position
	local pos = Position:new {
		x = self.x,
		y = self.y
	}
	return pos
end

---@param dir {x: number, y: number}
---@param step_size? number
function Position:move_to(dir, step_size)
	if step_size == nil then
		step_size = TILE_SIZE
	end

	self.x = self.x + dir.x * step_size
	self.y = self.y + dir.y * step_size
end

return Position
