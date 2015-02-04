local point = {}
local point_meta = {}
point_meta.__index = point_meta

local _type = type
type = function(thing)
	local t = _type(thing)
	if t == "table" and point.ispoint(thing) then
		t = "point"
	end
	return t
end

local incompatable = function(operation, ...)
	local types = {...}
	local message = string.format("incompatible type%s for point %s: ", #types == 1 and "" or "s", operation)
	if #types < 2 then
		message = message .. types[1]
	elseif #types == 2 then
		message = message .. types[1] .. " and " .. types[2]
	else
		for i = 1, #types - 1 do
			message = message .. types[i] .. ", "
		end
		message = message .. "and " .. types[#types]
	end
	error(message, 3)
end


point.new = function(parx, pary, parz)
	if type(parx) == "number" and type(pary) == "number" and type(parz) == "number" then
		return setmetatable({x = parx, y = pary, z = parz}, point_meta)
	end
	incompatable("creation", type(parx), type(pary), type(parz))
end

setmetatable(point, {
		__call = function(_, ...)
			local ok, vect = pcall(point.new, ...)
			if not ok then
				error(vect, 2)
			end
			return vect
		end
	}
)

point.clone = function(pnt)
	if point.ispoint(pnt) then
		local x = pnt:getx()
		local y = pnt:gety()
		local z = pnt:getz()
		return point.new(x, y, z)
	end
	incompatable("cloning", type(pnt))
end

point.equals = function(first, second)
	if point.ispoint(first) and point.ispoint(second) then
		local x = first:getx() == second:getx()
		local y = first:gety() == second:gety()
		local z = first:getz() == second:getz()
		return x and y and z
	end
	incompatable("equation", type(first), type(second))
end