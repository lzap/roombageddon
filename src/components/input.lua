require("consts")

local InputComponent = {}

-- Gamepad flag is heuristically set to false during intro scene
InputComponent.Gamepad = false

function InputComponent.New(opts)
	opts = opts or {}
	return {
		lastDirection = opts.lastDirection or nil,
		direction = opts.direction or nil,
	}
end

function InputComponent.Clear(input)
	input.direction = nil
end

return InputComponent
