function padNumber(n)
	if n < 10 then
		n = "0" .. n
	end
	return n
end

function clamp(val, a, b)
	return math.max(a, math.min(b, val))
end


-- Converts a time value (in seconds)
-- to a string in the 'HH:MM' format. Maxes out at '99:99'.
function formatTime(seconds)

	local minutes = math.floor(seconds / 60)
	local seconds = math.floor(seconds % 60)
	if minutes > 99 then
		minutes = 99
	end
	if seconds > 59 then
		seconds = 59
	end
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	if seconds < 10 then
		seconds = '0' .. seconds
	end
	return minutes .. ':' .. seconds

end
