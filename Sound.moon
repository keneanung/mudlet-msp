Acoustics = require "Acoustics"

class Sound extends Acoustics

  @argShortNamesToNames: (shortName) ->
    switch shortName
      when "P"
        "priority"
      else
        super.argShortNamesToNames(shortName)
