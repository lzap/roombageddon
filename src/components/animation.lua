require("consts")

local AnimationComponent = {}

-- Create a new animation component
-- @param opts Options table with:
--   frames: Hash of frame lists indexed by frame group (optional)
--   speeds: Hash of speed values indexed by frame group (optional)
--   frameGroup: Current frame group constant (optional, default: GONE)
--   frame: Current frame index (optional, default: 1)
--   frameTime: Frames elapsed for current frame (optional, default: 0)
-- @return Animation component
function AnimationComponent.New(opts)
	opts = opts or {}
	return {
		frames = opts.frames or {},
		speeds = opts.speeds or {},
		frameGroup = opts.frameGroup or GONE,
		frame = opts.frame or 1,
		frameTime = opts.frameTime or 0,
	}
end

-- Get current sprite ID from animation
-- @param animation Animation component
-- @return Sprite ID or nil
function AnimationComponent.GetCurrentSprite(animation)
	if animation.frames == nil or animation.frameGroup == nil then
		return nil
	end

	local frameList = animation.frames[animation.frameGroup]
	if frameList == nil or #frameList == 0 then
		return nil
	end

	return frameList[animation.frame]
end

return AnimationComponent
