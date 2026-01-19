-- animation component --

local Animation = {}

function Animation.New(opts)
	opts = opts or {}
	return {
		anim = opts.anim or {}, -- Dictionary of animations: {name = {frames = {...}, speed = N}}
		curAnim = opts.curAnim or nil, -- Current animation name
		frame = opts.frame or 1, -- Current frame index
		frameTime = opts.frameTime or 0, -- Frames elapsed for current frame
	}
end

-- Set the current animation
-- @param animation Animation component
-- @param animName Name of the animation to set
function Animation.SetAnimation(animation, animName)
	if animation.anim[animName] then
		animation.curAnim = animName
		animation.frame = 1
		animation.frameTime = 0
	end
end

-- Get current sprite ID from animation
-- @param animation Animation component
-- @return Sprite ID or nil
function Animation.GetCurrentSprite(animation)
	if animation.curAnim == nil or animation.anim == nil or animation.anim[animation.curAnim] == nil then
		return nil
	end
	
	local animData = animation.anim[animation.curAnim]
	if animData.frames == nil or #animData.frames == 0 then
		return nil
	end
	
	return animData.frames[animation.frame]
end

return Animation
