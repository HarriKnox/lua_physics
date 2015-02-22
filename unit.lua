local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta
local common = require('common')
local quntypes = {'quantity', 'unit', 'number'}


unit.new = function(parkg, parm, pars, para, park, parmol, parcd)
	if type(parkg) == 'number' and type(parm) == 'number' and type(pars) == 'number' and type(para) == 'number' and type(park) == 'number' and type(parmol) == 'number' and type(parcd) == 'number' then
		return setmetatable({kilogram = parkg, meter = parm, second = pars, ampere = para, kelvin = park, mole = parmol, candela = parcd}, unit_meta)
	end
	common.typeerror('creation', parkg, parm, pars, para, park, parmol, parcd, 'unit')
end

common.setcallmeta(unit)
common.registertype(unit_meta, 'unit')

unit.clone = function(un)
	if type(un) == 'unit' then
		local kg = un.kilogram
		local m = un.meter
		local s = un.second
		local a = un.ampere
		local k = un.kelvin
		local mol = un.mole
		local cd = un.candela
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	common.typeerror('cloning', un, 'unit')
end

unit.multiply = function(first, second)
	if common.checkvaluntype(first, second) then
		return require('vector').multiply(first, second)
	end
	common.typeerror('multiplication', first, second, 'unit')
end

unit.divide = function(first, second)
	if common.checkvaluntype(first, second) and type(second) ~= 'vector' then
		return require('vector').divide(first, second)
	end
	common.typeerror('division', first, second, 'unit')
end

unit.intdivide = function(first, second)
	if common.checkvaluntype(first, second) and type(second) ~= 'vector' then
		return require('vector').intdivide(first, second)
	end
	common.typeerror('division', first, second, 'quantity')
end

unit.power = function(unt, num)
	if type(unt) == 'unit' and type(num) == 'number' then
		local kg = unt.kilogram * num
		local m = unt.meter * num
		local s = unt.second * num
		local a = unt.ampere * num
		local k = unt.kelvin * num
		local mol = unt.mole * num
		local cd = unt.candela * num
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	common.typeerror('power', unt, num, 'unit')
end

unit.equals = function(first, second)
	if type(first) == 'unit' and type(second) == 'unit' then
		local kg = first.kilogram == second.kilogram
		local m = first.meter == second.meter
		local s = first.second == second.second
		local a = first.ampere == second.ampere
		local k = first.kelvin == second.kelvin
		local mol = first.mole == second.mole
		local cd = first.candela == second.candela
		return kg and m and s and a and k and mol and cd
	end
	return false
end

unit.isempty = function(unt)
	if type(unt) == 'unit' then
		local kg = unt.kilogram == 0
		local m = unt.meter == 0
		local s = unt.second == 0
		local a = unt.ampere == 0
		local k = unt.kelvin == 0
		local mol = unt.mole == 0
		local cd = unt.candela == 0
		return kg and m and s and a and k and mol and cd
	end
	common.typeerror('empty check', unt, 'unit')
end

unit.tostring = function(unt, sci)
	if type(unt) == 'unit' then
		local numerator = {}
		local denominator = {}
		local units = {
			{x = unt.kilogram, str = 'kg'},
			{x = unt.meter, str = 'm'},
			{x = unt.second, str = 's'},
			{x = unt.ampere, str = 'A'},
			{x = unt.kelvin, str = 'K'},
			{x = unt.mole, str = 'mol'},
			{x = unt.candela, str = 'cd'}
		}
		for _, unt in pairs(units) do
			if unt.x > 0 or (sci and unt.x ~= 0) then
				local num = unt.str
				if unt.x ~= 1 then
					num = num .. '^' .. tostring(unt.x)
				end
				table.insert(numerator, num)
			elseif unt.x < 0 then
				local den = unt.str
				if unt.x ~= -1 then
					den = den .. '^' .. tostring(-unt.x)
				end
				table.insert(denominator, den)
			end
		end
		if #numerator == 0 then
			if #denominator == 0 then
				return ''
			end
			table.insert(numerator, '1')
		end
		local str = table.concat(numerator, ' ')
		if #denominator > 0 then
			return str .. " / " .. table.concat(denominator, ' ')
		end
		return str
	end
	common.typeerror('string representation', unt, 'unit')
end


common.getmethods(unit, unit_meta)

unit_meta.__mul = unit.multiply
unit_meta.__div = unit.divide
unit_meta.__idiv = unit.intdivide
unit_meta.__pow = unit.power
unit_meta.__eq = unit.equals
unit_meta.__tostring = unit.tostring

unit_meta.__add = common.notsupported('units', 'addition')
unit_meta.__sub = common.notsupported('units', 'subtraction')
unit_meta.__unm = common.notsupported('units', 'unary-minus')
unit_meta.__len = common.notsupported('units', 'length')
unit_meta.__mod = common.notsupported('units', 'modulo')
unit_meta.__concat = common.notsupported('units', 'concatination')
unit_meta.__lt = common.notsupported('units', 'less-than')
unit_meta.__le = common.notsupported('units', 'less-than-or-equal-to')
unit_meta.__band = common.notsupported('units', 'bitwise')
unit_meta.__bor = unit_meta.__band
unit_meta.__bxor = unit_meta.__band
unit_meta.__bnot = unit_meta.__band
unit_meta.__shl = unit_meta.__band
unit_meta.__shr = unit_meta.__band


return unit
