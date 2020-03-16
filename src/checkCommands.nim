import os, constants

proc checkHubReady(): bool =
    return execShellCmd("hub --version &> /dev/null") == 0

proc checkAllPrerequisites*(): bool =
    if checkHubReady() == false:
        echo INSTALL_HUB
        return false
    return true