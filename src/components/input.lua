require("consts")

local InputComponent = {}

-- Gamepad flag: true if using gamepad, false if using keyboard
InputComponent.Gamepad = true -- default to gamepad

-- Create a new input component
-- @return Input component
function InputComponent.New(opts)
	opts = opts or {}
	return {
		lastDirection = opts.lastDirection or nil,
		direction = opts.direction or nil,
	}
end

-- Clear current input direction
-- @param input Input component
function InputComponent.Clear(input)
	input.direction = nil
end

return InputComponent
