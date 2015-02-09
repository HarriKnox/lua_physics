local scalar = {}
local scalar_meta = {}
scalar_meta.__index = scalar_meta
local common = require('common')


scalar.new = function(parvalue, parunits)
	if type(parvalue) == 'number' and type(parunits) == 'unit' then
		if parunits:isempty() then
			return parvalue
		end
		return setmetatable({value = parvalue, units = parunits}, scalar_meta)
	end
	common.typeerror('creation', parvalue, parunits, 'scalar')
end

common.setcallmeta(scalar)
common.registertype(scalar_meta, 'scalar')

scalar.clone = function(sca)
	if type(sca) == 'scalar' then
		local value = sca:getvalue()
		local units = sca:getunits()
		return scalar.new(value, units)
	end
	common.typeerror('cloning', sca, 'scalar')
end

scalar.multiply = function(first, second)
	if common.istype(first, {"scalar", "unit", "number"}) and common.istype(second, {"scalar", "unit", "number"}) then
		local firstvalue = 1
		local firstunits = units.new(0, 0, 0, 0, 0, 0, 0)
		if type(first) == 'scalar' then
			firstvalue = first:getvalue()
			firstunits = first:getunits()
		elseif type(first) == 'unit' then
			firstunits = first
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondunits = units.new(0, 0, 0, 0, 0, 0, 0)
		if type(second) == 'scalar' then
			secondvalue = second:getvalue()
			secondunits = second:getunits()
		elseif type(second) == 'unit' then
			secondunits = second
		else
			secondvalue = second
		end
		local value = firstvalue * secondvalue
		local units = firstunits * secondunits
		return scalar.new(firstvalue, secondvalue)
	end
	common.typeerror('multiplication', first, second, 'scalar')
end

scalar.divide = function(first, second)
	if type(first) == 'scalar' and type(second) == 'scalar' then
		local value = first:getvalue() / second:getvalue()
		local units = first:getunits() / second:getunits()
		return scalar.new(value, units)
	end
	if type(first) == 'scalar' and type(second) == 'number' then
		local value = first:getvalue() / second
		local units = first:getunits()
		return scalar.new(value, units)
	end
	if type(second) == 'scalar' and type(first) == 'number' then
		local value = first / second:getvalue()
		local units = second:getunits() ^ -1
		return scalar.new(value, units)
	end
	common.typeerror('division', first, second, 'scalar')
end

scalar.equals = function(first, second)
	if type(first) == 'scalar' and type(second) == 'scalar' then
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