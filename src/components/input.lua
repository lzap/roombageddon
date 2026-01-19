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

-- Get button text representation based on gamepad state
-- @param button Button constant (BUTTONS.A, BUTTONS.B, BUTTONS.X, BUTTONS.Y)
-- @return String representation of the button
function InputComponent.ButtonText(button)
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

return InputComponent
