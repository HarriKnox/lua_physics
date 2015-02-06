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

scalar.isscalar = function(sca)
	return getmetatable(sca) == scalar_meta
end
common.registertype(scalar.isscalar, 'scalar')

scalar.clone = function(sca)
	if scalar.isscalar(sca) then
		local value = sca:getvalue()
		local units = sca:getunits()
		return scalar.new(value, units)
	end
	common.typeerror('cloning', sca, 'scalar')
end

scalar.equals = function(first, second)
	if scalar.isscalar(first) and scalar.isscalar(second) then
		local value = first:getvalue() == second:getvalue()
		local units = first:getunits() == second:getunits()
		return value and units
	end
	common.typeerror('equation', first, second, 'scalar')
end

return scalar