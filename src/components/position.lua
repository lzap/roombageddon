-- position --
require("consts")

local Position = {}

-- Metatable for Position objects with overloaded operators
local positionMetatable = {
	-- Addition: Position + Position or Position + {x, y}
	__add = function(a, b)
		if type(a) == "number" then
			-- scalar + Position (not common, but handle it)
			return Position.New({ x = b.x + a, y = b.y + a })
		elseif type(b) == "number" then
			-- Position + scalar
			return Position.New({ x = a.x + b, y = a.y + b })
		else
			-- Position + Position or Position + {x, y}
			return Position.New({ x = a.x + (b.x or 0), y = a.y + (b.y or 0) })
		end
	end,

	-- Subtraction: Position - Position
	__sub = function(a, b)
		if type(b) == "number" then
			-- Position - scalar
			return Position.New({ x = a.x - b, y = a.y - b })
		else
			-- Position - Position or Position - {x, y}
			return Position.New({ x = a.x - (b.x or 0), y = a.y - (b.y or 0) })
		end
	end,

	-- Multiplication: Position * scalar or scalar * Position
	__mul = function(a, b)
		if type(a) == "number" then
			-- scalar * Position
			return Position.New({ x = b.x * a, y = b.y * a })
		elseif type(b) == "number" then
			-- Position * scalar
			return Position.New({ x = a.x * b, y = a.y * b })
		else
			-- Position * Position (dot product would be unusual, but return component-wise)
			return Position.New({ x = a.x * (b.x or 0), y = a.y * (b.y or 0) })
		end
	end,

	-- Division: Position / scalar
	__div = function(a, b)
		if type(b) == "number" then
			return Position.New({ x = a.x / b, y = a.y / b })
		else
			-- Position / Position (component-wise division)
			return Position.New({ x = a.x / (b.x or 1), y = a.y / (b.y or 1) })
		end
	end,

	-- Floor division: Position // scalar
	__idiv = function(a, b)
		if type(b) == "number" then
			return Position.New({ x = math.floor(a.x / b), y = math.floor(a.y / b) })
		else
			-- Position // Position (component-wise floor division)
			return Position.New({ x = math.floor(a.x / (b.x or 1)), y = math.floor(a.y / (b.y or 1)) })
		end
	end,

	-- Unary minus: -Position
	__unm = function(a)
		return Position.New({ x = -a.x, y = -a.y })
	end,

	-- Equality: Position == Position
	__eq = function(a, b)
		return a.x == b.x and a.y == b.y
	end,
}

function Position.New(opts)
	opts = opts or {}
	local pos = {
		x = opts.x or 0,
		y = opts.y or 0,
	}
	setmetatable(pos, positionMetatable)
	return pos
end

function Position.Copy(pos)
	return Position.New({
		x = pos.x,
		y = pos.y,
	})
end

function Position.MoveTo(pos, dir, stepSize)
	if stepSize == nil then
		stepSize = TILE_SIZE
	end
	local offset = dir * stepSize
	pos.x = pos.x + offset.x
	pos.y = pos.y + offset.y
end

return Position
