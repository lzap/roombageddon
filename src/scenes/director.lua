-- director --

local Director = {}

function Director.New()
	return {
		scenes = {},
		handlers = {},
		current = nil,
	}
end

function Director.Add(sm, name, sceneData, handlers)
	sm.scenes[name] = sceneData
	sm.handlers[name] = handlers
end

function Director.Switch(sm, name)
	if sm.current ~= name then
		if sm.current and sm.handlers[sm.current] and sm.handlers[sm.current].onExit then
			sm.handlers[sm.current].onExit(sm.scenes[sm.current])
		end
		sm.current = name
		if sm.handlers[name] and sm.handlers[name].onEnter then
			sm.handlers[name].onEnter(sm.scenes[name])
		end
	end
end

function Director.Update(sm)
	if sm.current and sm.scenes[sm.current] and sm.handlers[sm.current] and sm.handlers[sm.current].update then
		sm.handlers[sm.current].update(sm.scenes[sm.current])
	end
end

function Director.Draw(sm)
	if sm.current and sm.scenes[sm.current] and sm.handlers[sm.current] and sm.handlers[sm.current].draw then
		sm.handlers[sm.current].draw(sm.scenes[sm.current])
	end
end

return Director
