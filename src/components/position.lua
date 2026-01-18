-- position --
require("consts")

local Position = {}

function Position.New(opts)
	opts = opts or {}
	return {
		x = opts.x or 0,
		y = opts.y or 0
	}
end

function Position.Copy(pos)
	return Position.New {
		x = pos.x,
		y = pos.y
	}
end

function Position.MoveTo(pos, dir, stepSize)
	if stepSize == nil then
		stepSize = TILE_SIZE
	end
	pos.x = pos.x + dir.x * stepSize
	pos.y = pos.y + dir.y * stepSize
end

function Position.Floor(pos, divisor)
	divisor = divisor or 1
	return Position.New {
		x = math.floor(pos.x / divisor),
		y = math.floor(pos.y / divisor)
	}
end

return Position
