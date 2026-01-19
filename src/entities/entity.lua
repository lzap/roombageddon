-- entity --
require("consts")

local Size = require("components.size")
local Position = require("components.position")

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
		keyColor = opts.keyColor or 0,
		frame = opts.frame or 1,
		frameTime = opts.frameTime or 0,
		curAnim = opts.curAnim or nil,
		anim = opts.anim or {},
		rotate = opts.rotate or 0,
	}
end

function Entity.Update(e)
	if e.curAnim == nil or e.anim[e.curAnim] == nil then
		return
	end

	e.frameTime = e.frameTime + 1
	if e.frameTime >= e.anim[e.curAnim].speed then
		e.frame = e.frame + 1
		if e.frame > #e.anim[e.curAnim].frames then
			e.frame = 1
		end
		e.frameTime = 0
	end
end

-- Note: Entity.Draw() is deprecated. Use RenderSystem instead.
-- Kept for backward compatibility, but RenderSystem should be used for new code.
function Entity.Draw(e)
	if e.curAnim == nil or e.anim[e.curAnim] == nil then
		return
	end

	local sprite = e.anim[e.curAnim].frames[e.frame]
	local rotate = e.rotate or 0
	spr(sprite, e.position.x, e.position.y, e.keyColor, 1, 0, rotate)
end

return Entity
