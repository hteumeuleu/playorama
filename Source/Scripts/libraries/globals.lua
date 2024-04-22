function padNumber(n)
	if n < 10 then
		n = "0" .. n
	end
	return n
end

function clamp(val, a, b)
	return math.max(a, math.min(b, val))
end
