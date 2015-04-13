local system = {}
local system_meta = {}
system_meta.__index = system_meta
local common = require('common')

system.new = function()
	return setmetatable({objects = {}}, system_meta)
end

common.setmetacall(system)
common.registertype(system_meta, 'system')

system.addparticle(sys, part)
	if type(sys) == 'system' and type(part) == 'particle' then
		if not common.intable(part, sys.objects) then
			table.insert(sys.objects, part)
			return sys
		end
		error("particle already exists in system")
	end
	common.typeerror('particle addition', sys, part, 'system')
end
