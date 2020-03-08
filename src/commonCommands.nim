import types, strformat

proc checkoutBranch*(branch: string): Command =
    return Command(
        command: fmt"git checkout {branch}",
        descriptionMessage: fmt"Checking out {branch}",
        successMessage: fmt"On branch {branch}",
        errorMessage: "Failed to check out {branch}"
    )

proc gitPull*(): Command =
    return Command(
        command: "git pull",
        descriptionMessage: "Pulling latest code",
        successMessage: "Pulled latest code",
        errorMessage: "Failed to pull latest code"
    )