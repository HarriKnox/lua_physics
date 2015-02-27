local units = {}
local unit = require('unit')

local kg = unit.new(1, 0, 0, 0, 0, 0, 0)
local m = unit.new(0, 1, 0, 0, 0, 0, 0)
local s = unit.new(0, 0, 1, 0, 0, 0, 0)
local a = unit.new(0, 0, 0, 1, 0, 0, 0)
local k = unit.new(0, 0, 0, 0, 1, 0, 0)
local mol = unit.new(0, 0, 0, 0, 0, 1, 0)
local cd = unit.new(0, 0, 0, 0, 0, 0, 1)

units.kilogram = kg
units.meter = m
units.metre = m -- For the non-Americans
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

units.minute = 60 * s
units.hour = 60 * units.minute
units.day = 24 * units.hour
units.hectare = 10000 * (m ^ 2)
units.liter = 0.001 * (m ^ 3)
units.litre = units.liter -- For the non-Americans
units.tonne = 1000 * kg
units.electronvolt = 1.6021765314e-19 * units.joule
units.astronomicalunit = 1.495978706916e11 * units.meter
units.speedoflight = 299792458 * m / s

units.empty = unit.new(0, 0, 0, 0, 0, 0, 0)

return units
