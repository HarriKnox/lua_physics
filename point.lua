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

point.ispoint = function(pnt)
	return getmetatable(pnt) == point_meta
end

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



local notsupported = function(operation)
	return function(this, that)
		error(operation .. " not supported with points", 2)
	end
end

point_meta.__eq = point.equals

point_meta.__add = notsupported("addition")
point_meta.__sub = notsupported("subtraction")
point_meta.__mul = notsupported("multiplication")
point_meta.__div = notsupported("division")
point_meta.__unm = notsupported("unary-minus")
point_meta.__idiv = notsupported("int-division")
point_meta.__len = notsupported("length")
point_meta.__mod = notsupported("modulo")
point_meta.__pow = notsupported("powers")
point_meta.__concat = notsupported("concatination")
point_meta.__lt = notsupported("less-than")
point_meta.__le = notsupported("less-than-or-equal-to")
point_meta.__band = notsupported("bitwise")
point_meta.__bor = point_meta.__band
point_meta.__bxor = point_meta.__band
point_meta.__bnot = point_meta.__band
point_meta.__shl = point_meta.__band
point_meta.__shr = point_meta.__band

point_meta.__tostring = function(this)
	return string.format("point: (%g, %g, %g)", this:getx(), this:gety(), this:getz())
end

point_meta.getx = function(this) return this.x end
point_meta.gety = function(this) return this.y end
point_meta.getz = function(this) return this.z end
point_meta.setx = function(this, num) this.x = num end
point_meta.sety = function(this, num) this.y = num end
point_meta.setz = function(this, num) this.z = num end

return point