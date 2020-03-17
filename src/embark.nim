import 
    os,
    constants,
    checkCommands,
    prodRelease,
    testRelease,
    types,
    checkpoints

proc main(subcommand: string, param: string) =

    var commandPlan: Commands = @[]

    case subcommand
    of "start":
        commandPlan = handleTestRelease(param)
    of "finish":
        commandPlan = handleProdRelease(param)
    else:
        echo SYNOPSIS
        return 

    writeCommandPlanToFile(commandPlan, PLAN_LOCATION)
    executeCommandPlan(commandPlan);

try:
    if checkAllPrerequisites():
        main(paramStr(1), paramStr(2))
except:
    raise