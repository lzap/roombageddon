-- hud service --
require("consts")

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
		-- Blink between yellow and white, 2x faster (15 frames instead of 30)
		local blinkState = math.floor(hud.blinkTimer / 15) % 2
		if blinkState == 0 then
			color = COLORS.YELLOW
		else
			color = COLORS.WHITE
		end
	end

	local textWidth = print(hud.text, -8, -8)
	local x = (SCREEN_WIDTH - textWidth) / 2
	local y = SCREEN_HEIGHT - 8

	print(hud.text, x, y, color)
end

return HUD
