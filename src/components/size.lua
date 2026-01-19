local SizeComponent = {}

-- Create a new size component
-- @param opts Options table with:
--   width: Width of the size (optional, default: 0)
--   height: Height of the size (optional, default: 0)
-- @return Size component
function SizeComponent.New(opts)
	opts = opts or {}
	return {
		width = opts.width or 0,
		height = opts.height or 0,
	}
end

return SizeComponent
