local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local common = require('common')


unit.new = function(parkg, parm, pars, para, park, parmol, parcd)
	if type(parkg) == 'number' and type(parm) == 'number' and type(pars) == 'number' and type(para) == 'number' and type(park) == 'number' and type(parmol) == 'number' and type(parcd) == 'number' then
		return setmetatable({kilogram = parkg, meter = parm, second = pars, ampere = para, kelvin = park, mole = parmol, candela = parcd}, unit_meta)
	end
	common.typeerror('unit', 'creation', type(parkg), type(parm), type(pars), type(para), type(park), type(parmol), type(parcd))
end

setmetatable(unit, common.getcall(unit.new))

unit.isunit = function(un)
	return getmetatable(un) == unit_meta
end
common.registertype(unit.isunit, 'unit')

return unit