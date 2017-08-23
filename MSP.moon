Acoustics = require "Acoustics"
Music = require "Music"
Sound = require "Sound"

playAcoustics = (cls, ...) ->
  with cls(...)
    \Play!

class MSP

  @Initialize: () ->
    -- register telnet option 90

  @SoundTrigger: (completeSoundPath, properties) ->
    playAcoustics(Sound, completeSoundPath, properties)
  
  @MusicTrigger: (completeSoundPath, properties) ->
    playAcoustics(Music, completeSoundPath, properties)