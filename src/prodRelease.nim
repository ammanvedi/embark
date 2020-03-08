import nre, constants, configLoader, types, strformat

proc versionIsValid(version: string): bool =
    return version.match(re"^[0-9]+\.[0-9]+\.[0-9]+$").isSome

proc createCommandPlan(version: string): Commands =

    let releaseBranch = fmt"release/{newVersion}"
    # checkout release branch 
    # pull release branch
    # checkout master
    # pull master
    # merge release branch into master
    # create tag on master
    # push master --follow-tags

    # create git release
    # create a pr to merge release branch into develop
    let baseCommands: seq[Command] = @[
        Command(
            command: "git pull",
            descriptionMessage: "Pulling latest code",
            successMessage: "Pulled latest code",
            errorMessage: "Failed to pull latest code"
        ),
        Command(
            command: fmt"git checkout {releaseBranch}",
            descriptionMessage: fmt"Checking out {releaseBranch}",
            successMessage: fmt"On branch {releaseBranch}",
            errorMessage: "Failed to check out release branch"
        ),
        Command(
            command: "git pull",
            descriptionMessage: "Pulling latest release code",
            successMessage: "Pulled latest release code",
            errorMessage: "Failed to pull latest release code"
        ),
        Command(
            command: "git checkout master",
            descriptionMessage: "Checking out master",
            successMessage: "On branch master",
            errorMessage: "Failed to check out master"
        ),
        Command(
            command: "git pull",
            descriptionMessage: "Pulling latest master code",
            successMessage: "Pulled latest master code",
            errorMessage: "Failed to pull latest master code"
        ),
        Command(
            command: fmt"git merge {releaseBranch}",
            descriptionMessage: "Merging release branch into master",
            successMessage: "Merged release branch into master",
            errorMessage: "Failed to merge release branch into master"
        ),
        Command(
            command: fmt"""git tag -a v{version} -m "release version v{version}" """,
            descriptionMessage: fmt"Creating tag v{version} on master",
            successMessage: "Created tag on master",
            errorMessage: "Failed to create tag on master"
        ),
        Command(
            command: "git push --follow-tags",
            descriptionMessage: "Pushing master to origin",
            successMessage: "Pushed master to origin",
            errorMessage: "Failed to push master to origin"
        ),
    ]

    # now get any commands specified by the user
    let userConfig: EmbarkConfig = loadConfig()
    let commandModel = UserCommandsModel(version: version, releaseBranch: releaseBranch)
    let extraCommands = generateUserCommands(userConfig.postReleaseStart, commandModel)

    return baseCommands & extraCommands

proc handleProdRelease*(version: string) =

    if versionIsValid(version) == false:
        echo SYNOPSIS
        return
    let commandPlan = createCommandPlan(version)
    echo commandPlan