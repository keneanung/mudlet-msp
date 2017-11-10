Acoustics = require "Acoustics"

class Sound extends Acoustics

  @ArgShortNamesToNames: (shortName) ->
    switch shortName
      when "P"
        "priority"
      else
        super.ArgShortNamesToNames shortName
