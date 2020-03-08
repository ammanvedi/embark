import strformat, types, sequtils, osproc, streams

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

proc runCommand*(command: Command): CommandResult =
    let p = startProcess(command.command, options={poUsePath, poEvalCommand})
    var sout = p.outputStream()
    let exitCode = p.waitForExit(10000)
    let output = sout.readAll()

    return CommandResult(
        success: exitCode == 0,
        output: output
    )

proc executeCommandPlan*(commands: Commands) =
    for i in 0..(len(commands) - 1):
        let command = commands[i]
        echo command.descriptionMessage
        let commandResult = runCommand(command)
        if commandResult.success == false:
            echo command.errorMessage
        else:
            echo command.successMessage
