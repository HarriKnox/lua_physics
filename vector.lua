local vector = {}
local vector_meta = {}
vector_meta.__index = vector_meta

local _type = type
type = function(thing)
	local t = _type(thing)
	if t == "table" and vector.isvector(thing) then
		t = "vector"
	end
	return t
end

local geterror = function(operation, ...)
	local types = {...}
	local message = string.format("incompatible type%s for vector %s: ", #types == 1 and "" or "s", operation)
	if #types < 2 then
		return message .. types[1]
	end
	if #types == 2 then
		return message .. types[1] .. " and " .. types[2]
	end
	for i = 1, #types - 1 do
		message = message .. types[i] .. ", "
	end
	return message .. "and " .. types[#types]
end

vector.new = function(parx, pary, parz)
	if type(parx) == "number" and type(pary) == "number" and type(parz) == "number" then
		return setmetatable({x = parx, y = pary, z = parz}, vector_meta)
	end
	error(geterror("creation", type(parx), type(pary), type(parz)), 2)
end

vector.isvector = function(vect)
	return getmetatable(vect) == vector_meta
end

vector.add = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() + second:getx()
		local y = first:gety() + second:gety()
		local z = first:getz() + second:getz()
		return vector.new(x, y, z)
	end
	error(geterror("addition", type(first), type(second)), 2)
end

vector.subtract = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() - second:getx()
		local y = first:gety() - second:gety()
		local z = first:getz() - second:getz()
		return vector.new(x, y, z)
	end
	error(geterror("subtraction", type(first), type(second)), 2)
end

vector.multiply = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local x = first:getx() * second
		local y = first:gety() * second
		local z = first:getz() * second
		return vector.new(x, y, z)
	end
	if vector.isvector(second) and type(first) == "number" then
		local x = second:getx() * first
		local y = second:gety() * first
		local z = second:getz() * first
		return vector.new(x, y, z)
	end
	error(geterror("multiplication", type(first), type(second)), 2)
end

vector.divide = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local x = first:getx() / second
		local y = first:gety() / second
		local z = first:getz() / second
		return vector.new(x, y, z)
	end
	error(geterror("division", type(first), type(second)), 2)
end

vector.intdivide = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local vect = vector.divide(first, second)
		vect:setx(math.floor(vect:getx()))
		vect:sety(math.floor(vect:gety()))
		vect:setz(math.floor(vect:getz()))
		return vect
	end
	error(geterror("division", type(first), type(second)), 2)
end

vector.negate = function(vect)
	if vector.isvector(vect) then
		local x = vect:getx()
		local y = vect:gety()
		local z = vect:getz()
		return vector.new(-x, -y, -z)
	end
	error(geterror("negation", type(vect)), 2)
end

vector.equals = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() == second:getx()
		local y = first:gety() == second:gety()
		local z = first:getz() == second:getz()
		return x and y and z
	end
	error(geterror("equation", type(first), type(second)), 2)
end


local notsupported = function(operation)
	return function(this, that)
		error(operation .. "not supported with vectors", 2)
	end
end

vector_meta.__add = vector.add
vector_meta.__sub = vector.subtract
vector_meta.__mul = vector.multiply
vector_meta.__div = vector.divide
vector_meta.__unm = vector.negate
vector_meta.__idiv = vector.intdivide
vector_meta.__eq = vector.equals

vector_meta.__mod = notsupported("modulo")
vector_meta.__pow = notsupported("powers")
vector_meta.__band = notsupported("bitwise-and")
vector_meta.__bor = notsupported("bitwise-or")
vector_meta.__bxor = notsupported("bitwise-xor")
vector_meta.__bnot = notsupported("bitwise-not")
vector_meta.__shl = notsupported("bitshift")
vector_meta.__shr = notsupported("bitshift")
vector_meta.__concat = notsupported("concatination")
vector_meta.__len = notsupported("length")
vector_meta.__lt = notsupported("less-than")
vector_meta.__le = notsupported("less-than-or-equal-to")

vector_meta.getx = function(this) return this.x end
vector_meta.gety = function(this) return this.y end
vector_meta.getz = function(this) return this.z end
vector_meta.setx = function(this, num) this.x = num end
vector_meta.sety = function(this, num) this.y = num end
vector_meta.setz = function(this, num) this.z = num end

return vector