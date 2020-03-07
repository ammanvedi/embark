import os, constants

proc checkGitFlowReady(): bool =
    return execShellCmd("git flow config &> /dev/null") == 0

proc checkNpmReady(): bool =
    return execShellCmd("npm -v &> /dev/null") == 0

proc checkPackageJSON(): bool =
    return execShellCmd("test -f package.json") == 0

proc checkAllPrerequisites*(): bool =
    if checkNpmReady() == false:
        echo INSTALL_NPM
        return false
    if checkPackageJSON() == false:
        echo NO_PACKAGE_JSON
        return false
    return true