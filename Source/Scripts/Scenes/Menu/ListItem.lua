class('ListItem').extends()

-- ListItem
--
function ListItem:init(name, callback, type)

	ListItem.super.init(self)
	self.name = name
	self.callback = callback
	self.type = type
	return self

end