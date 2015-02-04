local point = {}
local point_meta = {}
point_meta.__index = point_meta

local _type = type
type = function(thing)
	local t = _type(thing)
	if t == "table" and point.ispoint(thing) then
		t = "point"
	end
	return t
end