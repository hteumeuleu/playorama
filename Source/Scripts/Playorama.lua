class('Playorama').extends()

-- Playorama
--
function Playorama:init()

	Playorama.super.init(self)
	-- Init app settings for the Playdate
	self:initBackgroundDrawingCallback()
	playdate.setCrankSoundsDisabled(true)
	-- Init mask
	-- self:initMask()
	-- Init widgets
	self:initWidgets()
	-- Init library
	self:initLibrary()
	-- Init Carousel
	self:initCarousel()
	-- Init menu
	-- self:initMenu()
	return self

end

-- initMask()
--
function Playorama:initMask()

	local img = playdate.graphics.image.new(400, 240, playdate.graphics.kColorClear)
	playdate.graphics.pushContext(img)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		playdate.graphics.fillRect(0, 0, 400, 240)
		playdate.graphics.setColor(playdate.graphics.kColorClear)
		playdate.graphics.fillRoundRect(0, 0, 400, 240, 8)
	playdate.graphics.popContext()
	self.mask = playdate.graphics.sprite.new(img)
	self.mask:setCenter(0, 0)
	self.mask:moveTo(0, 0)
	self.mask:setZIndex(999)
	self.mask:setUpdatesEnabled(false)
	self.mask:add()

end

-- initWidgets()
--
function Playorama:initWidgets()

	-- TODO
	self.header = Header()

end

-- initLibrary()
--
function Playorama:initLibrary()

	self.library = Library()

end

-- initMenu()
--
function Playorama:initMenu()

	local homeList <const> = {
		ListItem("Videos", function()
			self.menu:push(ListView(self.library:toList("video")))
		end),
		ListItem("Extras", function() self.menu:goTo(3) end),
		ListItem("Settings", function()
			local settingsListArray = {
				ListItem("Foo", function()
					self.menu:goTo(1)
				end),
				ListItem("Bar", function()
					self.menu:goTo(2)
				end),
				ListItem("Baz", function()
					self.menu:goTo(3)
				end)
			}
			self.menu:push(ListView(List(settingsListArray)))
		end),
		ListItem("Sync", function()
			-- self.menu:goTo(5)
			-- Online sync
			if false then --playdate.simulator then
				-- Make request
				local url = "https://www.hteumeuleu.fr/wp-content/uploads/2023/05/kids.pdv"
				local urlContent = playdate.simulator.getURL(url)
				-- Write file locally
				local fileName = split(url, "/")
				fileName = fileName[#fileName]
				fileName = playdate.getSecondsSinceEpoch() .. '.pdv'
				local file = playdate.file.open(fileName, playdate.file.kFileWrite)
				file:write(urlContent)
				file:close()
				-- Add local file to library
				self.library:add(fileName)
			-- Local sync
			else
				local timeBefore = playdate.getSecondsSinceEpoch()

				-- Read original file and set up copy
				local fileName = "Assets/sample.pdv"
				local file = playdate.file.open(fileName, playdate.file.kFileRead)
				local copyName = playdate.getSecondsSinceEpoch() .. '.pdv'
				local copy = playdate.file.open(copyName, playdate.file.kFileWrite)

				-- Read and write data
				local size = playdate.file.getSize(fileName)
				local data = file:read(size)
				copy:write(data)

				-- Success!
				if file:tell() == copy:tell() then
					local timeAfter = playdate.getSecondsSinceEpoch()
					print("- ", fileName .. " successfully copied into " .. copyName .. " in ", timeAfter - timeBefore,  "ms.")
				end

				-- Close both files
				file:close()
				copy:close()

				-- Add local file to library
				self.library:add(copyName)
			end
		end),
	}
	local list <const> = List(homeList)
	self.menu = Menu(list)

end

-- initCarousel()
--
function Playorama:initCarousel()

	self.carousel = Carousel(self.library:toList("video"))

end

-- initBackgroundDrawingCallback()
--
-- Inits an empty drawing callback function to always draw a black background.
function Playorama:initBackgroundDrawingCallback()

	playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
	playdate.graphics.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
		end
	)

end