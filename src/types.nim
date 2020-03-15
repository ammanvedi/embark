type
    EmbarkConfig* = object
        postReleaseStart*: seq[string]
        postReleaseFinish*: seq[string]

type VersionBump* {.pure.} = enum
    Major = (0, "major"),
    Minor = (1, "minor"),
    Patch = (2, "patch")

type
    CommandDescription* = string
    Command* = object
        command*: string
        descriptionMessage*: string
        successMessage*: string
        errorMessage*: string
    Commands* = seq[Command]
   
type
    UserCommandsModel* = object
        version*: string
        releaseBranch*: string

type
    CommandResult* = object
        success*: bool
        output*: string
        outputError*: string

type
    ExecFunction* = proc (cmd: string): int