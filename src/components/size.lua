-- size --

local Size = {}

function Size.New(opts)
	opts = opts or {}
	return {
		width = opts.width or 0,
		height = opts.height or 0,
	}
end

return Size
