local constants = {}
local unit = require('unit')

local kg = unit.new(1, 0, 0, 0, 0, 0, 0)
local m = unit.new(0, 1, 0, 0, 0, 0, 0)
local s = unit.new(0, 0, 1, 0, 0, 0, 0)
local a = unit.new(0, 0, 0, 1, 0, 0, 0)
local k = unit.new(0, 0, 0, 0, 1, 0, 0)
local mol = unit.new(0, 0, 0, 0, 0, 1, 0)
local cd = unit.new(0, 0, 0, 0, 0, 0, 1)

constants.speedoflight = 299792458 * m / s
constants.earthgravity = 9.80665 * m / (s ^ 2)

return constants
