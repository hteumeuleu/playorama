import "Scripts/video/Video"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.video = {}

-- playorama.video.new(videoPath, [audioPath])
--
-- Constructor for a video.
playorama.video.new = function(videoPath, audioPath)

    local video = Video(videoPath, audioPath)
	if video ~= nil and video.error == nil then
        return video
    end
    if video.error ~= nil then
    	print(video.error)
    end
    return nil, video.error

end
