-- entity --
require("consts")

local Size = require("components.size")
local Position = require("components.position")
local Animation = require("components.animation")

local Entity = {}

function Entity.New(opts)
	opts = opts or {}
	return {
		size = opts.size or Size.New({
			width = TILE_SIZE,
			height = TILE_SIZE,
		}),
		position = opts.position or Position.New({
			x = 0,
			y = 0,
		}),
		animation = opts.animation or nil, -- AnimationComponent (optional)
		keyColor = opts.keyColor or 0,
		rotate = opts.rotate or 0,
	}
end

-- Note: Entity.Update() is deprecated. Use AnimationSystem instead.
-- Kept for backward compatibility, but AnimationSystem should be used for new code.
function Entity.Update(e)
	if e.animation == nil then
		return
	end
	-- Legacy support: if entity has old-style animation data, convert it
	if e.curAnim ~= nil and e.anim ~= nil then
		-- This is handled by AnimationSystem now
		return
	end
end

-- Note: Entity.Draw() is deprecated. Use RenderSystem instead.
-- Kept for backward compatibility, but RenderSystem should be used for new code.
function Entity.Draw(e)
	if e.animation == nil then
		return
	end
	
	local sprite = Animation.GetCurrentSprite(e.animation)
	if sprite == nil then
		return
	end
	
	local rotate = e.rotate or 0
	spr(sprite, e.position.x, e.position.y, e.keyColor, 1, 0, rotate)
end

return Entity
