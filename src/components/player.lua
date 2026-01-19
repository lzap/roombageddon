-- player component --

local PlayerComponent = {}

function PlayerComponent.New(opts)
	opts = opts or {}
	return {
		playerNumber = opts.playerNumber or 1, -- Player number (1-4)
	}
end

return PlayerComponent
