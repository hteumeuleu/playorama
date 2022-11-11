class('List').extends()

-- List
--
function List:init(listItemsArray)

	List.super.init(self)
	self.items = listItemsArray
	return self

end