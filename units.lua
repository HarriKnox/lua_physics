local units = {}
local unit = require('unit')

--[[local ]]kg = unit.new(1, 0, 0, 0, 0, 0, 0)
--[[local ]]m = unit.new(0, 1, 0, 0, 0, 0, 0)
--[[local ]]s = unit.new(0, 0, 1, 0, 0, 0, 0)
--[[local ]]a = unit.new(0, 0, 0, 1, 0, 0, 0)
--[[local ]]k = unit.new(0, 0, 0, 0, 1, 0, 0)
--[[local ]]mol = unit.new(0, 0, 0, 0, 0, 1, 0)
--[[local ]]cd = unit.new(0, 0, 0, 0, 0, 0, 1)

units.kilogram = kg
units.meter = m
units.second = s
units.ampere = a
units.kelvin = k
units.mole = mol
units.candela = cdlocal units = {}
local unit = require('unit')

--[[local ]]kg = unit.new(1, 0, 0, 0, 0, 0, 0)
--[[local ]]m = unit.new(0, 1, 0, 0, 0, 0, 0)
--[[local ]]s = unit.new(0, 0, 1, 0, 0, 0, 0)
--[[local ]]a = unit.new(0, 0, 0, 1, 0, 0, 0)
--[[local ]]k = unit.new(0, 0, 0, 0, 1, 0, 0)
--[[local ]]mol = unit.new(0, 0, 0, 0, 0, 1, 0)
--[[local ]]cd = unit.new(0, 0, 0, 0, 0, 0, 1)

units.kilogram = kg
units.meter = m
units.second = s
units.ampere = a
units.kelvin = k
units.mole = mol
units.candela = cd

units.hertz = 1 / s
units.newton = (kg * m) / (s ^ 2)
units.pascal = units.newton / (m ^ 2)
units.joule = units.newton * m
units.watt = units.joule / s
units.coulomb = s * a
units.volt = units.watt / a
units.farad = units.coulomb / units.volt
units.ohm = units.volt / a

units.empty = unit.new(0, 0, 0, 0, 0, 0, 0)

return units

units.empty = unit.new(0, 0, 0, 0, 0, 0, 0)

return units