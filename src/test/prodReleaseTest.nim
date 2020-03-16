import unittest, prodRelease, types, strutils

suite "versionIsValid":
    test "Returns false when version is invalid":
        let res1 = versionIsValid("1.2.3.4")
        let res2 = versionIsValid("a.2.3.4")
        let res3 = versionIsValid("1")
        let res4 = versionIsValid("1.2.3.")
        let res5 = versionIsValid("1.2")
        let res6 = versionIsValid("")
        require(res1 == false)
        require(res2 == false)
        require(res3 == false)
        require(res4 == false)
        require(res5 == false)
        require(res6 == false)
    test "Returns true when version is valid":
        let res1 = versionIsValid("1.2.3")
        let res2 = versionIsValid("0.1.0")
        let res3 = versionIsValid("00.11.999")
        require(res1)
        require(res2)
        require(res3)

suite "createCommandPlan":
    test "generates valid set of commands":
        let plan = createCommandPlan("1.0.0", EmbarkConfig(
            writeVersionCommands: @[ "version cmd 1", "version cmd 2" ],
            readVersionCommand: "echo 1.0.0",
            postReleaseStart: @[ "post start cmd 1" ],
            postReleaseFinish: @[ "post finish cmd 1" ]
        ))
        require("git pull" in plan[0].command)
        require("git checkout release/1.0.0" in plan[1].command)
        require("git pull" in plan[2].command)
        require("git checkout master" in plan[3].command)
        require("git pull" in plan[4].command)
        require("git merge release/1.0.0" in plan[5].command)
        require("git push" in plan[6].command)
        require("hub release create" in plan[7].command)
        require("git checkout release/1.0.0" in plan[8].command)
        require("hub pull-request" in plan[9].command)
        require("git checkout develop" in plan[10].command)
        require("post finish cmd 1" in plan[11].command)
        
        