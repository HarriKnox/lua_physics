local kinematics = {}
local common = require('common')

kinematics.position = function(initialposition, initialvelocity, acceleration, timeelapsed)
	if common.alloftype(initialposition, initialvelocity, acceleration, timeelapsed, 'quantity') then
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
		error("Incompatable types", 2)
	end
	common.typeerror('position', initialposition, initialvelocity, acceleration, timeelapsed, 'kinematics')
end

return kinematics