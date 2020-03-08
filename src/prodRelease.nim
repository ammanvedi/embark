import nre, constants, configLoader, types, strformat, commonCommands

proc versionIsValid(version: string): bool =
    return version.match(re"^[0-9]+\.[0-9]+\.[0-9]+$").isSome

proc createDevPRTitle(version: string): string =
    return fmt"Merge Release v{version} Into Develop"

proc createDevPRBody(version: string): string =
    return fmt"Merges changes from release branch for v{version} into develop"

proc createReleaseTitle(releaseTag: string): string =
    return releaseTag

proc createReleaseBody(releaseTag: string): string =
    return fmt"Release {releaseTag}"

proc createCommandPlan(version: string): Commands =

    let releaseBranch = fmt"release/{version}"
    let releaseTag = fmt"v{version}"

    let baseCommands: seq[Command] = @[
        gitPull(),
        checkoutBranch(releaseBranch),
        gitPull(),
        checkoutBranch(BRANCH_MASTER),
        gitPull(),
        Command(
            command: fmt"git merge {releaseBranch} --theirs --quiet",
            descriptionMessage: fmt"Merging release branch into {BRANCH_MASTER}",
            successMessage: fmt"Merged release branch into {BRANCH_MASTER}",
            errorMessage: fmt"Failed to merge release branch into {BRANCH_MASTER}"
        ),
        Command(
            command: "git push --follow-tags --quiet",
            descriptionMessage: fmt"Pushing {BRANCH_MASTER} to origin",
            successMessage: fmt"Pushed {BRANCH_MASTER} to origin",
            errorMessage: fmt"Failed to push {BRANCH_MASTER} to origin"
        ),
        Command(
            command: fmt"""hub release create -t master --message "{createReleaseTitle(releaseTag)}" --message "{createReleaseBody(releaseTag)}" {releaseTag}""",
            descriptionMessage: fmt"Creating release {releaseTag}",
            successMessage: fmt"Created release {releaseTag}",
            errorMessage: fmt"Failed to create release {releaseTag}"
        ),
        checkoutBranch(releaseBranch),
        Command(
            command: fmt"""hub pull-request -b develop --message "{createDevPRTitle(version)}" --message "{createDevPRBody(version)}"""",
            descriptionMessage: fmt"Creating pull request to add changes to develop",
            successMessage: fmt"Created pull request to merge changes into develop",
            errorMessage: "Failed to create pull request to merge changes into develop"
        ),
        checkoutBranch(BRANCH_DEVELOP)
    ]

    # now get any commands specified by the user
    let userConfig: EmbarkConfig = loadConfig()
    let commandModel = UserCommandsModel(version: version, releaseBranch: releaseBranch)
    let extraCommands = generateUserCommands(userConfig.postReleaseStart, commandModel)

    return baseCommands & extraCommands

proc handleProdRelease*(version: string): Commands =

    if versionIsValid(version) == false:
        echo SYNOPSIS
    else:
        return createCommandPlan(version)