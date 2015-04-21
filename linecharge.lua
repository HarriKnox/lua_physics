local linecharge = {}
local linecharge_meta = {}
linecharge_meta.__index = linecharge_meta
local common = require('common')

linecharge.new = function(parc, parm, parp, pard)
	local units = require('units')
	if type(parc) == 'quantity' and type(parm) == 'quantity' and type(parp) == 'vector' and type(pard) == 'vector' then
		if parc.units == units.coulomb and parm.units == units.kilogram and parp.units == units.meter and pard.units == units.meter then
			return setmetatable({charge = parc, mass = parm, point = parp, direction = pard}, linecharge_meta)
		end
		common.uniterror('creation', parc.units, parm.units, parp.units, pard.units, 'linecharge')
	end
	common.typeerror('creation', parc, parm, parp, pard, 'linecharge')
end
