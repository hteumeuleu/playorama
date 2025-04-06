NOTES
---

This document is like a Game Design Document and serves to note down everything I’d like to do with Playorama.

## TODO

[] Add an icon for “on cartridge” videos.

## Playorama 2.0

* **Play**:
* **Settings**:
	- About: Videos, Capacity, Available, Version
	- Audio: Menu Music and SFX (On/Off) 
	- Language
* **Sync**:
	- Allow saving videos from “the cartridge” to disk.
	- Add an icon to differentiate videos “on disk” versus “on cartridge”.
	- Update the default “Capacity” settings.
* **Camera**:
	- Add sync streaming with Playorama.app.
	- Record streaming.

## Playorama.app

* **Play**:
	- Add a proper list of pre-encoded 1bit videos available for download and online viewing.
* **Encode**:
	- Add Bayer dithering.
	- Add a threshold slider.
	- Rewrite code for dither effects, exports, etc. to mutualize it better with the stream page.
* **Stream**:
	- Add sync streaming with Playorama.

--- 

# Archive

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
