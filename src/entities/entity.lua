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

-- Note: Entity.Update() and Entity.Draw() have been removed.
-- Use AnimationSystem and RenderSystem instead.

return Entity
