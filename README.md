![Playorama](/Source/SystemAssets/card.png)

# A cranky video player for the Playdate

Playorama is a _cranky_ video player for the Playdate. You can use the crank to fast forward and backward through a video.

## 1. How to use

*Warning*: The app is still very rough around the edges and the process to get your own videos on the Playdate is a bit clunky. There’s a demo video included in the application if you’re not at ease with encoding video and audio.

### 1.1. Controls

While a video is playing, you can use the following controls.

* `A`: pause
* `B`: menu
* `Up`: toggle track bar
* `Right`: play at 1x speed
* `Left`: play at -1x speed
* `Crank`: change playback speed up to 4x 

### 1.2. Download and install

1. Download the latest release at https://github.com/hteumeuleu/playorama/releases .
2. Get the `playorama.pdx` file.
3. Sideload it to your Playdate device. (You can refer to the official [Sideloading Playdate games](https://help.play.date/games/sideloading/) documentation.)

### 1.3. Add videos

1. Connect your Playdate to your computer in [Data Disk mode](https://help.play.date/games/sideloading/#data-disk-mode).
2. In the main `Data` folder, create a `com.hteumeuleu.playorama` folder.
3. Add your video and audio files inside. Both files should have the same base name (for example: `sample.pdv` and `sample.pda`).

### 1.4. Sample videos

You can download the following videos to try it out.

_(Coming soon!)_

Download an archive and extract it in the application data folder (See `1.3.` above.).

### 1.5. Encode your own videos

#### Using the online Playdate Video Encoder

1. Go to [pdv.hteumeuleu.com](https://pdv.hteumeuleu.com/).
2. Use the web app to encode your video. You will only get a `.pdv` file for the video.
3. Use another software like _ffmpeg_ to export the audio as an `.mp3`.

#### Using 1bitvideo on macOS

1. Download `1bitvideo.app` the video encoder made by Panic’s Dave Hayden: [https://devforum.play.date/t/video-encoder-work-in-progress-mac-only/1390/6](https://devforum.play.date/t/video-encoder-work-in-progress-mac-only/1390/6). 
2. Use the app to encode your video. When done, you will get both a `.pdv` and a `.m4a` file. The Playdate can not read an `.m4a` from a data folder, so we need to encode the audio into `.pda`.
3. Encode the audio into MP3. The Playdate SDK documentation provides indication into how to do this using either _Audacity_ or _ffmpeg_: [https://sdk.play.date/1.11.1/Inside%20Playdate.html#f-sound.getSampleRate](https://sdk.play.date/1.11.1/Inside%20Playdate.html#f-sound.getSampleRate).

## 2. Source Code

You can compile the code with the following command:

```sh
pdc ./Source/ Playorama.pdx
```
