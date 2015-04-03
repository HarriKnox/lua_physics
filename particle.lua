local particle = {}
local particle_meta = {}
particle_meta.__index = particle_meta
local common = require('common')


particle.new = function(parm, parp)
	local units = require('units')
	if type(parm) == 'scalar' and parm.units == units.kilogram and common.istype(parp, {'scalar', 'vector'}) and parp.units == units.meter then
		return setmetatable({mass = parm, position = parp}, particle_meta)
	end
	common.typeerror('creation', parm, parp, 'particle')
end

common.setcallmeta(particle)
common.registertype(particle_meta, 'particle')

particle.clone = function(part)
	if type(part) == 'particle' then
		local mass = part.mass
		local position = part.position
		return particle.new(mass, position)
	end
	common.typeerror('cloning', part, 'particle')
end
