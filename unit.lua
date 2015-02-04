local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local common = require('common')


unit.isunit = function(un)
	return getmetatable(un) == unit_meta
end
common.registertype(unit.isunit, 'unit')