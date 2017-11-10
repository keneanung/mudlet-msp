class MspGlobals
  @MODULE_PATH = getMudletHomeDir()\gsub("\\", "/") .. "/msp/"
  @MSP_TELNET_OPTION = 90
  @OPERATING_SYSTEM_TYPE = package.config\sub(1,1) == "\\" and "windows" or "unix"
