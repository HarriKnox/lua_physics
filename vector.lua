local vector = {}
local vector_meta = {}
vector_meta.__index = vector_meta
local common = require('common')
local qvuntypes = {'quantity', 'vector', 'unit', 'number'}


vector.new = function(parx, pary, parz, paru)
	if type(parx) == 'number' and type(parx) == 'number' and type(parx) == 'number' and common.istype(paru, {'unit', 'nil'}) then
		return setmetatable({x = parx, y = pary, z = parz, units = (type(paru) == 'unit' and paru:clone() or require('units').empty)}, vector_meta)
	end
	common.typeerror('creation', parx, pary, parz, paru, 'vector')
end

common.setcallmeta(vector)
common.registertype(vector_meta, 'vector')

vector.clone = function(vect)
	if type(vect) == 'vector' then
		local x = vect.x
		local y = vect.y
		local z = vect.z
		local units = vect.units
		return vector.new(x, y, z, units)
	end
	common.typeerror('cloning', vect, 'vector')
end

vector.add = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		if first.units == second.units then
			local x = first.x + second.x
			local y = first.y + second.y
			local z = first.z + second.z
			local units = first.units
			return vector.new(x, y, z, units)
		end
		common.uniterror('addition', first.units, second.units, 'vector')
	end
	common.typeerror('addition', first, second, 'vector')
end

vector.subtract = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		if first.units == second.units then
			local x = first.x - second.x
			local y = first.y - second.y
			local z = first.z - second.z
			local units = first.units
			return vector.new(x, y, z, units)
		end
		common.uniterror('subtraction', first.units, second.units, 'vector')
	end
	common.typeerror('subtraction', first, second, 'vector')
end

vector.multiply = function(first, second)
	if common.checkvaluntypes(first, second) then
		local firstvalue = 1
		local firstx = 1
		local firsty = 1
		local firstz = 1
		local firstkg = 0
		local firstm = 0
		local firsts = 0
		local firsta = 0
		local firstk = 0
		local firstmol = 0
		local firstcd = 0
		if common.istype(first, {'vector', 'quantity'}) then
			firstkg = first.units.kilogram
			firstm = first.units.meter
			firsts = first.units.second
			firsta = first.units.ampere
			firstk = first.units.kelvin
			firstmol = first.units.mole
			firstcd = first.units.candela
		end
		if type(first) == 'vector' then
			firstx = first.x
			firsty = first.y
			firstz = first.z
		elseif type(first) == 'quantity' then
			firstvalue = first.value
			firstx = first.value
			firsty = first.value
			firstz = first.value
		elseif type(first) == 'number' then
			firstvalue = first
			firstx = first
			firsty = first
			firstz = first
		else
			firstkg = first.kilogram
			firstm = first.meter
			firsts = first.second
			firsta = first.ampere
			firstk = first.kelvin
			firstmol = first.mole
			firstcd = first.candela
		end
		local secondvalue = 1
		local secondx = 1
		local secondy = 1
		local secondz = 1
		local secondkg = 0
		local secondm = 0
		local seconds = 0
		local seconda = 0
		local secondk = 0
		local secondmol = 0
		local secondcd = 0
		if common.istype(second, {'vector', 'quantity'}) then
			secondkg = second.units.kilogram
			secondm = second.units.meter
			seconds = second.units.second
			seconda = second.units.ampere
			secondk = second.units.kelvin
			secondmol = second.units.mole
			secondcd = second.units.candela
		end
		if type(second) == 'vector' then
			secondx = second.x
			secondy = second.y
			secondz = second.z
		elseif type(second) == 'quantity' then
			secondvalue = second.value
			secondx = second.value
			secondy = second.value
			secondz = second.value
		elseif type(second) == 'number' then
			secondvalue = second
			secondx = second
			secondy = second
			secondz = second
		else
			secondkg = second.kilogram
			secondm = second.meter
			seconds = second.second
			seconda = second.ampere
			secondk = second.kelvin
			secondmol = second.mole
			secondcd = second.candela
		end
		local value = firstvalue * secondvalue
		local x = firstx * secondx
		local y = firsty * secondy
		local z = firstz * secondz
		local kg = firstkg + secondkg
		local m = firstm + secondm
		local s = firsts + seconds
		local a = firsta + seconda
		local k = firstk + firstk
		local mol = firstmol + secondmol
		local cd = firstcd + secondcd
		local unt = unit.new(kg, m, s, a, k, mol, cd)
		if type(first) == 'vector' or type(second) == 'vector' then
			return vector.new(x, y, z, unt)
		elseif (type(unt) == 'unit' and unt:isempty()) or type(unt) == 'number' then
			return value
		elseif value == 1 then
			return unt
		end
		return require('quantity').new(value, unt)
	end
	common.typeerror('multiplication', first, second, 'vector')
end

vector.divide = function(first, second)
	if common.checkvaluntypes(first, second) and type(second) ~= 'vector' then
		local firstvalue = 1
		local firstx = 1
		local firsty = 1
		local firstz = 1
		local firstkg = 0
		local firstm = 0
		local firsts = 0
		local firsta = 0
		local firstk = 0
		local firstmol = 0
		local firstcd = 0
		if common.istype(first, {'vector', 'quantity'}) then
			firstkg = first.units.kilogram
			firstm = first.units.meter
			firsts = first.units.second
			firsta = first.units.ampere
			firstk = first.units.kelvin
			firstmol = first.units.mole
			firstcd = first.units.candela
		end
		if type(first) == 'vector' then
			firstx = first.x
			firsty = first.y
			firstz = first.z
		elseif type(first) == 'quantity' then
			firstvalue = first.value
			firstx = first.value
			firsty = first.value
			firstz = first.value
		elseif type(first) == 'number' then
			firstvalue = first
			firstx = first
			firsty = first
			firstz = first
		else
			firstkg = first.kilogram
			firstm = first.meter
			firsts = first.second
			firsta = first.ampere
			firstk = first.kelvin
			firstmol = first.mole
			firstcd = first.candela
		end
		local secondvalue = 1
		local secondkg = 0
		local secondm = 0
		local seconds = 0
		local seconda = 0
		local secondk = 0
		local secondmol = 0
		local secondcd = 0
		if common.istype(second, {'vector', 'quantity'}) then
			secondkg = second.units.kilogram
			secondm = second.units.meter
			seconds = second.units.second
			seconda = second.units.ampere
			secondk = second.units.kelvin
			secondmol = second.units.mole
			secondcd = second.units.candela
		end
		if type(second) == 'quantity' then
			secondvalue = second.value
		elseif type(second) == 'number' then
			secondvalue = second
		else
			secondkg = second.kilogram
			secondm = second.meter
			seconds = second.second
			seconda = second.ampere
			secondk = second.kelvin
			secondmol = second.mole
			secondcd = second.candela
		end
		local value = firstvalue / secondvalue
		local x = firstx / secondvalue
		local y = firsty / secondvalue
		local z = firstz / secondvalue
		local kg = firstkg - secondkg
		local m = firstm - secondm
		local s = firsts - seconds
		local a = firsta - seconda
		local k = firstk - firstk
		local mol = firstmol - secondmol
		local cd = firstcd - secondcd
		local unt = unit.new(kg, m, s, a, k, mol, cd)
		if type(first) == 'vector' then
			return vector.new(x, y, z, unt)
		elseif (type(unt) == 'unit' and unt:isempty()) or type(unt) == 'number' then
			return value
		elseif value == 1 then
			return unt
		end
		return require('quantity').new(value, unt)
	end
	common.typeerror('division', first, second, 'vector')
end

vector.intdivide = function(first, second)
	if common.checkvaluntypes(first, second) and type(second) ~= 'vector' then
		local vect = vector.divide(first, second)
		if type(vect) == 'vector' then
			vect.x = math.floor(vect.x)
			vect.y = math.floor(vect.y)
			vect.z = math.floor(vect.z)
		elseif type(vect) == 'quantity' then
			vect.value = math.floor(vect.value)
		elseif type(vect) == 'number' then
			vect = math.floor(vect)
		end
		return vect
	end
	common.typeerror('division', first, second, 'vector')
end

vector.negate = function(vect)
	if type(vect) == 'vector' then
		local x = -vect.x
		local y = -vect.y
		local z = -vect.z
		local units = vect.units
		return vector.new(x, y, z, units)
	end
	common.typeerror('negation', vect, 'vector')
end

vector.equals = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first.x == second.x
		local y = first.y == second.y
		local z = first.z == second.z
		return x and y and z
	end
	return false
end

vector.magnitude = function(vect)
	if type(vect) == 'vector' then
		local x = vect.x ^ 2
		local y = vect.y ^ 2
		local z = vect.z ^ 2
		return math.sqrt(x + y + z)
	end
	common.typeerror('magnitude', vect, 'vector')
end

vector.normalize = function(vect)
	if type(vect) == 'vector' then
		local mag = vector.magnitude(vect)
		if mag > 0 then
			local x = vect.x / mag
			local y = vect.y / mag
			local z = vect.z / mag
			return vector.new(x, y, z)
		end
		error("zero-length vector")
	end
	common.typeerror('normalize', vect, 'vector')
end

vector.dotproduct = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first.x * second.x
		local y = first.y * second.y
		local z = first.z * second.z
		return x + y + z
	end
	common.typeerror('dot-product', first, second, 'vector')
end

vector.crossproduct = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = (first.y * second.z) - (first.z * second.y)
		local y = (first.z * second.x) - (first.x * second.z)
		local z = (first.y * second.x) - (first.x * second.y)
		return vector.new(x, y, z)
	end
	common.typeerror('cross-product', first, second, 'vector')
end

vector.azimuth = function(vect)
	if type(vect) == 'vector' then
		local arctan
		if math.atan == math.atan2 or math.atan2 == nil then
			arctan = math.atan
		else
			arctan = math.atan2
		end
		return arctan(vect.y, vect.x)
	end
	common.typeerror('azimuth', vect, 'vector')
end

vector.altitude = function(vect)
	if type(vect) == 'vector' then
		local arctan
		if math.atan == math.atan2 or math.atan2 == nil then
			arctan = math.atan
		else
			arctan = math.atan2
		end
		local x = vect.x ^ 2
		local y = vect.y ^ 2
		return arctan(vect.z, math.sqrt(x + y))
	end
	common.typeerror('altitude', vect, 'vector')
end

vector.anglebetween = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local firstmag = vector.magnitude(first)
		local secondmag = vector.magnitude(second)
		local mags = firstmag * secondmag
		if mags > 0 then
			local dot = vector.dotproduct(first, second)
			return math.acos(dot / mags)
		end
		error("zero-length vector")
	end
	common.typeerror('angle', first, second, 'vector')
end

vector.tostring = function(vect, comp, sci)
	local units = vect.units:isempty() and '' or ' ' .. vect.units:tostring(sci)
	if comp then
		local components = ''
		if vect.x ~= 0 then
			components = tostring(vect.x) .. " i"
		end
		if vect.y ~= 0 then
			if #components > 0 then
				components = components .. " + "
			end
			components = components .. tostring(vect.y) .. " j"
		end
		if vect.z ~= 0 then
			if #components > 0 then
				components = components .. " + "
			end
			components = components .. tostring(vect.z) .. " k"
		end
		if #components ~= 0 then
			return "(" .. components .. ")" .. units
		end
		return "0" .. units
	end
	return string.format("<%g, %g, %g>%s", vect.x, vect.y, vect.z, units)
end


common.getmethods(vector, vector_meta)

vector_meta.__add = vector.add
vector_meta.__sub = vector.subtract
vector_meta.__mul = vector.multiply
vector_meta.__div = vector.divide
vector_meta.__unm = vector.negate
vector_meta.__idiv = vector.intdivide
vector_meta.__eq = vector.equals
vector_meta.__len = vector.magnitude
vector_meta.__tostring = vector.tostring

vector_meta.__mod = common.notsupported('vectors', 'modulo')
vector_meta.__pow = common.notsupported('vectors', 'powers')
vector_meta.__concat = common.notsupported('vectors', 'concatination')
vector_meta.__lt = common.notsupported('vectors', 'less-than')
vector_meta.__le = common.notsupported('vectors', 'less-than-or-equal-to')
vector_meta.__band = common.notsupported('vectors', 'bitwise')
vector_meta.__bor = vector_meta.__band
vector_meta.__bxor = vector_meta.__band
vector_meta.__bnot = vector_meta.__band
vector_meta.__shl = vector_meta.__band
vector_meta.__shr = vector_meta.__band


return vector
