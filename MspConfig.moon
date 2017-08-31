MspGlobals = require "MspGlobals"

import MODULE_PATH from MspGlobals
CONFIG_FILE = MODULE_PATH .. "config"

instance = nil

class MspConfig
  new: () =>
    oldValues = {}
    table.load(CONFIG_FILE, oldValues) if io.exists(CONFIG_FILE)
    @hideSoundLines = oldValues.hideSoundLines
    if @hideSoundLines == nil
      @hideSoundLines = true

  Save: () =>
    table.save(CONFIG_FILE, @)

  SetValue: (field, value) =>
    @[field] = value
    @\Save!

  @GetInstance: () =>
    return instance or @!
