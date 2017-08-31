Acoustics = require "Acoustics"
Music = require "Music"
Sound = require "Sound"
MspGlobals = require "MspGlobals"
MspConfig = require "MspConfig"

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
    deleteLine! if MspConfig\GetInstance!.hideSoundLines
    with Sound(completeSoundPath, parseProperties(properties))
      \Play!

  @MusicTrigger: (completeSoundPath, properties) ->
    deleteLine! if MspConfig\GetInstance!.hideSoundLines
    with Music(completeSoundPath, parseProperties(properties))
      \Play!

  @ConfigureLineHiding: (newStringValue) ->
    newValue = newStringValue\lower!\starts("y")
    MspConfig\GetInstance!\SetValue("hideSoundLines", newValue)
    cecho("<green>MSP<reset>: <red>Will#{newValue and "" or " not"}<reset> hide Sound trigger lines.")
