local common = {}

local _type = type
type = function(thing)
	local t = _type(thing)
	for check, name in pairs(types) do
		if check(thing) then
			t = name
			break
		end
	end
	return t
end

local types = {}
common.registertype = function(checkfunction, typename)
	types[checkfunction] = typename
end
