local system = {}
local system_meta = {}
system_meta.__index = system_meta
local common = require('common')

system.new = function()
	return setmetatable({objects = {}}, system_meta)
end

common.setcallmeta(system)
common.registertype(system_meta, 'system')

local particleequals = function(first, second)
	return first.charge.value == second.charge.value and
			first.mass.value == second.mass.value and
			first.position.x == second.position.x and
			first.position.y == second.position.y and
			first.position.z == second.position.z
end

local particlepositionequals = function(first, second)
	return first.position.x == second.position.x and
			first.position.y == second.position.y and
			first.position.z == second.position.z
end

system.addparticle = function(sys, part)
	if type(sys) == 'system' and type(part) == 'particle' then
		if type(part.position) == 'vector' then
			if not common.intable(part, sys.objects, particlepositionequals) then
				table.insert(sys.objects, part)
				return sys
			end
			error("particle already exists at that location system")
		end
		error("cannot add particle with 1D position to 3D system (at least not yet)")
	end
	common.typeerror('particle addition', sys, part, 'system')
end

system.removeparticle = function(sys, part)
	if type(sys) == 'system' and type(part) == 'particle' then
		local i = common.intable(part, sys.objects, particleequals)
		if i then
			table.remove(sys.objects, i)
			return sys
		end
		error("particle doesn't exist in system")
	end
	common.typeerror('particle removal', sys, part, 'system')
end

system.forcesactingon = function(sys, part)
	if type(sys) == 'system' and type(part) == 'particle' then
		local index = common.intable(part, sys.objects, particleequals)
		if index then
			local forces = require('vector').new(0, 0, 0, require('units').newton)
			for i, p in pairs(sys.objects) do
				if i ~= index then
					forces = forces + part:forcebetween(p)
				end
			end
			return forces
		end
		error("particle doesn't exist in system")
	end
	common.typeerror('force calculation', sys, part, 'system')
end

system.electricfield = function(sys, loc)
	if type(sys) == 'system'  and type(loc) == 'vector' then
		local units = require('units')
		if loc.units == units.meter then
			local efield = require('vector').new(0, 0, 0, units.newton / units.coulomb)
			for i, p in pairs(sys.objects) do
				efield = efield + p:electricfield(loc)
			end
			return efield
		end
		common.uniterror('electric field', loc.units, 'system')
	end
	common.typeerror('electric field', loc, 'system')
end

system.tostring = function(sys)
	return string.format("System with %d particles", #sys.objects)
end

common.getmethods(system, system_meta)

system_meta.__tostring = system.tostring

system_meta.__add = common.notsupported('systems', 'addition')
system_meta.__sub = common.notsupported('systems', 'subtraction')
system_meta.__mul = common.notsupported('systems', 'multiplication')
system_meta.__div = common.notsupported('systems', 'division')
system_meta.__unm = common.notsupported('systems', 'unary-minus')
system_meta.__idiv = common.notsupported('systems', 'int-division')
system_meta.__pow = common.notsupported('systems', 'power')
system_meta.__eq = common.notsupported('systems', 'equals')
system_meta.__len = common.notsupported('systems', 'length')
system_meta.__mod = common.notsupported('systems', 'modulo')
system_meta.__concat = common.notsupported('systems', 'concatination')
system_meta.__lt = common.notsupported('systems', 'less-than')
system_meta.__le = common.notsupported('systems', 'less-than-or-equal-to')
system_meta.__band = common.notsupported('systems', 'bitwise')
system_meta.__bor = system_meta.__band
system_meta.__bxor = system_meta.__band
system_meta.__bnot = system_meta.__band
system_meta.__shl = system_meta.__band
system_meta.__shr = system_meta.__band

return system
