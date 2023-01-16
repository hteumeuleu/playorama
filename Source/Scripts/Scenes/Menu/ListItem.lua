class('ListItem').extends()

-- ListItem
--
function ListItem:init(name, callback)

	ListItem.super.init(self)
	self.name = name
	self.callback = callback
	return self

end