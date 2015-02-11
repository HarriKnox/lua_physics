vector = require('vector')
point = require('point')
unit = require('unit')
scalar = require('scalar')

local physics = {}

physics.constants = {}
physics.units = {}

--[[local ]]kg = unit.new(1, 0, 0, 0, 0, 0, 0)
--[[local ]]m = unit.new(0, 1, 0, 0, 0, 0, 0)
--[[local ]]s = unit.new(0, 0, 1, 0, 0, 0, 0)
--[[local ]]a = unit.new(0, 0, 0, 1, 0, 0, 0)
--[[local ]]k = unit.new(0, 0, 0, 0, 1, 0, 0)
--[[local ]]mol = unit.new(0, 0, 0, 0, 0, 1, 0)
--[[local ]]cd = unit.new(0, 0, 0, 0, 0, 0, 1)

physics.units.kilogram = kg
physics.units.meter = m
physics.units.second = s
physics.units.ampere = a
physics.units.kelvin = k
physics.units.mole = mol
physics.units.candela = cd

physics.units.empty = unit.new(0, 0, 0, 0, 0, 0, 0)

return physics