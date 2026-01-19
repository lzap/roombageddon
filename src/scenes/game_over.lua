require("consts")
require("common")

local GameOverScene = {}

function GameOverScene.New()
	return {}
end

function GameOverScene.Update(gos)
	-- TODO add "final" level with 99 randomly placed players (pseudo generator)
end

function GameOverScene.Draw(gos)
	cls()
	CPrint("GAME OVER", SCREEN_HEIGHT / 2, COLORS.WHITE)
end

return GameOverScene
