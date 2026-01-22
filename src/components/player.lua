local PlayerComponent = {}

require("consts")

function PlayerComponent.New(opts)
	opts = opts or {}
	return {
		playerNumber = opts.playerNumber or 1,
		group = opts.group or GONE,
	}
end

return PlayerComponent
