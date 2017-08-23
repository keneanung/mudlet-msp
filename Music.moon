Acoustics = require "Acoustics"

class Music extends Acoustics

  new: (completeSoundPath, properties) =>
    super(completeSoundPath, properties)

    @continue = @continue ~= "0" if @continue

  @argShortNamesToNames: (shortName) ->
    switch shortName
      when "C"
        "continue"
      else
        super.argShortNamesToNames(shortName)
