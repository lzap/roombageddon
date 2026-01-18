-- intro scene --
require("consts")
require("common")

local Scene = require("scenes.scene")

local IntroScene = Scene:extend("IntroScene")

function IntroScene:__init(table)
	self.super:__init(table)
end

function IntroScene:update()
	if btnp(BUTTONS.A) or btnp(BUTTONS.B) then
		local sm = G.SM
		sm:switch("game")
	end
end

function IntroScene:draw()
	cls()
	cprint("Welcome, press something", 40, COLORS.YELLOW)
end

return IntroScene
