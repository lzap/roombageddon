local PlayerComponent = {}

function PlayerComponent.New(opts)
	opts = opts or {}
	return {
		playerNumber = opts.playerNumber or 1,
	}
end

return PlayerComponent
