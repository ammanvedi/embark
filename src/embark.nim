import 
    os,
    constants,
    checkCommands,
    prodRelease,
    testRelease

proc main(subcommand: string, param: string) =
    case subcommand
    of "test":
        handleTestRelease(param)
    of "prod":
        handleProdRelease(param)
    else:
        echo SYNOPSIS
try:
    if checkAllPrerequisites():
        main(paramStr(1), paramStr(2))
except:
    echo SYNOPSIS

# nim compile --run -o:./bin/embark src/embark.nim test major