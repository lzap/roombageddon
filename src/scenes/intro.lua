require("consts")
require("common")

local Director = require("scenes.director")

local IntroScene = {}

function IntroScene.New()
	return {}
end

function IntroScene.Update(is)
	if
		btnp(BUTTONS.A)
		or btnp(BUTTONS.B)
		or btnp(BUTTONS.X)
		or btnp(BUTTONS.Y)
		or btnp(BUTTONS.LEFT)
		or btnp(BUTTONS.RIGHT)
		or btnp(BUTTONS.UP)
		or btnp(BUTTONS.DOWN)
	then
		local sm = G.SM
		Director.Switch(sm, "game")
	end
end

function IntroScene.Draw(is)
	cls()
	CPrint("ROOMBAGEDDON", 30, COLORS.YELLOW)
	CPrint("by lzap & ozap", 40, COLORS.D_GRAY)
	CPrint("Press anything to start", 50, COLORS.D_GREEN)
end

return IntroScene
