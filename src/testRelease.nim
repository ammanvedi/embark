import constants, strformat, json, strutils, parseutils, configLoader, types

proc validateVerison(version: string): bool =
    return 
        version == $VersionBump.Major or
        version == $VersionBump.Minor or
        version == $VersionBump.Patch

proc readVersionFromPackageJSON(): string =
    let packageText = readFile("package.json")
    let packageJSON = parseJson(packageText)
    let version = packageJSON["version"].getStr()
    return version

proc bumpSemanticVersion(version: string, bump: string): string =
    let versionComponents = version.split('.')
    let versionBump = parseEnum[VersionBump](bump)
    var newVersion = versionComponents

    # Bump the version using int attached to enum as index to edit
    let toBump = parseInt(newVersion[versionBump.int])
    newVersion[versionBump.int] = intToStr(toBump + 1)

    return join(newVersion, ".")


proc createCommandPlan(version: string): Commands =
    let currentVersion = readVersionFromPackageJSON()
    let newVersion = bumpSemanticVersion(currentVersion, version)
    let releaseBranch = fmt"release/{newVersion}"

    var baseCommands = @[
        [
            "git checkout develop",
            "Checking out develop"
        ],
        [
            "git pull",
            "Pulling latest code"
        ],
        [
            fmt"git checkout -b {releaseBranch}",
            fmt"Creating release branch ({releaseBranch})"
        ],
        [
            fmt"npm version {newVersion} --no-git-tag-version",
            fmt"Bumping package.json version to {newVersion}"
        ],
        [
            fmt"""git commit -m "[release] Bump package version" """",
            "Committing package.json change"
        ],
        [
            fmt"git push -u origin {releaseBranch}",
            "Pushing release branch to origin"
        ]
    ]

    # now get any commands specified by the user
    let userConfig: EmbarkConfig = loadConfig()
    let commandModel = UserCommandsModel(version: newVersion, releaseBranch: releaseBranch)
    let extraCommands = generateUserCommands(userConfig.postReleaseStart, commandModel)

    return baseCommands & extraCommands

proc handleTestRelease*(version: string) =
    if validateVerison(version) == false:
        echo SYNOPSIS
    else:
        let commandPlan = createCommandPlan(version)
        echo commandPlan
    
