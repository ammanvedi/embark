import os

const COMMAND_NOT_FOUND_CODE = 127
const GIT_FLOW_EXISTS_COMMAND = ""

proc checkGitFlowReady(): bool =
    return execShellCmd("git flow config &> /dev/null") == 0

proc checkNpmReady(): bool =
    return execShellCmd("npm -v &> /dev/null") == 0

echo paramStr(1)
echo checkGitFlowReady()
echo checkNpmReady()

# nim compile --run embark.nim abc