local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta
local common = require('common')
local suntypes = {'scalar', 'unit', 'number'}


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
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local firstvalue = 1
		local firstkg = 0
		local firstm = 0
		local firsts = 0
		local firsta = 0
		local firstk = 0
		local firstmol = 0
		local firstcd = 0
		if type(first) == 'scalar' then
			firstvalue = first.value
			local units = first.units
			firstkg = units.kilogram
			firstm = units.meter
			firsts = units.second
			firsta = units.ampere
			firstk = units.kelvin
			firstmol = units.mole
			firstcd = units.candela
		elseif type(first) == 'unit' then
			firstkg = first.kilogram
			firstm = first.meter
			firsts = first.second
			firsta = first.ampere
			firstk = first.kelvin
			firstmol = first.mole
			firstcd = first.candela
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondkg = 0
		local secondm = 0
		local seconds = 0
		local seconda = 0
		local secondk = 0
		local secondmol = 0
		local secondcd = 0
		if type(second) == 'scalar' then
			secondvalue = second.value
			local units = second.units
			secondkg = units.kilogram
			secondm = units.meter
			seconds = units.second
			seconda = units.ampere
			secondk = units.kelvin
			secondmol = units.mole
			secondcd = units.candela
		elseif type(second) == 'unit' then
			secondkg = second.kilogram
			secondm = second.meter
			seconds = second.second
			seconda = second.ampere
			secondk = second.kelvin
			secondmol = second.mole
			secondcd = second.candela
		else
			secondvalue = second
		end
		local value = firstvalue * secondvalue
		local kg = firstkg + secondkg
		local m = firstm + secondm
		local s = firsts + seconds
		local a = firsta + seconda
		local k = firstk + secondk
		local mol = firstmol + secondmol
		local cd = firstcd + secondcd
		local unt = unit.new(kg, m, s, a, k, mol, cd)
		if (type(unt) == 'unit' and unt:isempty()) or type(unt) == 'number' then
			return value
		elseif value == 1 then
			return unt
		end
		return require('scalar').new(value, unt)
	end
	common.typeerror('multiplication', first, second, 'unit')
end

unit.divide = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local firstvalue = 1
		local firstkg = 0
		local firstm = 0
		local firsts = 0
		local firsta = 0
		local firstk = 0
		local firstmol = 0
		local firstcd = 0
		if type(first) == 'scalar' then
			firstvalue = first.value
			local units = first.units
			firstkg = units.kilogram
			firstm = units.meter
			firsts = units.second
			firsta = units.ampere
			firstk = units.kelvin
			firstmol = units.mole
			firstcd = units.candela
		elseif type(first) == 'unit' then
			firstkg = first.kilogram
			firstm = first.meter
			firsts = first.second
			firsta = first.ampere
			firstk = first.kelvin
			firstmol = first.mole
			firstcd = first.candela
		else
			firstvalue = first
		end
		local secondvalue = 1
		local secondkg = 0
		local secondm = 0
		local seconds = 0
		local seconda = 0
		local secondk = 0
		local secondmol = 0
		local secondcd = 0
		if type(second) == 'scalar' then
			secondvalue = second.value
			local units = second.units
			secondkg = units.kilogram
			secondm = units.meter
			seconds = units.second
			seconda = units.ampere
			secondk = units.kelvin
			secondmol = units.mole
			secondcd = units.candela
		elseif type(second) == 'unit' then
			secondkg = second.kilogram
			secondm = second.meter
			seconds = second.second
			seconda = second.ampere
			secondk = second.kelvin
			secondmol = second.mole
			secondcd = second.candela
		else
			secondvalue = second
		end
		local value = firstvalue / secondvalue
		local kg = firstkg - secondkg
		local m = firstm - secondm
		local s = firsts - seconds
		local a = firsta - seconda
		local k = firstk - secondk
		local mol = firstmol - secondmol
		local cd = firstcd - secondcd
		local unt = unit.new(kg, m, s, a, k, mol, cd)
		if (type(unt) == 'units' and unt:isempty()) or type(unt) == 'number' then
			return value
		elseif value == 1 then
			return unt
		end
		return require('scalar').new(value, unt)
	end
	common.typeerror('division', first, second, 'unit')
end

unit.intdivide = function(first, second)
	if common.istype(first, suntypes) and common.istype(second, suntypes) then
		local unt = unit.divide(first, second)
		if type(unt) == 'scalar' then
			unt.value = math.floor(unt.value)
		elseif type(unt) == 'number' then
			unt = math.floor(unt)
		end
		return unt
	end
	common.typeerror('division', first, second, 'scalar')
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
