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
		-- if both passed values are vectors, then return a vector
		return {
			x = first.x + second.x,
			y = first.y + second.y,
			z = first.z + second.z
		}
	end
	return first + second -- fallback
end

vector.subtract = function(first, second)
	if vector.isvector(first) and vector.isvector(second) then
		return {
			x = first.x - second.x,
			y = first.y - second.y,
			z = first.z - second.z
		}
	end
	return first - second
end

return vector