local AnimationComponent = {}

-- Create a new animation component
-- @param opts Options table with:
--   frames: List of sprite IDs (optional)
--   speed: Animation speed in frames (optional, default: 10)
--   frame: Current frame index (optional, default: 1)
--   frameTime: Frames elapsed for current frame (optional, default: 0)
-- @return Animation component
function AnimationComponent.New(opts)
	opts = opts or {}
	return {
		frames = opts.frames or {},
		speed = opts.speed or 10,
		frame = opts.frame or 1,
		frameTime = opts.frameTime or 0,
	}
end

-- Get current sprite ID from animation
-- @param animation Animation component
-- @return Sprite ID or nil
function AnimationComponent.GetCurrentSprite(animation)
	if animation.frames == nil or #animation.frames == 0 then
		return nil
	end

	return animation.frames[animation.frame]
end

return AnimationComponent
