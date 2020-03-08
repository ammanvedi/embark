import strformat, types, sequtils

proc getPlanLinesFromCommand(command: Command): seq[string] =
    return @[
        fmt"# {command.descriptionMessage}",
        command.command,
        ""
    ]

proc writeCommandPlanToFile*(plan: Commands, fileName: string) =
    let commandsLinesList: seq[seq[string]] = map(plan, getPlanLinesFromCommand)
    let f = open(fileName, fmWrite)
    defer: f.close()

    for commandLines in commandsLinesList:
        for line in commandLines:
            f.writeLine(line)
