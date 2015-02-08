local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local common = require('common')
local scalar = require('scalar')


unit.new = function(parkg, parm, pars, para, park, parmol, parcd)
	if type(parkg) == 'number' and type(parm) == 'number' and type(pars) == 'number' and type(para) == 'number' and type(park) == 'number' and type(parmol) == 'number' and type(parcd) == 'number' then
		return setmetatable({kilogram = parkg, meter = parm, second = pars, ampere = para, kelvin = park, mole = parmol, candela = parcd}, unit_meta)
	end
	common.typeerror('creation', parkg, parm, pars, para, park, parmol, parcd, 'unit')
end

common.setcallmeta(unit)

unit.isunit = function(un)
	return getmetatable(un) == unit_meta
end
common.registertype(unit.isunit, 'unit')

unit.clone = function(un)
	if unit.isunit(un) then
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
	if unit.isunit(first) and unit.isunit(second) then
		local kg = first:getkilogram() + second:getkilogram()
		local m = first:getmeter() + second:getmeter()
		local s = first:getsecond() + second:getsecond()
		local a = first:getampere() + second:getampere()
		local k = first:getkelvin() + second:getkelvin()
		local mol = first:getmole() + second:getmole()
		local cd = first:getcandela() + second:getcandela()
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	if unit.isunit(first) and type(second) == 'scalar' then
		local units = second:getunits()
		local kg = first:getkilogram() + units:getkilogram()
		local m = first:getmeter() + units:getmeter()
		local s = first:getsecond() + units:getsecond()
		local a = first:getampere() + units:getampere()
		local k = first:getkelvin() + units:getkelvin()
		local mol = first:getmole() + units:getmole()
		local cd = first:getcandela() + units:getcandela()
		return scalar.new(second:getvalue(), unit.new(kg, m, s, a, k, mol, cd))
	end
	common.typeerror('multiplication', first, second, 'unit')
end

unit.divide = function(first, second)
	if unit.isunit(first) and unit.isunit(second) then
		local kg = first:getkilogram() - second:getkilogram()
		local m = first:getmeter() - second:getmeter()
		local s = first:getsecond() - second:getsecond()
		local a = first:getampere() - second:getampere()
		local k = first:getkelvin() - second:getkelvin()
		local mol = first:getmole() - second:getmole()
		local cd = first:getcandela() - second:getcandela()
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	if type(first) == 'number' and unit.isunit(second) then
		local kg = -second:getkilogram()
		local m = -second:getmeter()
		local s = -second:getsecond()
		local a = -second:getampere()
		local k = -second:getkelvin()
		local mol = -second:getmole()
		local cd = -second:getcandela()
		return unit.new(kg, m, s, a, k, mol, cd)
	end
	if unit.isunit(first) and type(second) == 'number' then
		return unit.clone(first)
	end
	common.typeerror('division', first, second, 'unit')
end

unit.power = function(unt, num)
	if unit.isunit(unt) and type(num) == 'number' then
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
	if unit.isunit(first) and unit.isunit(second) then
		local kg = first:getkilogram() == second:getkilogram()
		local m = first:getmeter() == second:getmeter()
		local s = first:getsecond() == second:getsecond()
		local a = first:getampere() == second:getampere()
		local k = first:getkelvin() == second:getkelvin()
		local mol = first:getmole() == second:getmole()
		local cd = first:getcandela() == second:getcandela()
		return kg and m and s and a and k and mol and cd
	end
	common.typeerror('equation', first, second, 'unit')
end

unit.isempty = function(unt)
	if unit.isunit(unt) then
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