import json, constants, types, strformat, sequtils, strutils

proc loadConfig*(): EmbarkConfig =
    try:
        let fileContent = readFile(CONFIG_LOCATION)
        let parsed = parseJson(fileContent)
        return to(parsed, EmbarkConfig)
    except:
        return EmbarkConfig(postReleaseStart: @[], postReleaseFinish: @[])

proc applyModelToUserCommand(command: string, model: UserCommandsModel): string =
    var finalCmd = command
    finalCmd = replace(finalCmd, "{{version}}", model.version)
    finalCmd = replace(finalCmd, "{{releaseBranch}}", model.releaseBranch)
    return finalCmd

proc generateUserCommand(userCommand: string, model: UserCommandsModel): Command =
    return [
        applyModelToUserCommand(userCommand, model),
        fmt"Running user command ({userCommand[0..10]}...)"
    ]

proc generateUserCommands*(commands: seq[string], model: UserCommandsModel): Commands =
    return map(
        commands,
        proc(cmd: string): Command =
            generateUserCommand(cmd, model) 
    )