local linecharge = {}
local linecharge_meta = {}
linecharge_meta.__index = linecharge_meta
local common = require('common')

linecharge.new = function(parc, parm, parp, pard)
	if type(parc) == 'quantity' and type(parm) == 'quantity' and type(parp) == 'vector' and type(pard) == 'vector' then
		local units = require('units')
		if parc.units == units.coulomb and parm.units == units.kilogram and parp.units == units.meter and pard.units == units.meter then
			return setmetatable({charge = parc, mass = parm, point = parp, direction = pard}, linecharge_meta)
		end
		common.uniterror('creation', parc.units, parm.units, parp.units, pard.units, 'linecharge')
	end
	common.typeerror('creation', parc, parm, parp, pard, 'linecharge')
end

common.setcallmeta(linecharge)
common.registertype(linecharge_meta, 'linecharge')

linecharge.equals = function(first, second)
	if common.alloftype(first, second, {'linecharge'}) then
		local charge = first.charge == second.charge
		local mass = first.mass == second.mass
		local position = first.point == second.point
		local direction = first.direction == second.direction
		return charge and mass and point and direction
	end
	return false
end

linecharge.tostring = function(part, comp)
	return string.format("(%s) (%s) %s pointing %s", part.mass:tostring(), part.charge:tostring(), part.point:tostring(comp), part.direcction:tostring(comp))
end
