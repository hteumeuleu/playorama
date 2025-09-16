class('MenuItem').extends()

-- MenuItem
--
function MenuItem:init(name, callback, type, value)

	MenuItem.super.init(self)
	self.name = name
	self.callback = callback
	self.type = type
	self.value = value
	return self

end
