import constants, strformat, strutils, configLoader, types, commonCommands, logging, checkpoints

proc validateVersion*(version: string): bool =
    return 
        version == $VersionBump.Major or
        version == $VersionBump.Minor or
        version == $VersionBump.Patch

proc bumpSemanticVersion*(version: string, bump: string): string =
    let versionComponents = version.split('.')
    let versionBump = parseEnum[VersionBump](bump)
    var newVersion = versionComponents

    # Bump the version using int attached to enum as index to edit
    let toBump = parseInt(newVersion[versionBump.int])
    newVersion[versionBump.int] = intToStr(toBump + 1)

    return join(newVersion, ".")

proc createCommandPlan*(version: string, userConfig: EmbarkConfig): Commands =

    let readVersionCommand = Command(
        command: userConfig.readVersionCommand,
        descriptionMessage: fmt"Reading current version from filesystem",
        successMessage: fmt"Read current version from file system",
        errorMessage: fmt"Could not read current version from file system check readVersionCommand in config"
    )

    logInfo(readVersionCommand.descriptionMessage, true, false)

    let currentVersionResult = runCommand(readVersionCommand)

    if (currentVersionResult.success == false):
        logError(readVersionCommand.errorMessage, true, false)
        return 

    logSuccess(readVersionCommand.successMessage, true, false)
    let currentVersion = currentVersionResult.output
    let newVersion = bumpSemanticVersion(currentVersion, version)
    let releaseBranch = fmt"release/{newVersion}"
    let commandModel = UserCommandsModel(version: newVersion, releaseBranch: releaseBranch)

    let preWriteVersionCommands = @[
        checkoutBranch(BRANCH_DEVELOP),
        gitPull(),
        Command(
            command: fmt"git checkout -b {releaseBranch}",
            descriptionMessage: fmt"Creating release branch ({releaseBranch})",
            successMessage: fmt"Created release branch {releaseBranch}",
            errorMessage: fmt"Could not create release branch {releaseBranch}"
        ),
    ]

    let postWriteVersionCommands = @[
        Command(
            command: fmt"""git add .""",
            descriptionMessage: "Staging package.json",
            successMessage: "Staged package.json",
            errorMessage: "Failed to stage package.json"
        ),
        Command(
            command: fmt"""git commit -m "[release] {newVersion} package version bump"""",
            descriptionMessage: "Committing package.json change",
            successMessage: "Committed package.json change",
            errorMessage: "Failed to commit package json change"
        ),
        Command(
            command: fmt"git push -u origin {releaseBranch}",
            descriptionMessage: "Pushing release branch to origin",
            successMessage: "Release branch pushed to origin",
            errorMessage: fmt"Failed to push branch {releaseBranch} to origin"
        ),
        checkoutBranch(BRANCH_DEVELOP)
    ]

    let writeVersionCommands = generateUserCommands(userConfig.writeVersionCommands, commandModel)
    let extraCommands = generateUserCommands(userConfig.postReleaseStart, commandModel)

    return preWriteVersionCommands & writeVersionCommands & postWriteVersionCommands & extraCommands

proc handleTestRelease*(version: string): Commands =
    if validateVersion(version) == false:
        echo SYNOPSIS
    else:
        let userConfig: EmbarkConfig = loadConfig()
        return createCommandPlan(version, userConfig)
    
