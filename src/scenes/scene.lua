-- scene --
local Object = require("object")

---@class Scene : Object
local Scene = Object:extend("Scene")

---@param table? table
function Scene:__init(table)
end

function Scene:on_enter()
end

function Scene:on_exit()
end

function Scene:update()
end

function Scene:draw()
end

return Scene
