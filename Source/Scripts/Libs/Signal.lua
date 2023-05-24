import "CoreLibs/object"

-- Signal Class by Dustin Mierau
-- https://devforum.play.date/t/a-list-of-helpful-libraries-and-code/221/3
class("Signal").extends()

function Signal:init()
	self.listeners = {}
end

function Signal:subscribe(key, bind, fn)
	local t = self.listeners[key]
	local v = {fn = fn, bind = bind}
	if not t then
		self.listeners[key] = {v}
	else
		t[#t + 1] = v
	end
end

function Signal:unsubscribe(key, fn)
	local t = self.listeners[key]
	if t then
		for i, v in ipairs(t) do
			if v.fn == fn then
				table.remove(t, i)
				break
			end
		end
		if #t == 0 then
			self.listeners[key] = nil
		end
	end
end

function Signal:notify(key, ...)
	local t = self.listeners[key]
	if t then
		for _, v in ipairs(t) do
			v.fn(v.bind, key, ...)
		end
	end
end