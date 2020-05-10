import unittest, testRelease, types, strutils

suite "validateVersion":
    test "Returns true on a valid version":
        let res1 = validateVersion("major")
        let res2 = validateVersion("minor")
        let res3 = validateVersion("patch")
        require(res1)
        require(res2)
        require(res3)
    test "Returns false on a invalid version":
        let res1 = validateVersion("majorr")
        let res2 = validateVersion("")
        let res3 = validateVersion("123")
        require(res1 == false)
        require(res2 == false)
        require(res3 == false)

suite "bumpSemanticVersion":
    test "bumps major version":
        let res = bumpSemanticVersion("1.1.1", "major")
        require(res == "2.0.0")
    test "bumps minor version":
        let res = bumpSemanticVersion("1.1.1", "minor")
        require(res == "1.2.0")
    test "bumps patch version":
        let res = bumpSemanticVersion("1.0.0", "patch")
        require(res == "1.0.1")

suite "createCommandPlan":
    test "generates valid set of commands":
        let plan = createCommandPlan("minor", EmbarkConfig(
            writeVersionCommands: @[ "version cmd 1", "version cmd 2" ],
            readVersionCommand: "echo 1.0.0",
            preReleaseStart: @[ "pre start cmd 1" ],
            postReleaseStart: @[ "post start cmd 1" ],
            postReleaseFinish: @[ "post finish cmd 1" ]
        ))
        require("git checkout develop" in plan[0].command)
        require("git pull" in plan[1].command)
        require("git checkout -b release/1.1.0" in plan[2].command)
        require("pre start cmd 1" in plan[3].command)
        require("version cmd 1" in plan[4].command)
        require("version cmd 2" in plan[5].command)
        require("git add ." in plan[6].command)
        require("git commit -m" in plan[7].command)
        require("git push -u origin release/1.1.0" in plan[8].command)
        require("git checkout develop" in plan[9].command)
        require("post start cmd 1" in plan[10].command)

