local system = {}
local system_meta = {}
system_meta.__index = system_meta
local common = require('common')

system.new = function()
	return setmetatable({objects = {}}, system_meta)
end

common.setmetacall(system)
common.registertype(system_meta, 'system')
