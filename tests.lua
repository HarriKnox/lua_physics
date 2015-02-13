#!/usr/bin/env lua
local common = require('common')
local vector = require('vector')
local point = require('point')
local unit = require('unit')
local units = require('units')
local scalar = require('scalar')

-- Defining testing values and testing module.new functions. The components
-- for the vectors and points were based on Pythagorean Quadruples. The values
-- for the units were random numbers
local v0 = vector.new(-2, 3, -6)
local v1 = vector.new(12, 15, 16)
local p0 = point.new(8, -9, -12)
local p1 = point.new(9, -12, 20)
local u0 = unit.new(-1, -2, 0, 3, -2, 2, -3)
local u1 = unit.new(0, 3, 0, 3, -3, 2, 0)
local s0 = scalar.new(20, unit.new(1, 1, -2, -1, 0, 0, 0))
local s1 = scalar.new(10, unit.new(0, 1, -2, 0, 0, 0, 0))


do -- Test __call metamethod for the modules.
	assert(v0 == vector(-2, 3, -6))
	assert(p0 == point(8, -9, -12))
	assert(u0 == unit(-1, -2, 0, 3, -2, 2, -3))
	assert(s0 == scalar(20, unit.new(1, 1, -2, -1, 0, 0, 0)))
end

do -- Test type registration
	assert(type(v0) == 'vector')
	assert(type(p0) == 'point')
	assert(type(u0) == 'unit')
	assert(type(s0) == 'scalar')
end

do -- Test clone function and ==
	assert(vector.clone(v0) == v0)
	assert(v0:clone() == v0)
	
	assert(point.clone(p0) == p0)
	assert(p0:clone() == p0)
	
	assert(unit.clone(u0) == u0)
	assert(u0:clone() == u0)
	
	assert(scalar.clone(s0) == s0)
	assert(s0:clone() == s0)
end

do -- Test tostring metamethod for modules
	local str0 = "vector: (-2, 3, -6)"
	assert(vector.tostring(v0) == str0)
	assert(v0:tostring() == str0)
	assert(tostring(v0) == str0)
	
	local str1 = "point: (8, -9, -12)"
	assert(point.tostring(p0) == str1)
	assert(p0:tostring() == str1)
	assert(tostring(p0) == str1)
	
	local str2 = "A^3 mol^2 / kg m^2 K^2 cd^3"
	assert(unit.tostring(u0) == str2)
	assert(u0:tostring() == str2)
	assert(tostring(u0) == str2)
	
	local str3 = "kg^-1 m^-2 A^3 K^-2 mol^2 cd^-3"
	assert(unit.tostring(u0, true) == str3)
	assert(u0:tostring(true) == str3)
	
	local str4 = "20 kg m / s^2 A"
	assert(scalar.tostring(s0) == str4)
	assert(s0:tostring() == str4)
	assert(tostring(s0) == str4)
	
	local str5 = "20 kg m s^-2 A^-1"
	assert(scalar.tostring(s0, true) == str5)
	assert(s0:tostring(true) == str5)
end

do -- Test Vector functions
	-- Vector addition, and commutative property
	local v2 = vector.new(10, 18, 10)
	assert(vector.add(v0, v1) == v2)
	assert(v0:add(v1) == v2)
	assert(v0 + v1 == v2)
	assert(vector.add(v1, v0) == v2)
	assert(v1:add(v0) == v2)
	assert(v1 + v0 == v2)
	
	-- Vector subtraction
	local v3 = vector.new(-14, -12, -22)
	assert(vector.subtract(v0, v1) == v3)
	assert(v0:subtract(v1) == v3)
	assert(v0 - v1 == v3)
	
	-- Vector subtraction part 2, note there is no commutative property
	local v4 = vector.new(14, 12, 22)
	assert(vector.subtract(v1, v0) == v4)
	assert(v1:subtract(v0) == v4)
	assert(v1 - v0 == v4)
	
	-- Vector multiplication, and commutative property
	local v5 = vector.new(-8, 12, -24)
	assert(vector.multiply(v0, 4) == v5)
	assert(v0:multiply(4) == v5)
	assert(v0 * 4 == v5)
	assert(vector.multiply(4, v0) == v5)
	assert(4 * v0 == v5)
	
	-- Vector division, note no commutative property
	local v6 = vector.new(-0.5, 0.75, -1.5)
	assert(vector.divide(v0, 4) == v6)
	assert(v0:divide(4) == v6)
	assert(v0 / 4 == v6)
	
	-- Vector int division, also no commutativity (in Lua 5.3 you can do v0 // 4, but to make this script backward compatible, the `//´ operator isn't included)
	local v7 = vector.new(-1, 0, -2)
	assert(vector.intdivide(v0, 4) == v7)
	assert(v0:intdivide(4) == v7)
	
	-- Vector negation
	local v8 = vector.new(2, -3, 6)
	assert(vector.negate(v0) == v8)
	assert(v0:negate() == v8)
	assert(-v0 == v8)
	
	-- Vector magnitude (the reason why I made the components part of a Pythagorean Quadruple)
	local n0 = 7 -- A whole number *glee*
	assert(vector.magnitude(v0) == n0)
	assert(v0:magnitude() == n0)
	assert(#v0 == n0)
	
	-- Vector normalize
	local v9 = vector.new(-2 / 7, 3 / 7, -6 / 7)
	assert(vector.normalize(v0) == v9)
	assert(v0:normalize() == v9)
	
	-- Vector dotproduct, commutative
	local n1 = -75
	assert(vector.dotproduct(v0, v1) == n1)
	assert(vector.dotproduct(v1, v0) == n1)
	assert(v0:dotproduct(v1) == n1)
	assert(v1:dotproduct(v0) == n1)
	
	-- Vector crossproduct, not commutative, but the opposite order is the negative of the resulting cross vector
	local vA = vector.new(138, -40, 66)
	assert(vector.crossproduct(v0, v1) == vA, vector.crossproduct(v0, v1))
	assert(v0:crossproduct(v1) == vA)
	assert(vector.crossproduct(v1, v0) == -vA)
	assert(v1:crossproduct(v0) == -vA)
	
	-- Vector azimuth angle
	local n2 = math.atan(3, -2)
	assert(vector.azimuth(v0) == n2)
	assert(v0:azimuth() == n2)
	
	--Vector altitude angle
	local n3 = math.atan(-6, 13 ^ 0.5)
	assert(vector.altitude(v0) == n3)
	assert(v0:altitude() == n3)
end

do -- Test Point functions
	-- Point translation
	local p2 = point.new(6, -6, -18)
	assert(point.translate(p0, v0) == p2)
	assert(p0:translate(v0) == p2)
	
	-- Point difference
	local vB = vector.new(1, -3, 32)
	assert(point.difference(p0, p1) == vB)
	assert(p0:difference(p1) == vB)
	assert(point.difference(p1, p0) == -vB)
	assert(p1:difference(p0) == -vB)
end

do -- Test Unit function
	-- Unit multiplication, note the beautiful commutative nature of unit multiplication
	local u2 = unit.new(-1, 1, 0, 6, -5, 4, -3)
	assert(unit.multiply(u0, u1) == u2)
	assert(u0:multiply(u1) == u2)
	assert(u0 * u1 == u2)
	assert(unit.multiply(u1, u0) == u2)
	assert(u1:multiply(u0) == u2)
	assert(u1 * u0 == u2)
	
	-- Unit multiplication with unit and number to return scalar
	local s2 = scalar.new(2, unit.new(-1, -2, 0, 3, -2, 2, -3))
	assert(unit.multiply(u0, 2) == s2)
	assert(u0:multiply(2) == s2)
	assert(u0 * 2 == s2)
	assert(unit.multiply(2, u0) == s2)
	assert(2 * u0 == s2)
	
	-- Unit multiplication with unit and scalar to return number, note no `s3 * u0` since that calls scalar.multiply
	local n4 = 4
	local s3 = scalar.new(4, unit.new(1, 2, 0, -3, 2, -2, 3))
	assert(unit.multiply(u0, s3) == n4)
	assert(u0:multiply(s3) == n4)
	assert(u0 * s3 == n4)
	assert(unit.multiply(s3, u0) == n4)
	
	-- Unit multiplication with unit and scalar to return scalar
	local s4 = scalar.new(4, unit.new(2, 3, 1, -2, 3, -1, 4))
	local s5 = scalar.new(4, unit.new(1, 1, 1, 1, 1, 1, 1))
	assert(unit.multiply(u0, s4) == s5)
	assert(u0:multiply(s4) == s5)
	assert(u0 * s4 == s5)
	assert(unit.multiply(s4, u0) == s5)
	
	-- Unit division (as well as intdivision), note the disgusting non-commutative nature of unit division, as well as the lack of a `//´ for compatibility
	local u3 = unit.new(-1, -5, 0, 0, 1, 0, -3)
	assert(unit.divide(u0, u1) == u3)
	assert(u0:divide(u1) == u3)
	assert(u0 / u1 == u3)
	assert(unit.intdivide(u0, u1) == u3)
	assert(u0:intdivide(u1) == u3)
	
	-- Unit division part 2, emphasizing the grotesque non-commutativity
	local u4 = unit.new(1, 5, 0, 0, -1, 0, 3)
	assert(unit.divide(u1, u0) == u4)
	assert(u1:divide(u0) == u4)
	assert(u1 / u0 == u4)
	assert(unit.intdivide(u1, u0) == u4)
	assert(u1:intdivide(u0) == u4)
end

print("All tests passed with no issues.")
