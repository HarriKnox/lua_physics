local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local common = require('common')


unit.new = function(parkg, parm, pars, para, park, parmol, parcd)
	if type(parkg) == 'number' and type(parm) == 'number' and type(pars) == 'number' and type(para) == 'number' and type(park) == 'number' and type(parmol) == 'number' and type(parcd) == 'number' then
		return setmetatable({kilogram = parkg, meter = parm, second = pars, ampere = para, kelvin = park, mole = parmol, candela = parcd}, unit_meta)
	end
	common.typeerror('unit', 'creation', type(parkg), type(parm), type(pars), type(para), type(park), type(parmol), type(parcd))
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
	common.typeerror('unit', 'cloning', type(un))
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
	common.typeerror('unit', 'equation', type(first), type(second))
end

unit_meta.__tostring = function(this)
	local str = "unit:"
	local numerator = ""
	local denominator = ""
	local units = {
		{func = 'getkilogram', str = 'kg'},
		{func = 'getmeter', str = 'm'},
		{func = 'getsecond', str = 's'},
		{func = 'getampere', str = 'A'},
		{func = 'getkelvin', str = 'K'},
		{func = 'getmole', str = 'mol'},
		{func = 'getcandela', str = 'cd'}
	}
	for ord, un in pairs(units) do
		local x = this[un.func](this)
		if x > 0 then
			numerator = numerator .. ' ' .. un.str
			if x > 1 then
				numerator = numerator .. '^' .. tostring(x)
			end
		elseif x < 0 then
			denominator = denominator .. ' ' .. un.str
			if x < -1 then
				denominator = denominator .. '^' .. tostring(-x)
			end
		end
	end
	if #numerator == 0 then
		numerator = ' 1'
	end
	if #denominator > 0 then
		return str .. numerator .. ' /' .. denominator
	end
	return str .. numerator
end

unit_meta.getkilogram = function(this) return this.kilogram end
unit_meta.getmeter = function(this) return this.meter end
unit_meta.getsecond = function(this) return this.second end
unit_meta.getampere = function(this) return this.ampere end
unit_meta.getkelvin = function(this) return this.kelvin end
unit_meta.getmole = function(this) return this.mole end
unit_meta.getcandela = function(this) return this.candela end

return unit