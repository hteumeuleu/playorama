-- map(value, min1, max1, min2, max2)
--
function map(value, min1, max1, min2, max2)
	return (value - min1) / (max1 - min1) * (max2 - min2) + min2
end

-- split(s, delimiter)
--
function split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

-- padNumber(n)
--
function padNumber(n)
	if n < 10 then
		n = "0" .. n
	end
	return n
end

-- removeFormatting()
--
function removeFormatting(s)

	if type(s) == "string" then
		s = string.gsub(s, "*", "**")
		s = string.gsub(s, "_", "__")
	end
	return s

end