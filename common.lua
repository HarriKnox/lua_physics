local common = {}

local _type = type
local types = {}
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

common.getcall = function(newfunc)
	return {
		__call = function(_, ...)
			local ok, obj = pcall(newfunc, ...)
			if not ok then
				error(obj, 2)
			end
			return obj
		end
	}
)

common.registertype = function(checkfunction, typename)
	types[checkfunction] = typename
end

common.typeerror = function(typename, operation, ...)
	local types = {...}
	local message = string.format("incompatible type%s for %s %s: ", #types == 1 and "" or "s", typename, operation)
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

common.notsupported = function(typename, operation)
	return function(this, that)
		error(operation .. " not supported with " .. typename, 2)
	end
end

return common