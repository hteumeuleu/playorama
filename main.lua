import "CoreLibs/object"

function isVideo(fileName)
	local videoExtensionIndex = string.find(fileName, '.pdv')
	if videoExtensionIndex ~= nil then
		return true
	end
	return false
end

local kDataPath = './Data/'
local contextImage = playdate.graphics.image.new(400, 240, playdate.graphics.kColorBlack)
contextImage:drawScaled(10, 10, 0.5)

local files = playdate.file.listFiles(kDataPath)
for i, file in pairs(files) do
	if isVideo(file) == true then
		print(file)
		local filePath = kDataPath .. file
		local video = playdate.graphics.video.new(filePath)
		video:setContext(contextImage)
		local halfFrame = math.floor(video:getFrameCount() / 4)
		video:renderFrame(halfFrame)
		contextImage = contextImage:vcrPauseFilterImage()
		contextImage:drawScaled(10, 10, 0.5)
		break
	end
end

function playdate.update()
end