local scalar = {}
local scalar_meta = {}
scalar_meta.__index = scalar_meta

local common = require('common')


scalar.new = function(parvalue, parunits)
	if type(parvalue) == 'number' and type(parunits) == 'unit' then
		return setmetatable({value = parvalue, units = parunits}, scalar_meta)
	end
	common.typeerror('creation', parvalue, parunits, 'scalar')
end

common.setmetacall(scalar)

scalar.isscalar = function(sclr)
	return getmetatable(sclr) == scalar_meta
end
common.registertype(scalar.isscalar, 'scalar')


return scalar