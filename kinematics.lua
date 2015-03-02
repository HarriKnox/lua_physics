local kinematics = {}
local common = require('common')

--[[
	x_f = x_i + (v)(t) + (a)(t)/2
	t = (-v +- (v^2 - 4(a)(d_x))^0.5) / 2(a)
	v_f = v_i + (a)(t)
	2(a)(d_x) = (v_f)^2 - (v_i)^2
	v_ave = (v_f - v_i) / 2
	a_ave = v_ave / t
--]]

kinematics.position = function(initialposition, initialvelocity, acceleration, timeelapsed)
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
		common.uniterror('position', initialposition, initialvelocity, acceleration, timeelapsed, 'kinematics')
	end
	common.typeerror('position', initialposition, initialvelocity, acceleration, timeelapsed, 'kinematics')
end

kinematics.velocity = function(initialvelocity, acceleration, timeelapsed)
	if type(timeelapsed) == 'quantity' and common.alloftype(initialvelocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local speed = units.meter / units.second
		local accel = speed / units.second
		if initialvelocity.units == speed and acceleration.units == accel and timeelapsed.units == units.second then
			return initialvelocity + (acceleration * timeelapsed)
		end
		common.uniterror('velocity', initialvelocity, acceleration, timeelapsed, 'kinematics')
	end
	common.typeerror('velocity', initialvelocity, acceleration, timeelapsed, 'kinematics')
end

kinematics.timeelapsed = function(deltax, velocity, acceleration)
	if common.alloftype(deltax, velocity, acceleration, {'quantity', 'vector'}) then
		local units = require('units')
		local speed = units.meter / units.second
		local accel = speed / units.second
		if delta_x.units == units.meter and velocity.units == speed and acceleration.units == accel then
			local discriminant = (velocity ^ 2) - (4 * acceleration * deltax)
			if discriminant < 0 then
				return nil
			elseif discriminant == 0 then
				return (-velocity) / (2 * acceleration)
			end
			local plus = ((-velocity) + math.sqrt(discriminant)) / (2 * acceleration)
			local minus = ((-velocity) - math.sqrt(discriminant)) / (2 * acceleration)
			return plus, minus
		end
		common.uniterror('timeelapsed', deltax, velocity, acceleration, 'kinematics')
	end
	common.typeerror('timeelapsed', deltax, velocity, acceleration, 'kinematics')
end

return kinematics