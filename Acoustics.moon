require "lfs"
MspGlobals = require "MspGlobals"

import MODULE_PATH, OPERATING_SYSTEM_TYPE from MspGlobals

-- forward declare class, we'll need it
local Acoustics

-- default paramter values
DEFAULT_VOLUME  = 100
DEFAULT_REPEATS = 1

-- search for sound files
dosWildcardsToLuaPattern = (soundFile) ->
  suffix = soundFile\match("%.(%w+)$")
  if not suffix and not soundFile\find("%*$")
    soundFile = soundFile .. (soundType == "SOUND" and ".wav" or ".mid")
  for char in *{"^", "$", "(", ")", "%", ".", "[", "]", "+", "-"}
    soundFile = soundFile\gsub("%"..char, "%%"..(char == "%" and "%%" or char))
  return soundFile\gsub("%*", ".*")\gsub("%?", ".")

searchFiles = (where, pattern) ->
  filesFound = {}
  attributes = lfs.attributes(where\ends("/") and where\sub(1, -2) or where)
  if attributes and attributes.mode == "directory"
    for file in lfs.dir(where) do
      if file\match(pattern)
        filesFound[#filesFound + 1] = where .. file

  return filesFound

getSoundFiles = (completeSoundPath, soundType) ->
  soundPath = completeSoundPath\match("^(.*/)(.*)$") or ""
  soundFile = completeSoundPath\match("[^/]+$")

  soundFilePattern = dosWildcardsToLuaPattern(soundFile)

  return searchFiles(MODULE_PATH .. "sounds/" .. soundPath, soundFilePattern)

-- handle sound finish events
registerAnonymousEventHandler("sysSoundFinished", (_1, _2, soundFile) ->
    soundFile = soundFile\sub 2 if OPERATING_SYSTEM_TYPE == "windows" and soundFile\starts "/"
    soundObject = Acoustics.playingSoundFiles[soundFile]
    if soundObject
      Acoustics.playingSoundFiles[soundFile] = nil
      soundObject\FinishedPlaying!
)



-- class declaration
class Acoustics
  new: (completeSoundPath, properties={}) =>
    @completeSoundPath = completeSoundPath

    for argShortName, argValue in pairs(properties)
      if argName = @@.ArgShortNamesToNames argShortName
        self[argName] = argValue
      else
        print "MSP: server sent an unknown argument type: " .. argShortName

    if @volume
      @volume = tonumber(@volume) or DEFAULT_VOLUME
      if @volume < 0
        @volume = 0
      elseif @volume > 100
        @volume = 100
    else
      @volume = DEFAULT_VOLUME

    if @repeats
      @repeats = tonumber(@repeats) or DEFAULT_REPEATS
      @repeats = math.floor @repeats
      if @repeats < 1 and @repeats != -1
        @repeats = 1
    else
      @repeats = DEFAULT_REPEATS
    
    @url = @@defaultUrl if not @url and @@defaultUrl
    
    if @completeSoundPath != "Off"
      @files = getSoundFiles(@completeSoundPath, @soundType)
    else
      @@defaulUrl = @url if @url

  Play: =>
    fileToPlay = @files[math.random #@files]
    @@playingSoundFiles[fileToPlay] = @
    playSoundFile(fileToPlay, @volume) if @files and #@files > 0

  FinishedPlaying: =>
    @repeats -= 1 if @repeats != -1
    @\Play! if @repeats == -1 or @repeats > 0

  @playingSoundFiles = {}

  @ArgShortNamesToNames: (shortName) ->
    switch shortName
      when "V"
        "volume"
      when "L"
        "repeats"
      when "T"
        "type"
      when "U"
        "url"
      else
        nil
