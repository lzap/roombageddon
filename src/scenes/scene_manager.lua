-- scene manager --
local Object = require("object")

---@class SceneManager : Object
---@field scenes table<string, Scene>
---@field current string|nil
local SceneManager = Object:extend("SceneManager")

function SceneManager:__init()
	self.scenes = {}
	self.current = nil
end

---@param name string
---@param scene Scene
function SceneManager:add(name, scene)
	self.scenes[name] = scene
end

---@param name string
function SceneManager:switch(name)
	if self.current ~= name then
		if self.current then
			self.scenes[self.current]:on_exit()
		end
		self.current = name
		self.scenes[self.current]:on_enter()
	end
end

function SceneManager:update()
	self.scenes[self.current]:update()
end

function SceneManager:draw()
	self.scenes[self.current]:draw()
end

return SceneManager
