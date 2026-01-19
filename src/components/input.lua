-- input component --

local Input = {}

function Input.New(opts)
	opts = opts or {}
	return {
		lastDirection = opts.lastDirection or nil, -- Last direction moved
		direction = opts.direction or nil, -- Current input direction (UP, DOWN, LEFT, RIGHT)
	}
end

-- Clear current input direction
-- @param input Input component
function Input.Clear(input)
	input.direction = nil
end

return Input
