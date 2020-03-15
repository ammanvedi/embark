import json, constants, types, strformat, sequtils, strutils

proc loadConfig*(locatiion: string = CONFIG_LOCATION): EmbarkConfig =
    try:
        let fileContent = readFile(locatiion)
        let parsed = parseJson(fileContent)
        return to(parsed, EmbarkConfig)
    except:
        return EmbarkConfig(postReleaseStart: @[], postReleaseFinish: @[])

proc applyModelToUserCommand*(command: string, model: UserCommandsModel): string =
    var finalCmd = command
    finalCmd = replace(finalCmd, "{{version}}", model.version)
    finalCmd = replace(finalCmd, "{{releaseBranch}}", model.releaseBranch)
    return finalCmd

proc generateUserCommand(userCommand: string, model: UserCommandsModel): Command =
    let userCommandTruncated = userCommand[0..10]
    
    return Command(
        command: applyModelToUserCommand(userCommand, model),
        descriptionMessage: fmt"Running user command ({userCommandTruncated}...)",
        successMessage: "User command exectuted",
        errorMessage: "Failed to execute user command"
    )

proc generateUserCommands*(commands: seq[string], model: UserCommandsModel): Commands =
    return map(
        commands,
        proc(cmd: string): Command =
            generateUserCommand(cmd, model) 
    )