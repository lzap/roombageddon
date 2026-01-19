-- director --

local Director = {}

function Director.New()
	return {
		scenes = {},
		handlers = {},
		current = nil,
	}
end

function Director.Add(d, name, sceneData, handlers)
	d.scenes[name] = sceneData
	d.handlers[name] = handlers
end

function Director.Switch(d, name)
	if d.current ~= name then
		if d.current and d.handlers[d.current] and d.handlers[d.current].onExit then
			d.handlers[d.current].onExit(d.scenes[d.current])
		end
		d.current = name
		if d.handlers[name] and d.handlers[name].onEnter then
			d.handlers[name].onEnter(d.scenes[name])
		end
	end
end

function Director.Update(d)
	if d.current and d.scenes[d.current] and d.handlers[d.current] and d.handlers[d.current].update then
		d.handlers[d.current].update(d.scenes[d.current])
	end
end

function Director.Draw(d)
	if d.current and d.scenes[d.current] and d.handlers[d.current] and d.handlers[d.current].draw then
		d.handlers[d.current].draw(d.scenes[d.current])
	end
end

return Director
