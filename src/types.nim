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
    Command* = array[0..1, CommandDescription]
    Commands* = seq[Command]
   
type
    UserCommandsModel* = object
        version*: string
        releaseBranch*: string