local kinematics = {}
local common = require('common')

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
		if initialvelocity.units == speed and acceleration.units = accel and timeelapsed.units == units.second then
			return initialvelocity + (acceleration * timeelapsed)
		end
		common.uniterror('velocity', initialvelocity, acceleration, timeelapsed, 'kinematics')
	end
	common.typeerror('velocity', initialvelocity, acceleration, timeelapsed, 'kinematics')
end

return kinematics