local scalar = {}
local scalar_meta = {}
scalar_meta.__index = scalar_meta
local common = require('common')
local suntypes = {'scalar', 'unit', 'number'}


scalar.new = function(parvalue, parunits)
	if type(parvalue) == 'number' and type(parunits) == 'unit' then
		return setmetatable({value = parvalue, units = parunits:clone()}, scalar_meta)
	end
	common.typeerror('creation', parvalue, parunits, 'scalar')
end

common.setcallmeta(scalar)
common.registertype(scalar_meta, 'scalar')

scalar.clone = function(sca)
	if type(sca) == 'scalar' then
		local value = sca.value
		local units = sca.units
		return scalar.new(value, units)
	end
	common.typeerror('cloning', sca, 'scalar')
end

scalar.multiply = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local units = require('units')
		local firstvalue = 1
		local firstunits = units.empty
		if type(first) == 'scalar' then
			firstvalue = first.value
			firstunits = first.units
		elseif type(first) == 'unit' then
			firstunits = first
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondunits = units.empty
		if type(second) == 'scalar' then
			secondvalue = second.value
			secondunits = second.units
		elseif type(second) == 'unit' then
			secondunits = second
		else
			secondvalue = second
		end
		local value = firstvalue * secondvalue
		local units = firstunits * secondunits
		if units:isempty() then
			return value
		elseif value == 1 then
			return units
		end
		return scalar.new(firstvalue, secondvalue)
	end
	common.typeerror('multiplication', first, second, 'scalar')
end

scalar.divide = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local units = require('units')
		local firstvalue = 1
		local firstunits = units.empty
		if type(first) == 'scalar' then
			firstvalue = first.value
			firstunits = first.units
		elseif type(first) == 'unit' then
			firstunits = first
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondunits = units.empty
		if type(second) == 'scalar' then
			secondvalue = second.value
			secondunits = second.units
		elseif type(second) == 'unit' then
			secondunits = second
		else
			secondvalue = second
		end
		local value = firstvalue / secondvalue
		local units = firstunits / secondunits
		if units:isempty() then
			return value
		elseif value == 1 then
			return units
		end
		return scalar.new(value, units)
	end
	common.typeerror('division', first, second, 'scalar')
end

scalar.intdivide = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local sca = scalar.divide(first, second)
		if type(sca) == 'scalar' then
			sca.value = math.floor(sca.value)
		elseif type(sca) == 'number' then
			sca = math.floor(sca)
		end
		return sca
	end
	common.typeerror('division', first, second, 'scalar')
end

scalar.equals = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local units = require('units')
		local firstvalue = 1
		local firstunits = units.empty
		if type(first) == 'scalar' then
			firstvalue = first.value
			firstunits = first.units
		elseif type(first) == 'unit' then
			firstunits = first
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondunits = units.empty
		if type(second) == 'scalar' then
			secondvalue = second.value
			secondunits = second.units
		elseif type(second) == 'unit' then
			secondunits = second
		else
			secondvalue = second
		end
		local value = firstvalue == secondvalue
		local units = firstunits == secondunits
		return value and units
	end
	return false
end


common.getmethods(scalar, scalar_meta)

scalar_meta.__eq = scalar.equals
scalar_meta.__mul = scalar.multiply
scalar_meta.__div = scalar.divide
scalar_meta.__idiv = scalar.intdivide

scalar_meta.__add = common.notsupported('scalars', 'addition')
scalar_meta.__sub = common.notsupported('scalars', 'subtraction')
scalar_meta.__unm = common.notsupported('scalars', 'unary-minus')
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
	local units = tostring(this.units)
	return string.format("%g%s", this.value, #units > 0 and ' ' .. units or '')
end

return scalar