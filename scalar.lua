local scalar = {}
local scalar_meta = {}
scalar_meta.__index = scalar_meta

local common = require('common')
local unit = require('unit')


scalar.new = function(parvalue, parunits)
	if type(parvalue) == 'number' and type(parunits) == 'unit' then
		if unit.isempty(parunits) then
			return parvalue
		end
		return setmetatable({value = parvalue, units = parunits}, scalar_meta)
	end
	common.typeerror('creation', parvalue, parunits, 'scalar')
end

common.setcallmeta(scalar)

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

scalar.multiply = function(first, second)
	if scalar.isscalar(first) and scalar.isscalar(second) then
		local value = first:getvalue() * second:getvalue()
		local units = first:getunits() * second:getunits()
		return scalar.new(value, units)
	end
	if scalar.isscalar(first) and type(second) == 'number' then
		local value = first:getvalue() * second
		local units = first:getunits()
		return scalar.new(value, units)
	end
	if scalar.isscalar(second) and type(first) == 'number' then
		local value = second:getvalue() * first
		local units = second:getunits()
		return scalar.new(value, units)
	end
	common.typeerror('multiplication', first, second, 'scalar')
end

scalar.divide = function(first, second)
	if scalar.isscalar(first) and scalar.isscalar(second) then
		local value = first:getvalue() / second:getvalue()
		local units = first:getunits() / second:getunits()
		return scalar.new(value, units)
	end
	if scalar.isscalar(first) and type(second) == 'number' then
		local value = first:getvalue() / second
		local units = first:getunits()
		return scalar.new(value, units)
	end
	if scalar.isscalar(second) and type(first) == 'number' then
		local value = first / second:getvalue()
		local units = second:getunits() ^ -1
		return scalar.new(value, units)
	end
	common.typeerror('division', first, second, 'scalar')
end

scalar.equals = function(first, second)
	if scalar.isscalar(first) and scalar.isscalar(second) then
		local value = first:getvalue() == second:getvalue()
		local units = first:getunits() == second:getunits()
		return value and units
	end
	common.typeerror('equation', first, second, 'scalar')
end


common.getmethods(scalar, scalar_meta)

scalar_meta.__eq = scalar.equals
scalar_meta.__mul = scalar.multiply
scalar_meta.__div = scalar.divide

scalar_meta.__add = common.notsupported('scalars', 'addition')
scalar_meta.__sub = common.notsupported('scalars', 'subtraction')
scalar_meta.__unm = common.notsupported('scalars', 'unary-minus')
scalar_meta.__idiv = common.notsupported('scalars', 'int-division')
scalar_meta.__len = common.notsupported('scalars', 'length')
scalar_meta.__mod = common.notsupported('scalars', 'modulo')
scalar_meta.__pow = common.notsupported('scalars', 'powers')
scalar_meta.__concat = common.notsupported('scalars', 'concatination')
scalar_meta.__lt = common.notsupported('scalars', 'less-than')
scalar_meta.__le = common.notsupported('scalars', 'less-than-or-equal-to')
scalar_meta.__band = common.notsupported('scalars', 'bitwise')
scalar_meta.__bor = scalar_meta.__band
scalar_meta.__bxor = scalar_meta.__band
scalar_meta.__bnot = scalar_meta.__band
scalar_meta.__shl = scalar_meta.__band
scalar_meta.__shr = scalar_meta.__band

scalar_meta.__tostring = function(this)
	local units = tostring(this:getunits())
	return string.format("%g%s", this:getvalue(), #units > 0 and ' ' .. units or '')
end

scalar_meta.getvalue = function(this) return this.value end
scalar_meta.getunits = function(this) return this.units end

scalar_meta.setvalue = function(this, num) this.value = num end
scalar_meta.setunits = function(this, unt) this.units = unt end

return scalar