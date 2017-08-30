Acoustics = require "Acoustics"
Music = require "Music"
Sound = require "Sound"
MspGlobals = require "MspGlobals"

import MSP_TELNET_OPTION from MspGlobals

parseProperties = (propertiesString="") ->
  splitProperties = propertiesString\split(" ")

  properties = {}
  for prop in *splitProperties
    {key,value} = prop\split("=")
    properties[key] = value
  return properties

class MSP

  @Initialize: (telnetType, telnetOption) ->
    addSupportedTelnetOption(MSP_TELNET_OPTION)

  @SoundTrigger: (completeSoundPath, properties) ->
    with Sound(completeSoundPath, parseProperties(properties))
      \Play!

  @MusicTrigger: (completeSoundPath, properties) ->
    with Music(completeSoundPath, parseProperties(properties))
      \Play!
