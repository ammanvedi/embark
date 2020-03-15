import unittest, configLoader, types

suite "loadConfig":
    test "Returns an empty config when file doesnt exist":
        let res = loadConfig("./non-existent-file.json")
        require(len(res.postReleaseStart) == 0)
        require(len(res.postReleaseFinish) == 0)
    test "returns correct config data when file exists":
        let res = loadConfig("./test-env/config.embark.json")
        require(len(res.postReleaseStart) == 4)
        require(len(res.postReleaseFinish) == 4)


suite "applyModelToUserCommand":
    let model = UserCommandsModel(
        version: "myRelease",
        releaseBranch: "myReleaseBranch"
    )
    test "applies {{version}} transformation":
        let res = applyModelToUserCommand("runme {{version}}", model)
        require(res == "runme myRelease")

    test "applies {{releaseBranch}} transformation":
        let res = applyModelToUserCommand("runme {{releaseBranch}}", model)
        require(res == "runme myReleaseBranch")