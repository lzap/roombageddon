-- intro scene --
require("consts")
require("common")

local SceneManager = require("scenes.scene_manager")

local IntroScene = {}

function IntroScene.New()
	return {}
end

function IntroScene.Update(is)
	if btnp(BUTTONS.A) or btnp(BUTTONS.B) then
		local sm = G.SM
		SceneManager.Switch(sm, "game")
	end
end

function IntroScene.Draw(is)
	cls()
	cprint("Welcome, press something", 40, COLORS.YELLOW)
end

return IntroScene
