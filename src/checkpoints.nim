import strformat, types, sequtils, osproc, streams, logging, constants

proc getPlanLinesFromCommand*(command: Command): seq[string] =
    return @[
        fmt"# {command.descriptionMessage}",
        command.command,
        ""
    ]

proc writeCommandPlanToFile*(plan: Commands, fileName: string) =
    let commandsLinesList: seq[seq[string]] = map(plan, getPlanLinesFromCommand)
    let f = open(fileName, fmWrite)
    defer: f.close()

    for i, commandLines in commandsLinesList:
        f.writeLine(fmt"# Command {i+1} of {len(commandsLinesList)}")
        for line in commandLines:
            f.writeLine(line)

proc runCommand*(command: Command): CommandResult =
    let p = startProcess(command.command, options={poUsePath, poEvalCommand})
    var sout = p.outputStream()
    var eout = p.errorStream()
    let exitCode = p.waitForExit(10000)
    let output = sout.readAll()
    let outputError = eout.readAll()
    return CommandResult(
        success: exitCode == 0,
        output: output,
        outputError: outputError
    )

proc executeCommandPlan*(commands: Commands) =
    for i in 0..(len(commands) - 1):
        let command = commands[i]
        logStatus(fmt"Command {i+1} of {len(commands)}", true, false)
        logInfo(command.descriptionMessage, true, false)
        let commandResult = runCommand(command)
        if commandResult.success == false:
            logError(command.errorMessage, true, false)
            echo ""
            logError(
                fmt"Command {i+1} of {len(commands)} failed",
                true,
                false
            )
            
            logError(
                fmt"you should perform manually steps remaining in {PLAN_LOCATION}",
                true,
                false
            )
            # write failure to log
            let f = open(FAIL_LOG_LOCATION, fmWrite)
            f.writeLine("# Error from command:")
            f.writeLine(fmt"# {command.command}")
            f.writeLine("")
            f.writeLine(commandResult.outputError)
            f.close()
            return
        else:
            logSuccess(command.successMessage, true, true)
        echo ""
    logSuccess("All commands executed 🚀", true, false)
