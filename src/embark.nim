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
    of "test":
        commandPlan = handleTestRelease(param)
    of "prod":
        commandPlan = handleProdRelease(param)
    else:
        echo SYNOPSIS
        return 

    writeCommandPlanToFile(commandPlan, ".embark.plan.log")

try:
    if checkAllPrerequisites():
        main(paramStr(1), paramStr(2))
except:
    echo SYNOPSIS

# nim compile --run -o:../bin/embark ../src/embark.nim prod 1.1.1