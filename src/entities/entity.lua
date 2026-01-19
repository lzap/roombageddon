-- entity --
require("consts")

local SizeComponent = require("components.size")
local PositionComponent = require("components.position")
local AnimationComponent = require("components.animation")

local Entity = {}

function Entity.New(opts)
	opts = opts or {}
	local entity = {
		size = opts.size or SizeComponent.New({
			width = TILE_SIZE,
			height = TILE_SIZE,
		}),
		position = opts.position or PositionComponent.New({
			x = 0,
			y = 0,
		}),
		animation = opts.animation or nil, -- AnimationComponent (optional)
		keyColor = opts.keyColor or 0,
		rotate = opts.rotate or 0,
	}

	-- Pass through any additional components/fields from opts
	for key, value in pairs(opts) do
		if entity[key] == nil then
			entity[key] = value
		end
	end

	return entity
end

-- Note: Entity.Update() and Entity.Draw() have been removed.
-- Use AnimationSystem and RenderSystem instead.

return Entity
