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

local prettyconcatination = function(args)
	local things = {}
	local len = #args
	for index, value in ipairs(args) do
		things[index]  = tostring(value)
	end
	if len < 2 then
		return things[1]
	elseif len == 2 then
		return things[1] .. " and " .. things[2]
	end
	local last = table.remove(things)
	local message = table.concat(things, ", ")
	return message .. ", and " .. last
end

common.typeerror = function(...)
	local args = {...}
	local types = {}
	for i = 2, #args - 1 do
		table.insert(types, type(args[i]))
	end
	local typename = args[#args]
	local operation = args[1]
	local message = string.format("incompatible type%s for %s %s: ", len == 1 and "" or "s", typename, operation)
	message = message .. prettyconcatination(types)
	error(message, 3)
end

common.istype = function(thing, types)
	local t = type(thing)
	for key, value in pairs(types) do
		if t == value then
			return true
		end
	end
	return false
end

common.anyoftype = function(...) -- pass type name as last argument
	local args = {...}
	local len = #args - 1
	local typename = table.remove(args)
	for i = 1, len do
		if type(args[i]) == typename then
			return true
		end
	end
	return false
end

common.alloftype = function(...) -- pass type name as last argument
	local args = {...}
	local len = #args - 1
	local typename = table.remove(args)
	for i = 1, len do
		if type(args[1]) ~= typename then
			return false
		end
	end
	return true
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
