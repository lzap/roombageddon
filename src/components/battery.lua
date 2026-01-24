local BatteryComponent = {}

-- Create a new battery component
-- @param opts Table with initialCapacity and currentCapacity (optional, defaults to initialCapacity)
-- @return Battery component
function BatteryComponent.New(opts)
	opts = opts or {}
	local initialCapacity = opts.initialCapacity or 0
	local currentCapacity = opts.currentCapacity
	if currentCapacity == nil then
		currentCapacity = initialCapacity
	end
	return {
		initialCapacity = initialCapacity,
		currentCapacity = currentCapacity,
	}
end

return BatteryComponent
