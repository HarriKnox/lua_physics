local point = {}
local point_meta = {}
point_meta.__index = point_meta

local vector = require('vector')
local common = require('common')


point.new = function(parx, pary, parz)
	if type(parx) == 'number' and type(pary) == 'number' and type(parz) == 'number' then
		return setmetatable({x = parx, y = pary, z = parz}, point_meta)
	end
	common.typeerror('point', 'creation', type(parx), type(pary), type(parz))
end

common.setcallmeta(point)

point.ispoint = function(pnt)
	return getmetatable(pnt) == point_meta
end
common.registertype(point.ispoint, 'point')

point.clone = function(pnt)
	if point.ispoint(pnt) then
		local x = pnt:getx()
		local y = pnt:gety()
		local z = pnt:getz()
		return point.new(x, y, z)
	end
	common.typeerror('point', 'cloning', type(pnt))
end

point.equals = function(first, second)
	if point.ispoint(first) and point.ispoint(second) then
		local x = first:getx() == second:getx()
		local y = first:gety() == second:gety()
		local z = first:getz() == second:getz()
		return x and y and z
	end
	common.typeerror('point', 'equation', type(first), type(second))
end

point.translate = function(pnt, vect)
	if point.ispoint(pnt) and vector.isvector(vect) then
		local x = pnt:getx() + vect:getx()
		local y = pnt:gety() + vect:gety()
		local z = pnt:getz() + vect:getz()
		return point.new(x, y, z)
	end
	common.typeerror('point', 'translation', type(pnt), type(vect))
end



point_meta.__eq = point.equals

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

point_meta.__tostring = function(this)
	return string.format("point: (%g, %g, %g)", this:getx(), this:gety(), this:getz())
end

point_meta.getx = function(this) return this.x end
point_meta.gety = function(this) return this.y end
point_meta.getz = function(this) return this.z end
point_meta.setx = function(this, num) this.x = num end
point_meta.sety = function(this, num) this.y = num end
point_meta.setz = function(this, num) this.z = num end
point_meta.clone = point.clone

return point