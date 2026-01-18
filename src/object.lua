---@class Object
---@field __name string
---@field super Object|nil
local Object = {
	__name = "Object"
}

---@param table? table
---@return any
function Object:new(table)
	local cls = setmetatable({}, self)
	self.__index = self

	cls:__init(table)

	return cls
end

---@param table? table
function Object:__init(table)
end

---@return string
function Object:__tostring()
	return self.__name
end

---@param name string
---@return any
function Object:extend(name)
	local cls = {
		__init = self.__init,
		__tostring = self.__tostring,
		__name = name
	}
	setmetatable(cls, {
		__index = self
	})

	for k, v in pairs(self) do
		if string.sub(k, 1, 2) ~= "__" then
			cls[k] = v
		end
	end

	cls.super = self

	return cls
end

return Object
