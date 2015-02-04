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

local incompatable = function(operation, ...)
	local types = {...}
	local message = string.format("incompatible type%s for point %s: ", #types == 1 and "" or "s", operation)
	if #types < 2 then
		message = message .. types[1]
	elseif #types == 2 then
		message = message .. types[1] .. " and " .. types[2]
	else
		for i = 1, #types - 1 do
			message = message .. types[i] .. ", "
		end
		message = message .. "and " .. types[#types]
	end
	error(message, 3)
end