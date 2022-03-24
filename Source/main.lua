import "CoreLibs/object"
import "Videorama"

function isVideo(fileName)
	local videoExtensionIndex = string.find(fileName, '.pdv')
	if videoExtensionIndex ~= nil then
		return true
	end
	return false
end

local files = playdate.file.listFiles()
for i, file in pairs(files) do
	if isVideo(file) == true then
		local video = Videorama(file)
		local thumb = video:getThumbnail()
		thumb:draw(0, 0)
		break
	end
end

function playdate.update()
end