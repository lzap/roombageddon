-- game over scene --
require("consts")
require("common")

local GameOverScene = {}

function GameOverScene.New()
	return {}
end

function GameOverScene.Update(gos)
	-- Could add input handling here if needed
end

function GameOverScene.Draw(gos)
	cls()
	cprint("GAME OVER", SCREEN_HEIGHT / 2, COLORS.WHITE)
end

return GameOverScene
