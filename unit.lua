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
		local kg = un:getkilogram()
		local m = un:getmeter()
		local s = un:getsecond()
		local a = un:getampere()
		local k = un:getkelvin()
		local mol = un:getmole()
		local cd = un:getcandela()
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
			firstvalue = first:getvalue()
			local units = first:getunits()
			firstkg = units:getkilogram()
			firstm = units:getmeter()
			firsts = units:getsecond()
			firsta = units:getampere()
			firstk = units:getkelvin()
			firstmol = units:getmole()
			firstcd = units:getcandela()
		elseif type(first) == 'unit' then
			firstkg = first:getkilogram()
			firstm = first:getmeter()
			firsts = first:getsecond()
			firsta = first:getampere()
			firstk = first:getkelvin()
			firstmol = first:getmole()
			firstcd = first:getcandela()
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
			secondvalue = second:getvalue()
			local units = second:getunits()
			secondkg = units:getkilogram()
			secondm = units:getmeter()
			seconds = units:getsecond()
			seconda = units:getampere()
			secondk = units:getkelvin()
			secondmol = units:getmole()
			secondcd = units:getcandela()
		elseif type(second) == 'unit' then
			secondkg = second:getkilogram()
			secondm = second:getmeter()
			seconds = second:getsecond()
			seconda = second:getampere()
			secondk = second:getkelvin()
			secondmol = second:getmole()
			secondcd = second:getcandela()
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
		if unt:isempty() then
			return value
		elseif value == 1 and type(first) ~= 'number' and type(second) ~= 'number' then
			return unt
		else
			return scalar.new(value, unt)
		end
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
			firstvalue = first:getvalue()
			local units = first:getunits()
			firstkg = units:getkilogram()
			firstm = units:getmeter()
			firsts = units:getsecond()
			firsta = units:getampere()
			firstk = units:getkelvin()
			firstmol = units:getmole()
			firstcd = units:getcandela()
		elseif type(first) == 'unit' then
			firstkg = first:getkilogram()
			firstm = first:getmeter()
			firsts = first:getsecond()
			firsta = first:getampere()
			firstk = first:getkelvin()
			firstmol = first:getmole()
			firstcd = first:getcandela()
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
			secondvalue = second:getvalue()
			local units = second:getunits()
			secondkg = units:getkilogram()
			secondm = units:getmeter()
			seconds = units:getsecond()
			seconda = units:getampere()
			secondk = units:getkelvin()
			secondmol = units:getmole()
			secondcd = units:getcandela()
		elseif type(second) == 'unit' then
			secondkg = second:getkilogram()
			secondm = second:getmeter()
			seconds = second:getsecond()
			seconda = second:getampere()
			secondk = second:getkelvin()
			secondmol = second:getmole()
			secondcd = second:getcandela()
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
		if unt:isempty() then
			return value
		elseif value == 1 and type(first) ~= 'number' and type(second) ~= 'number' then
			return unt
		else
			return scalar.new(value, unt)
		end
	end
	common.typeerror('division', first, second, 'unit')
end

unit.power = function(unt, num)
	if type(unt) == 'unit' and type(num) == 'number' then
		local kg = unt:getkilogram() * num
		local m = unt:getmeter() * num
		local s = unt:getsecond() * num
		local a = unt:getampere() * num
		local k = unt:getkelvin() * num
		local mol = unt:getmole() * num
		local cd = unt:getcandela() * num
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	common.typeerror('power', unt, num, 'unit')
end

unit.equals = function(first, second)
	if type(first) == 'unit' and type(second) == 'unit' then
		local kg = first:getkilogram() == second:getkilogram()
		local m = first:getmeter() == second:getmeter()
		local s = first:getsecond() == second:getsecond()
		local a = first:getampere() == second:getampere()
		local k = first:getkelvin() == second:getkelvin()
		local mol = first:getmole() == second:getmole()
		local cd = first:getcandela() == second:getcandela()
		return kg and m and s and a and k and mol and cd
	end
	return false
end

unit.isempty = function(unt)
	if type(unt) == 'unit' then
		local kg = unt:getkilogram() == 0
		local m = unt:getmeter() == 0
		local s = unt:getsecond() == 0
		local a = unt:getampere() == 0
		local k = unt:getkelvin() == 0
		local mol = unt:getmole() == 0
		local cd = unt:getcandela() == 0
		return kg and m and s and a and k and mol and cd
	end
	common.typeerror('empty check', unt, 'unit')
end


common.getmethods(unit, unit_meta)

unit_meta.__mul = unit.multiply
unit_meta.__div = unit.divide
unit_meta.__pow = unit.power
unit_meta.__eq = unit.equals

unit_meta.__add = common.notsupported('units', 'addition')
unit_meta.__sub = common.notsupported('units', 'subtraction')
unit_meta.__unm = common.notsupported('units', 'unary-minus')
unit_meta.__idiv = common.notsupported('units', 'int-division')
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

unit_meta.__tostring = function(this)
	local numerator = {}
	local denominator = {}
	local units = {
		{x = this:getkilogram(), str = 'kg'},
		{x = this:getmeter(), str = 'm'},
		{x = this:getsecond(), str = 's'},
		{x = this:getampere(), str = 'A'},
		{x = this:getkelvin(), str = 'K'},
		{x = this:getmole(), str = 'mol'},
		{x = this:getcandela(), str = 'cd'}
	}
	for _, unt in pairs(units) do
		if unt.x > 0 then
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

unit_meta.getkilogram = function(this) return this.kilogram end
unit_meta.getmeter = function(this) return this.meter end
unit_meta.getsecond = function(this) return this.second end
unit_meta.getampere = function(this) return this.ampere end
unit_meta.getkelvin = function(this) return this.kelvin end
unit_meta.getmole = function(this) return this.mole end
unit_meta.getcandela = function(this) return this.candela end

unit_meta.setkilogram = function(this, num) this.kilogram = num end
unit_meta.setmeter = function(this, num) this.meter = num end
unit_meta.setsecond = function(this, num) this.second = num end
unit_meta.setampere = function(this, num) this.ampere = num end
unit_meta.setkelvin = function(this, num) this.kelvin = num end
unit_meta.setmole = function(this, num) this.mole = num end
unit_meta.setcandela = function(this, num) this.candela = num end


return unit