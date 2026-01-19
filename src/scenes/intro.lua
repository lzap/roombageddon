require("consts")
require("common")

local Director = require("scenes.director")
local InputComponent = require("components.input")

local IntroScene = {}

function IntroScene.New()
	return {
		startFrame = 0,
	}
end

function IntroScene.OnEnter(is)
	-- Reset start frame when scene is entered
	is.startFrame = 0
end

function IntroScene.Update(is)
	is.startFrame = is.startFrame + 1
	if is.startFrame < 10 then
		return
	end

	local keyPressed = false
	for i = 0, 65 do
		if keyp(i) then
			keyPressed = true
			break
		end
	end

	local buttonPressed = btnp(BUTTONS.A)
		or btnp(BUTTONS.B)
		or btnp(BUTTONS.X)
		or btnp(BUTTONS.Y)
		or btnp(BUTTONS.LEFT)
		or btnp(BUTTONS.RIGHT)
		or btnp(BUTTONS.UP)
		or btnp(BUTTONS.DOWN)

	if keyPressed then
		InputComponent.Gamepad = false
	elseif buttonPressed then
		InputComponent.Gamepad = true
	end

	if keyPressed or buttonPressed then
		Director.Switch(G.Director, "game")
	end
end

function IntroScene.Draw(is)
	cls()
	CPrint("ROOMBAGEDDON", 30, COLORS.YELLOW)
	CPrint("by lzap & ozap", 40, COLORS.D_GRAY)
	CPrint("Press anything to start", 50, COLORS.D_GREEN)
end

return IntroScene
