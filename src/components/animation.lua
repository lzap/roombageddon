local AnimationComponent = {}

-- Create a new animation component
-- @param opts Options table with:
--   anim: Dictionary of animations: {name = {frames = {...}, speed = N}}
--   curAnim: Current animation name (optional)
--   frame: Current frame index (optional, default: 1)
--   frameTime: Frames elapsed for current frame (optional, default: 0)
-- @return Animation component
function AnimationComponent.New(opts)
	opts = opts or {}
	return {
		anim = opts.anim or {},
		curAnim = opts.curAnim or nil,
		frame = opts.frame or 1,
		frameTime = opts.frameTime or 0,
	}
end

-- Set the current animation
-- @param animation Animation component
-- @param animName Name of the animation to set
function AnimationComponent.SetAnimation(animation, animName)
	if animation.anim[animName] then
		animation.curAnim = animName
		animation.frame = 1
		animation.frameTime = 0
	end
end

-- Get current sprite ID from animation
-- @param animation Animation component
-- @return Sprite ID or nil
function AnimationComponent.GetCurrentSprite(animation)
	if animation.curAnim == nil or animation.anim == nil or animation.anim[animation.curAnim] == nil then
		return nil
	end

	local animData = animation.anim[animation.curAnim]
	if animData.frames == nil or #animData.frames == 0 then
		return nil
	end

	return animData.frames[animation.frame]
end

return AnimationComponent
