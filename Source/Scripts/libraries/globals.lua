function padNumber(n)
	if n < 10 then
		n = "0" .. n
	end
	return n
end

function clamp(val, a, b)
	return math.max(a, math.min(b, val))
end

-- removeFormatting(text)
--
-- Removes bold and italic Markdown formatting from `text`.
-- Ideally, we should use `gfx.font:drawText()` to prevent any formatting.
-- But `gfx.drawText()` provides more useful features (like truncation).
function removeFormatting(text)

	if type(text) == "string" then
		text = string.gsub(text, "*", "**")
		text = string.gsub(text, "_", "__")
	end
	return text

end

-- map(value, min1, max1, min2, max2)
--
function map(value, min1, max1, min2, max2)
	return (value - min1) / (max1 - min1) * (max2 - min2) + min2
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
