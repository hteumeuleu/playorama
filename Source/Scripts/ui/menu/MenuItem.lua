class('MenuItem').extends()

-- MenuItem
--
function MenuItem:init(name, callback, type)

	MenuItem.super.init(self)
	self.name = name
	self.callback = callback
	self.type = type
	return self

end
