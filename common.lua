local common = {}

local _type = type
local types = {}
type = function(thing)
	local t = _type(thing)
	if t == 'table' then
		for meta, name in pairs(types) do
			if getmetatable(thing) == meta then
				t = name
				break
			end
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

common.registertype = function(typemeta, typename)
	types[typemeta] = typename
end

common.typeerror = function(...)
	local args = {...}
	local len = #args - 2
	local typename = table.remove(args)
	local operation = table.remove(args, 1)
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

common.istype = function(thing, types)
	local t = type(thing)
	for key, value in pairs(type) do
		if t == value then
			return true
		end
	end
	return false
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