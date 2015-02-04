local unit = {}
local unit_meta = {}
unit_meta.__index = unit_meta

local _type = type
type = function(thing)
	local t = _type(thing)
	if t == "table" and unit.isunit(thing) then
		t = "unit"
	end
	return t
end