local vector = {}
local vector_meta = {}
vector_meta.__index = vector_meta
local common = require('common')


vector.new = function(parx, pary, parz, paru)
	if type(parx) == 'number' and type(parx) == 'number' and type(parx) == 'number' then
		return setmetatable({x = parx, y = pary, z = parz}, vector_meta)
	end
	common.typeerror('creation', parx, pary, parz, 'vector')
end

common.setcallmeta(vector)
common.registertype(vector_meta, 'vector')

vector.clone = function(vect)
	if type(vect) == 'vector' then
		local x = vect.x
		local y = vect.y
		local z = vect.z
		return vector.new(x, y, z)
	end
	common.typeerror('cloning', vect, 'vector')
end

vector.add = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first.x + second.x
		local y = first.y + second.y
		local z = first.z + second.z
		return vector.new(x, y, z)
	end
	common.typeerror('addition', first, second, 'vector')
end

vector.subtract = function(first, second)
	if type(first) == 'vector' and type(second) == 'vector' then
		local x = first.x - second.x
		local y = first.y - second.y
		local z = first.z - second.z
		return vector.new(x, y, z)
	end
	common.typeerror('subtraction', first, second, 'vector')
end

vector.multiply = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local x = first.x * second
		local y = first.y * second
		local z = first.z * second
		return vector.new(x, y, z)
	end
	if type(second) == 'vector' and type(first) == 'number' then
		local x = second.x * first
		local y = second.y * first
		local z = second.z * first
		return vector.new(x, y, z)
	end
	common.typeerror('multiplication', first, second, 'vector')
end

vector.divide = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local x = first.x / second
		local y = first.y / second
		local z = first.z / second
		return vector.new(x, y, z)
	end
	common.typeerror('division', first, second, 'vector')
end

vector.intdivide = function(first, second)
	if type(first) == 'vector' and type(second) == 'number' then
		local vect = vector.divide(first, second)
		vect.x = math.floor(vect.x)
		vect.y = math.floor(vect.y)
		vect.z = math.floor(vect.z)
		return vect
	end
	common.typeerror('division', first, second, 'vector')
end

vector.negate = function(vect)
	if type(vect) == 'vector' then
		local x = vect.x
		local y = vect.y
		local z = vect.z
		return vector.new(-x, -y, -z)
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
		local x = vect.x / mag
		local y = vect.y / mag
		local z = vect.z / mag
		return vector.new(x, y, z)
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

vector.tostring = function(vect)
	return string.format("vector: (%g, %g, %g)", vect.x, vect.y, vect.z)
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