local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local common = require('common')

common.registertype(unit.isunit, 'unit')