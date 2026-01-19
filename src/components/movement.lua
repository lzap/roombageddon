-- movement component --

local Movement = {}

function Movement.New(opts)
	opts = opts or {}
	return {
		posQueue = opts.posQueue or {}, -- FIFO queue of target positions
		moveTimer = opts.moveTimer or 0, -- Frames counter for pixel movement
		sfx = opts.sfx or 0, -- Sound effect flag (SFX_NONE, SFX_MOVED, SFX_BUMPED)
	}
end

-- Add a target position to the movement queue
-- @param movement Movement component
-- @param targetPos Position to move to
function Movement.QueuePosition(movement, targetPos)
	table.insert(movement.posQueue, targetPos)
	if #movement.posQueue == 1 then
		movement.moveTimer = 0
	end
end

-- Clear the movement queue
-- @param movement Movement component
function Movement.ClearQueue(movement)
	movement.posQueue = {}
	movement.moveTimer = 0
end

return Movement
