import "Scripts/audio/Audio"

local pd <const> = playdate
local gfx <const> = pd.graphics

playorama = playorama or {}
playorama.audio = {}

-- playorama.audio.new(audioPath)
--
-- Constructor for an audio.
playorama.audio.new = function(audioPath)

    local audio = Audio(audioPath)
	if audio ~= nil and audio.error == nil then
        return audio
    end
    if audio.error ~= nil then
    	print(audio.error)
    end
    return nil, audio.error

end
