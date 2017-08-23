require "lfs"

dosWildcardsToLuaPattern = (soundFile) ->
  suffix = soundFile\match("%.(%w+)$")
  if not suffix and not soundFile\find("%*$")
    soundFile = soundFile .. (soundType == "SOUND" and ".wav" or ".mid")
  return soundFile\gsub("%.", "%%.")\gsub("%*", ".*")\gsub("%?", ".")

searchFiles = (where, pattern) ->
  filesFound = {}
  attributes = lfs.attributes(where)
  if attributes and attributes.mode == "directory"
    for file in lfs.dir(where) do
      if file\match(pattern)
        filesFound[#filesFound + 1] = file

  return filesFound


getSoundFiles = (completeSoundPath, soundType) ->
  soundPath = completeSoundPath\match("^(.*/)(.*)$") or ""
  soundFile = completeSoundPath\match("[^/]+$")

  soundFilePattern = dosWildcardsToLuaPattern(soundFile)

  return searchFiles(getMudletHomeDir() .. "msp/sounds/" .. soundPath, soundFilePattern)


class Acoustics
  new: (completeSoundPath, properties) =>
    @completeSoundPath = completeSoundPath
    
    for argShortName, argValue in pairs properties
      if argName = @@.argShortNamesToNames(argShortName)
        self[argName] = argValue
      else
        print "MSP: server sent an unknown argument type: " .. argShortName

    @continue = @continue ~= "0" if @continue
    
    @url = @@defaultUrl if not @url and @@defaultUrl
    
    if @completeSoundPath ~= "Off"
      @files = getSoundFiles(@completeSoundPath, @soundType)
    else
      @@defaulUrl if @url

  @argShortNamesToNames: (shortName) ->
    print(shortName)
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
