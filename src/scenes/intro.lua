-- intro scene --
require("consts")
require("common")

local SceneManager = require("scenes.scene_manager")

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
		SceneManager.Switch(sm, "game")
	end
end

function IntroScene.Draw(is)
	cls()
	cprint("ROOMBAGEDDON", 30, COLORS.YELLOW)
	cprint("by lzap", 40, COLORS.D_GRAY)
	cprint("Press anything to start", 50, COLORS.D_GREEN)
end

return IntroScene
