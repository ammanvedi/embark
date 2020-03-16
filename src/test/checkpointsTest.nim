import unittest, types, checkpoints, strformat


suite "getPlanLinesFromCommand":
    test "Returns correct lines":
        let command = Command(
            command: "myCommand",
            descriptionMessage: "myDescription",
            successMessage: "successMessage",
            errorMessage: "errorMessage"
        )
        let result = getPlanLinesFromCommand(command)
        require(result[0] == fmt"# {command.descriptionMessage}")
        require(result[1] == command.command)
        require(result[2] == "")

suite "writeCommandPlanToFile":
    test "Writes file with commands correctly":
        let command = Command(
            command: "myCommandOne",
            descriptionMessage: "myDescription",
            successMessage: "successMessage",
            errorMessage: "errorMessage"
        )
        let commandTwo = Command(
            command: "myCommandTwo",
            descriptionMessage: "myDescription",
            successMessage: "successMessage",
            errorMessage: "errorMessage"
        )
        let plan = @[command, commandTwo]
        writeCommandPlanToFile(plan, "./testplan.sh")
        let written = readFile("./testplan.sh")
        let expected = "# Command 1 of 2\n# myDescription\nmyCommandOne\n\n# Command 2 of 2\n# myDescription\nmyCommandTwo\n\n"
        require(written == expected)
    
suite "runCommand":
    test "returns correctly for a failing command":
        let failingCommand = Command(
            command: "which thiscommanddoesntexist",
            descriptionMessage: "myDescription",
            successMessage: "successMessage",
            errorMessage: "errorMessage"
        )
        let res = runCommand(failingCommand)
        require(res.success == false)
        require(len(res.output) == 0)
    test "returns correctly for a successful command":
        let failingCommand = Command(
            command: "echo abc",
            descriptionMessage: "myDescription",
            successMessage: "successMessage",
            errorMessage: "errorMessage"
        )
        let res = runCommand(failingCommand)
        require(res.success == true)
        require(res.output == "abc\n")
        require(len(res.outputError) == 0)