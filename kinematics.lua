local kinematics = {}
local common = require('common')

--[[
--	x_f = x_i + (v)(t) + (a)(t^2)/2
	t = (-v +- (v^2 - 4(a/2)(d_x))^0.5) / 2(a/2)
	a = 2(d_x)/(t^2) - 2(v)/(t)
	v = (d_x/t) - (a)(t)/2
	
	v_f = v_i + (a)(t)
	a = d_v / t
	t = d_v / a
	
	2(a)(d_x) = (v_f)^2 - (v_i)^2
--	d_x = (v_f^2 - v_i^2)/2(a)
	a = (v_f^2 - v_i^2)/2(d_x)
	v_f = ((v_i^2) + 2(a)(d_x))^0.5
	v_i = ((v_f^2) - 2(a)(d_x))^0.5
--]]


kinematics.positionwithtime = function(initialposition, initialvelocity, acceleration, timeelapsed)
	if type(timeelapsed) == 'quantity' and common.alloftype(initialposition, initialvelocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local meter = units.meter
		local speed = meter / units.second
		local accel = speed / units.second
		if initialposition.units == meter and
				initialvelocity.units == speed and
				acceleration.units == accel and
				timeelapsed.units == units.second then
			return initialposition + (initialvelocity * timeelapsed) + (acceleration * (timeelapsed ^ 2) / 2)
		end
		common.uniterror('position with time', initialposition.units, initialvelocity.units, acceleration.units, timeelapsed.units, 'kinematics')
	end
	common.typeerror('position with time', initialposition, initialvelocity, acceleration, timeelapsed, 'kinematics')
end

kinematics.positionwithouttime = function(initialvelocity, finalvelocity, acceleration)
	if common.alloftype(initialvelocity, finalvelocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local speed = units.meter / units.second
		local accel = speed / units.second
		if initialvelocity.units == speed and finalvelocity.units == speed and acceleration.units == accel then
			return ((finalvelocity ^ 2) - (initialvelocity ^ 2)) / (2 * acceleration)
		end
		common.uniterror('position without time', initialvelocity.units, finalvelocity.units, acceleration.units, 'kinematics')
	end
	common.typeerror('position without time', initialvelocity, finalvelocity, acceleration, 'kinematics')
end

kinematics.velocity = function(initialvelocity, acceleration, timeelapsed)
	if type(timeelapsed) == 'quantity' and common.alloftype(initialvelocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local speed = units.meter / units.second
		local accel = speed / units.second
		if initialvelocity.units == speed and acceleration.units == accel and timeelapsed.units == units.second then
			return initialvelocity + (acceleration * timeelapsed)
		end
		common.uniterror('velocity', initialvelocity.units, acceleration.units, timeelapsed.units, 'kinematics')
	end
	common.typeerror('velocity', initialvelocity, acceleration, timeelapsed, 'kinematics')
end

kinematics.timeelapsed = function(deltax, velocity, acceleration)
	if common.alloftype(deltax, velocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local speed = units.meter / units.second
		local accel = speed / units.second
		if deltax.units == units.meter and velocity.units == speed and acceleration.units == accel then
			local discriminant = (velocity ^ 2) - (4 * (acceleration / 2) * deltax)
			if discriminant.value < 0 then
				return nil
			elseif discriminant.value == 0 then
				return (-velocity) / (2 * acceleration)
			end
			local plus = ((-velocity) + (discriminant ^ 0.5)) / (2 * (acceleration / 2))
			local minus = ((-velocity) - (discriminant ^ 0.5)) / (2 * (acceleration / 2))
			return plus, minus
		end
		common.uniterror('timeelapsed', deltax.units, velocity.units, acceleration.units, 'kinematics')
	end
	common.typeerror('timeelapsed', deltax, velocity, acceleration, 'kinematics')
end

return kinematics