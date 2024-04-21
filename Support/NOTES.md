NOTES
---

playorama.ui
playorama.player
playorama.library

playorama.video.new(videoPath, [audioPath]) ✅
playorama.video:update() 
playorama.video:play()
playorama.video:pause()
playorama.video:stop()
playorama.video:flush() ✅
playorama.video:isPlaying() ✅
playorama.video:setVolume() ✅
playorama.video:setRate() ✅
playorama.video:getRate() ✅
playorama.video:hasAudio() ✅
playorama.video:checkAudioExtension(ext) ✅
playorama.video:canPlayBackwards() ✅
playorama.video:getLength() ✅
playorama.video:getOffset() ✅
playorama.video:setOffset() ✅
playorama.video:getMetaData() ✅

# Old functions

getTotalTime() -> getLength
getCurrentTime() -> getOffset
isFFing() -> ui
getDisplayName() -> getMetaData
getDisplayRate() -> getRate + ui
hasAudio() -> ✅
hasAudioExtension() -> checkAudioExtension
canPlayBackwards() -> ✅
getLastModifiedTimestamp() -> getMetaData
mute() -> setVolume
unmute() -> setVolume
getThumbnail() -> getMetaData
togglePause() -> pause() + play()
increaseRate() -> setRate()
decreaseRate() -> setRate()
setRate() -> setRate()
getRate() -> getRate()
isPaused() -> isPlaying()
toggleRate(dir) -> setRate()
setContext() -> 🚫
getContext() -> 🚫
setFrame() -> 🚫
draw() -> 🚫
load() -> 🚫
unload() -> flush()
