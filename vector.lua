local vector = {}
local vector_meta = {}

vector.isvector = function(vect)
	return getmetatable(vect) == vector_meta
end

vector.new = function(parx, pary, parz)
	local vect = {x = parx, y = pary, z = parz}
	setmetatable(vect, vector_meta)
	vector_meta.__index = vector_meta
	return vect
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

return vector