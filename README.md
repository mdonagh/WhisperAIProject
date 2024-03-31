# WhisperAIProject

WhisperAI is this extremely powerful speech-to-text transcription algorithm that you can run on your own computer - it doesn’t run in the cloud so you have great privacy.

They have different “model sizes” so it’s easy to change the model to balance CPU usage vs transcription quality - here I’m using medium.en (english)

I haven’t come up with some life-changing application for it yet, but the transcription accuracy is MUCH better than any of the competitors that I tested, such as Apple’s built-in Dictate tool or AWS’s cloud transcription.
It would be relatively simple to take what I have here and use it to transcribe all of our Engineering zoom meetings and post those somewhere.

Naturally there is some loss in audio crispness when the audio goes from
Zoom -> out computer speakers -> in computer speakers -> pass recording to WhisperAI

So I have experimented with something called “Black Hole” which allows Mac users to set up a “virtual sound output device” where you can intercept the system audio without having it go out the speaker and in the microphone

What this script does is use ffmpeg to record from the built-in mac speaker, and write that to a certain folder in 15-second increments.

Then, a second ruby script will watch that folder, and then transcribe all of the audios in that folder and then delete them.

The advantage of this is that the total file size of the folder never really exceeds 20MB - the transcription occurs slightly faster than the actual length of the audio files. So theoretically you could run this 24/7 and get a subtitle track to everything that happens in your office :-p

I fantasize about creating some kind of mobile app that hinges around this transcription technology - users could track diet, exercise, baby behavior, or really anything through simple transcription... Which in my opinion would be a simpler, more flexible user experience than a lot of other apps on the market including Apple’s Voice Memo.