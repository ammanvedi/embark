import constants, strformat, json, strutils, configLoader, types, commonCommands

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
        checkoutBranch(BRANCH_DEVELOP),
        gitPull(),
        Command(
            command: fmt"git checkout -b {releaseBranch} --quiet",
            descriptionMessage: fmt"Creating release branch ({releaseBranch})",
            successMessage: fmt"Created release branch {releaseBranch}",
            errorMessage: fmt"Could not create release branch {releaseBranch}"
        ),
        Command(
            command: fmt"npm version {newVersion} --no-git-tag-version &> /dev/null",
            descriptionMessage: fmt"Bumping package.json version to {newVersion}",
            successMessage: fmt"Bumped package version to {newVersion}",
            errorMessage: fmt"Failed to bump package version {newVersion}"
        ),
        Command(
            command: fmt"""git add . &> /dev/null""",
            descriptionMessage: "Staging package.json",
            successMessage: "Staged package.json",
            errorMessage: "Failed to stage package.json"
        ),
        Command(
            command: fmt"""git commit -m "[release] {newVersion} package version bump" --quiet""",
            descriptionMessage: "Committing package.json change",
            successMessage: "Committed package.json change",
            errorMessage: "Failed to commit package json change"
        ),
        Command(
            command: fmt"git push -u origin {releaseBranch} --quiet",
            descriptionMessage: "Pushing release branch to origin",
            successMessage: "Release branch pushed to origin",
            errorMessage: fmt"Failed to push branch {releaseBranch} to origin"
        ),
        checkoutBranch(BRANCH_DEVELOP)
    ]

    # now get any commands specified by the user
    let userConfig: EmbarkConfig = loadConfig()
    let commandModel = UserCommandsModel(version: newVersion, releaseBranch: releaseBranch)
    let extraCommands = generateUserCommands(userConfig.postReleaseStart, commandModel)

    return baseCommands & extraCommands

proc handleTestRelease*(version: string): Commands =
    if validateVerison(version) == false:
        echo SYNOPSIS
    else:
        return createCommandPlan(version)
    
