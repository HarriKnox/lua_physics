local vector = {}

vector.add = function(first, second)
	return {
		x = first.x + second.x,
		y = first.y + second.y,
		z = first.z + second.z
	}
end