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

vector.add = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() + second:getx()
		local y = first:gety() + second:gety()
		local z = first:getz() + second:getz()
		return vector.new(x, y, z)
	end
	return first + second
end

vector.subtract = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		local x = first:getx() - second:getx()
		local y = first:gety() - second:gety()
		local z = first:getz() - second:getz()
		return vector.new(x, y, z)
	end
	return first - second
end

vector.multiply = function(first, second)
	if vector.isvector(first) and type(second) == "number" then
		local x = first:getx() * second
		local y = first:gety() * second
		local z = first:getz() * second
		return vector.new(x, y, z)
	end
	return first * second
end

return vector