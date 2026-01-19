-- world --
-- ECS World: manages entities and systems

local World = {}

-- Create a new World instance
function World.New()
	return {
		entities = {}, -- Array of all entities
		systems = {}, -- Array of systems with their update/draw functions
		nextEntityId = 1, -- Auto-incrementing entity ID
	}
end

-- Add an entity to the world
-- @param world World instance
-- @param entity Entity to add
-- @return Entity ID
function World.AddEntity(world, entity)
	local id = world.nextEntityId
	world.nextEntityId = world.nextEntityId + 1
	entity.id = id
	table.insert(world.entities, entity)
	return id
end

-- Remove an entity from the world
-- @param world World instance
-- @param entityId Entity ID to remove
function World.RemoveEntity(world, entityId)
	for i, entity in ipairs(world.entities) do
		if entity.id == entityId then
			table.remove(world.entities, i)
			return
		end
	end
end

-- Query entities that have all specified components
-- @param world World instance
-- @param componentNames Array of component names to check for
-- @return Array of entities that have all specified components
function World.Query(world, componentNames)
	local results = {}

	for _, entity in ipairs(world.entities) do
		local hasAll = true
		for _, componentName in ipairs(componentNames) do
			if entity[componentName] == nil then
				hasAll = false
				break
			end
		end
		if hasAll then
			table.insert(results, entity)
		end
	end

	return results
end

-- Register a system with the world
-- @param world World instance
-- @param system System object with optional Update and Draw functions
function World.AddSystem(world, system)
	table.insert(world.systems, system)
end

-- Update all systems in the world
-- @param world World instance
function World.Update(world)
	for _, system in ipairs(world.systems) do
		if system.Update then
			system.Update(world)
		end
	end
end

-- Draw all systems in the world
-- @param world World instance
function World.Draw(world)
	for _, system in ipairs(world.systems) do
		if system.Draw then
			system.Draw(world)
		end
	end
end

-- Get all entities in the world
-- @param world World instance
-- @return Array of all entities
function World.GetEntities(world)
	return world.entities
end

-- Get entity by ID
-- @param world World instance
-- @param entityId Entity ID
-- @return Entity or nil
function World.GetEntity(world, entityId)
	for _, entity in ipairs(world.entities) do
		if entity.id == entityId then
			return entity
		end
	end
	return nil
end

return World
