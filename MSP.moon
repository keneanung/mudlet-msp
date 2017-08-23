Acoustics = require "Acoustics"
Music = require "Music"
Sound = require "Sound"

MSP_TELNET_OPTION  = 90

playAcoustics = (cls, ...) ->
  with cls(...)
    \Play!

class MSP

  @Initialize: (telnetType, telnetOption) ->
    addSupportedTelnetOption(MSP_TELNET_OPTION)

  @SoundTrigger: (completeSoundPath, properties) ->
    playAcoustics(Sound, completeSoundPath, properties)

  @MusicTrigger: (completeSoundPath, properties) ->
    playAcoustics(Music, completeSoundPath, properties)