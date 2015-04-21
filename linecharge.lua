local linecharge = {}
local linecharge_meta = {}
linecharge_meta.__index = linecharge_meta
local common = require('common')

linecharge.new = function(parc, parm, parp, pard)
	local units = require('units')
	if type(parc) == 'quantity' and parc.units == units.coulomb type(parm) == 'quantity' and parm.units == units.kilogram and type(parp) == 'vector' and parp.units == units.meter and type(pard) == 'vector' and pard.units == units.meter then
		return setmetatable({charge = parc, mass = parm, point = parp, direction = pard}, linecharge_meta)
	end
	common.typeerror('creation', parc, parm, parp, pard, 'linecharge')
end
