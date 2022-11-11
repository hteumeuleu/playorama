import "Scene"
import "Header"
import "List"
import "ListItem"
import "ListView"

class('Menu').extends('Scene')

-- Menu
--
function Menu:init(list)

	Menu.super.init(self)
	self.header = Header()
	if list == nil or list.className ~= "List" then
		local homeList = {
			ListItem("Music", function() self:goTo(1) end),
			ListItem("Videos", function()
				self:push(ListView(lib:toList()))
			end),
			ListItem("Extras", function() self:goTo(3) end),
			ListItem("Settings", function()
				local settingsListArray = {
					ListItem("Foo", function()
						self:goTo(1)
					end),
					ListItem("Bar", function()
						self:goTo(2)
					end),
					ListItem("Baz", function()
						self:goTo(3)
					end)
				}
				self:push(ListView(List(settingsListArray)))
			end),
			ListItem("Foo", function() self:goTo(5) end),
			ListItem("Bar", function() self:goTo(6) end),
			ListItem("Baz", function() self:goTo(7) end),
			ListItem("Bim", function() self:goTo(7) end),
			ListItem("Bam", function() self:goTo(7) end),
			ListItem("Boom", function() self:goTo(7) end),
		}
		list = List(homeList)
	end
	self.listview = ListView(list)
	self.history = {}
	self:addSprite(self.header)
	self:addSprite(self.listview)
	self:setInputHandlers()
	return self

end

-- setInputHandlers()
--
function Menu:setInputHandlers()

	local myInputHandlers = {
		AButtonUp = function()
			self.listview:doSelectionCallback()
		end,
		BButtonUp = function()
			self:pop()
		end,
		upButtonUp = function()
			self.listview:up()
		end,
		downButtonUp = function()
			self.listview:down()
		end,
	}
	playdate.inputHandlers.push(myInputHandlers, true)

end

-- goTo()
--
function Menu:goTo(i)

	print(i)

end

-- push()
--
function Menu:push(newListView)

	table.insert(self.history, self.listview)
	self:removeSprite(self.listview)
	self.listview = newListView
	self:addSprite(self.listview)

end

-- pop()
--
function Menu:pop()

	if #self.history > 0 then
		local newListView = table.remove(self.history)
		self:removeSprite(self.listview)
		self.listview = newListView
		self:addSprite(self.listview)
	end

end