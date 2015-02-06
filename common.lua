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

common.setcallmeta = function(parmodule)
	setmetatable(parmodule, {
			__call = function(_, ...)
				local ok, obj = pcall(parmodule.new, ...)
				if not ok then
					error(obj, 2)
				end
				return obj
			end})
end

common.registertype = function(checkfunction, typename)
	types[checkfunction] = typename
end

common.typeerror = function(...)
	local args = {...}
	local len = #args - 2
	local operation = table.remove(args, 1)
	local typename = table.remove(args)
	local message = string.format("incompatible type%s for %s %s: ", len == 1 and "" or "s", typename, operation)
	if len < 2 then
		message = message .. type(args[1])
	elseif len == 2 then
		message = message .. type(args[1]) .. " and " .. type(args[2])
	else
		for i = 1, len - 1 do
			message = message .. type(args[i]) .. ", "
		end
		message = message .. "and " .. type(args[len])
	end
	error(message, 3)
end

common.notsupported = function(typename, operation)
	return function(this, that)
		error(operation .. " not supported with " .. typename, 2)
	end
end

common.getmethods = function(parmodule, parmetatable)
	for key, value in pairs(parmodule) do
		if key ~= 'new' then
			parmetatable[key] = value
		end
	end
	for check, typename in pairs(types) do
		parmetatable['is' .. typename] = nil
	end
end

return common