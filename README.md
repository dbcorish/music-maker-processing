# Music Maker using Processing's Minim library
The aim of this project was to create an audio workstation complete with keyboard synthesiser, drum machine, guitar, backing tracks,
and the ability to record and play back microphone input.

I plan on implementing more instruments in future.

To open MusicMaker.pde, you will need to download Processing:
https://processing.org/download

You will also need to import the Minim library to Processing.

Sketch -> Import Library -> Add Library

## Features

The keyboard synthesiser functions using triangle oscillators and is controlled by the user’s key presses.
This synthesiser was originally programmed in Processing’s Sound library but, in the pursuit of a working recorder, was later recreated in Minim.

The drum machine uses four audio samples and is controlled by toggleable buttons.
If a button is switched on, it will trigger a sample when the beat marker passes over its column.

The guitar uses thirteen audio samples, sourced from www.compositiontoday.com/sound_bank/guitar/guitar.asp.
In order to play the guitar, a user must select a set of notes they wish to play and then click “strum”. This then plays back the notes that they have highlighted.
Audacity was used to go through and shorten the beginning of guitar samples to ensure that they play at the same time when strummed.

The backing track player simply plays song samples which I think sound good. The user operates it by clicking on the circle corresponding to their desired track.

The recorder records microphone input, stores it in the data folder as “recording.wav” then plays it back to the user.
