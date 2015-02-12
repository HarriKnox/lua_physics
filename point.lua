local point = {}
local point_meta = {}
point_meta.__index = point_meta
local common = require('common')


point.new = function(parx, pary, parz)
	if type(parx) == 'number' and type(pary) == 'number' and type(parz) == 'number' then
		return setmetatable({x = parx, y = pary, z = parz}, point_meta)
	end
	common.typeerror('creation', parx, pary, parz, 'point')
end

common.setcallmeta(point)
common.registertype(point_meta, 'point')

point.clone = function(pnt)
	if type(pnt) == 'point' then
		local x = pnt.x
		local y = pnt.y
		local z = pnt.z
		return point.new(x, y, z)
	end
	common.typeerror('cloning', pnt, 'point')
end

point.equals = function(first, second)
	if type(first) == 'point' and type(second) == 'point' then
		local x = first.x == second.x
		local y = first.y == second.y
		local z = first.z == second.z
		return x and y and z
	end
	return false
end

point.translate = function(pnt, vect)
	if type(pnt) == 'point' and type(vect) == 'vector' then
		local x = pnt.x + vect.x
		local y = pnt.y + vect.y
		local z = pnt.z + vect.z
		return point.new(x, y, z)
	end
	common.typeerror('translation', pnt, vect, 'point')
end

point.difference = function(this, that)
	if type(this) == 'point' and type(that) == 'point' then
		local x = that.x - this.x
		local y = that.y - this.y
		local z = that.z - this.z
		return require('vector').new(x, y, z)
	end
	common.typeerror('difference', this, that, 'point')
end

point.tostring = function(pnt)
	return string.format("point: (%g, %g, %g)", pnt.x, pnt.y, pnt.z)
end


common.getmethods(point, point_meta)

point_meta.__eq = point.equals
point_meta.__tostring = point.tostring

point_meta.__add = common.notsupported('points', 'addition')
point_meta.__sub = common.notsupported('points', 'subtraction')
point_meta.__mul = common.notsupported('points', 'multiplication')
point_meta.__div = common.notsupported('points', 'division')
point_meta.__unm = common.notsupported('points', 'unary-minus')
point_meta.__idiv = common.notsupported('points', 'int-division')
point_meta.__len = common.notsupported('points', 'length')
point_meta.__mod = common.notsupported('points', 'modulo')
point_meta.__pow = common.notsupported('points', 'powers')
point_meta.__concat = common.notsupported('points', 'concatination')
point_meta.__lt = common.notsupported('points', 'less-than')
point_meta.__le = common.notsupported('points', 'less-than-or-equal-to')
point_meta.__band = common.notsupported('points', 'bitwise')
point_meta.__bor = point_meta.__band
point_meta.__bxor = point_meta.__band
point_meta.__bnot = point_meta.__band
point_meta.__shl = point_meta.__band
point_meta.__shr = point_meta.__band


return point