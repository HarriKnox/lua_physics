local quantity = {}
local quantity_meta = {}
quantity_meta.__index = quantity_meta
local common = require('common')


quantity.new = function(parvalue, parunits)
	if type(parvalue) == 'number' and common.istype(parunits, {'unit', 'nil'}) then
		return setmetatable({value = parvalue, units = (type(parunits) == 'unit' and parunits:clone() or require('units').empty)}, quantity_meta)
	end
	common.typeerror('creation', parvalue, parunits, 'quantity')
end

common.setcallmeta(quantity)
common.registertype(quantity_meta, 'quantity')

quantity.clone = function(qua)
	if type(qua) == 'quantity' then
		local value = qua.value
		local units = qua.units
		return quantity.new(value, units)
	end
	common.typeerror('cloning', qua, 'quantity')
end

quantity.add = function(first, second)
	if common.isquntype(first) and common.isquntype(second) then
		local firstunits = common.getunits(first)
		local secondunits = common.getunits(second)
		if firstunits == secondunits then
			local units = require('units')
			local firstvalue = 1
			if type(first) == 'quantity' then
				firstvalue = first.value
			else
				firstvalue = first
			end
			local secondvalue = 1
			if type(second) == 'quantity' then
				secondvalue = second.value
			else
				secondvalue = second
			end
			local value = firstvalue + secondvalue
			if (type(firstunits) == 'unit' and firstunits:isempty()) or type(firstunits) == 'number' then
				return value
			end
			return quantity.new(value, firstunits)
		end
		common.uniterror('addition', firstunits, secondunits, 'quantity')
	end
	common.typeerror('addition', first, second, 'quantity')
end

quantity.subtract = function(first, second)
	if common.isquntype(first) and common.isquntype(second) then
		local firstunits = common.getunits(first)
		local secondunits = common.getunits(second)
		if firstunits == secondunits then
			local units = require('units')
			local firstvalue = 1
			if type(first) == 'quantity' then
				firstvalue = first.value
			else
				firstvalue = first
			end
			local secondvalue = 1
			if type(second) == 'quantity' then
				secondvalue = second.value
			else
				secondvalue = second
			end
			local value = firstvalue - secondvalue
			if (type(firstunits) == 'unit' and firstunits:isempty()) or type(firstunits) == 'number' then
				return value
			end
			return quantity.new(value, firstunits)
		end
		common.uniterror('addition', firstunits, secondunits, 'quantity')
	end
	common.typeerror('subtraction', first, second, 'quantity')
end

quantity.multiply = function(first, second)
	if common.checkvaluntypes(first, second) then
		return require('vector').multiply(first, second)
	end
	common.typeerror('multiplication', first, second, 'quantity')
end

quantity.divide = function(first, second)
	if common.checkvaluntypes(first, second) and type(second) ~= 'vector' then
		return require('vector').divide(first, second)
	end
	common.typeerror('division', first, second, 'quantity')
end

quantity.intdivide = function(first, second)
	if common.checkvaluntypes(first, second) and type(second) ~= 'vector' then
		return require('vector').intdivide(first, second)
	end
	common.typeerror('division', first, second, 'quantity')
end

quantity.negate = function(qua)
	if type(qua) == 'quantity' then
		return quantity.new(-qua.value, qua.units)
	end
	common.typeerror('negation', qua, 'quantity')
end

quantity.power = function(qua, num)
	if type(qua) == 'quantity' and type(num) == 'number' then
		local value = qua.value ^ num
		local units = qua.units ^ num
		return quantity.new(value, units)
	end
	common.typeerror('power', qua, num, 'quantity')
end

quantity.equals = function(first, second)
	if common.isquntype(first) and common.isquntype(second) then
		local units = require('units')
		local firstvalue = 1
		local firstunits = units.empty
		if type(first) == 'quantity' then
			firstvalue = first.value
			firstunits = first.units
		elseif type(first) == 'unit' then
			firstunits = first
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondunits = units.empty
		if type(second) == 'quantity' then
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

quantity.lessthan = function(first, second)
	if type(first) == 'quantity' and type(second) == 'quantity' then
		if first.units == second.units then
			return first.value < second.value
		end
		common.uniterror('less-than', first.units, second.units, 'units')
	end
	common.typeerror('less-than', first, second, 'units')
end

quantity.lessthanorequalto = function(first, second)
	if type(first) == 'quantity' and type(second) == 'quantity' then
		if first.units == second.units then
			return first.value <= second.value
		end
		common.uniterror('less-than', first.units, second.units, 'units')
	end
	common.typeerror('less-than', first, second, 'units')
end

quantity.tostring = function(qua, sci)
	return string.format("%g%s", qua.value, qua.units:isempty() and '' or ' ' .. qua.units:tostring(sci))
end


common.getmethods(quantity, quantity_meta)

quantity_meta.__add = quantity.add
quantity_meta.__sub = quantity.subtract
quantity_meta.__unm = quantity.negate
quantity_meta.__pow = quantity.power
quantity_meta.__eq = quantity.equals
quantity_meta.__mul = quantity.multiply
quantity_meta.__div = quantity.divide
quantity_meta.__idiv = quantity.intdivide
quantity_meta.__tostring = quantity.tostring
quantity_meta.__lt = quantity.lessthan
quantity_meta.__le = quantity.lessthanorequalto

quantity_meta.__len = common.notsupported('quantities', 'length')
quantity_meta.__mod = common.notsupported('quantities', 'modulo')
quantity_meta.__concat = common.notsupported('quantities', 'concatination')
quantity_meta.__band = common.notsupported('quantities', 'bitwise')
quantity_meta.__bor = quantity_meta.__band
quantity_meta.__bxor = quantity_meta.__band
quantity_meta.__bnot = quantity_meta.__band
quantity_meta.__shl = quantity_meta.__band
quantity_meta.__shr = quantity_meta.__band


return quantity
