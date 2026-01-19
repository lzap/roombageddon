local MovementComponent = {}

-- Create a new movement component
-- @return Movement component
function MovementComponent.New(opts)
	opts = opts or {}
	return {
		posQueue = opts.posQueue or {},
		moveTimer = opts.moveTimer or 0,
		sfx = opts.sfx or 0,
	}
end

-- Add a target position to the movement queue
-- @param movement Movement component
-- @param targetPos Position to move to
function MovementComponent.QueuePosition(movement, targetPos)
	table.insert(movement.posQueue, targetPos)
	if #movement.posQueue == 1 then
		movement.moveTimer = 0
	end
end

-- Clear the movement queue
-- @param movement Movement component
function MovementComponent.ClearQueue(movement)
	movement.posQueue = {}
	movement.moveTimer = 0
end

return MovementComponent
