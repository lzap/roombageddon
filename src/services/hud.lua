require("consts")
local TXT = require("services.txt")

local HUD = {}

function HUD.New()
	return {
		text = nil,
		blink = false,
		blinkTimer = 0,
	}
end

function HUD.SetText(hud, text)
	hud.text = text
end

function HUD.ClearText(hud)
	hud.text = nil
end

function HUD.Blink(hud, enable)
	hud.blink = enable
	if not enable then
		hud.blinkTimer = 0
	end
end

function HUD.Update(hud)
	if hud.blink then
		hud.blinkTimer = hud.blinkTimer + 1
	end
end

function HUD.Draw(hud)
	if hud.text == nil then
		return
	end

	local color = COLORS.WHITE
	if hud.blink then
		local blinkState = math.floor(hud.blinkTimer / 15) % 2
		if blinkState == 0 then
			color = COLORS.YELLOW
		else
			color = COLORS.WHITE
		end
	end

	local y = SCREEN_HEIGHT - 8
	TXT.PrintMixed(y, hud.text, color)
end

return HUD
