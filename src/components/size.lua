-- size --
local Object = require("object")

---@class Size : Object
---@field width number
---@field height number
local Size = Object:extend("Size")

---@param table? {width?: number, height?: number}
function Size:__init(table)
	self.width = table.width or 0
	self.height = table.height or 0
end

return Size
