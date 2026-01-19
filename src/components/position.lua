require("consts")

local PositionComponent = {}

local positionMetatable = {
	__add = function(a, b)
		if type(a) == "number" then
			-- scalar + Position (not common, but handle it)
			return PositionComponent.New({ x = b.x + a, y = b.y + a })
		elseif type(b) == "number" then
			-- Position + scalar
			return PositionComponent.New({ x = a.x + b, y = a.y + b })
		else
			-- Position + Position or Position + {x, y}
			return PositionComponent.New({ x = a.x + (b.x or 0), y = a.y + (b.y or 0) })
		end
	end,

	__sub = function(a, b)
		if type(b) == "number" then
			-- Position - scalar
			return PositionComponent.New({ x = a.x - b, y = a.y - b })
		else
			-- Position - Position or Position - {x, y}
			return PositionComponent.New({ x = a.x - (b.x or 0), y = a.y - (b.y or 0) })
		end
	end,

	__mul = function(a, b)
		if type(a) == "number" then
			-- scalar * Position
			return PositionComponent.New({ x = b.x * a, y = b.y * a })
		elseif type(b) == "number" then
			-- Position * scalar
			return PositionComponent.New({ x = a.x * b, y = a.y * b })
		else
			-- Position * Position (dot product would be unusual, but return component-wise)
			return PositionComponent.New({ x = a.x * (b.x or 0), y = a.y * (b.y or 0) })
		end
	end,

	__div = function(a, b)
		if type(b) == "number" then
			-- Position / scalar
			return PositionComponent.New({ x = a.x / b, y = a.y / b })
		else
			-- Position / Position (component-wise division)
			return PositionComponent.New({ x = a.x / (b.x or 1), y = a.y / (b.y or 1) })
		end
	end,

	__idiv = function(a, b)
		if type(b) == "number" then
			-- Position // scalar
			return PositionComponent.New({ x = math.floor(a.x / b), y = math.floor(a.y / b) })
		else
			-- Position // Position (component-wise floor division)
			return PositionComponent.New({ x = math.floor(a.x / (b.x or 1)), y = math.floor(a.y / (b.y or 1)) })
		end
	end,

	__unm = function(a)
		return PositionComponent.New({ x = -a.x, y = -a.y })
	end,

	__eq = function(a, b)
		return a.x == b.x and a.y == b.y
	end,
}

-- Create a new position component
-- @param opts Options table with:
--   x: X coordinate (optional, default: 0)
--   y: Y coordinate (optional, default: 0)
-- @return Position component
function PositionComponent.New(opts)
	opts = opts or {}
	local pos = {
		x = opts.x or 0,
		y = opts.y or 0,
	}
	setmetatable(pos, positionMetatable)
	return pos
end

-- Copy a position component
-- @param pos Position component
-- @return Copy of the position component
function PositionComponent.Copy(pos)
	return PositionComponent.New({
		x = pos.x,
		y = pos.y,
	})
end

-- Move a position component to a direction
-- @param pos Position component
-- @param dir Direction to move to
-- @param stepSize Step size (optional, default: TILE_SIZE)
-- @return Position component
function PositionComponent.MoveTo(pos, dir, stepSize)
	if stepSize == nil then
		stepSize = TILE_SIZE
	end
	local offset = dir * stepSize
	pos.x = pos.x + offset.x
	pos.y = pos.y + offset.y
end

return PositionComponent
