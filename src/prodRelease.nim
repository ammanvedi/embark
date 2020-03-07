
proc handleProdRelease*(version: string) =
    echo version
    # validate semantic version format with a regex
    # check that the branch exists

    # checkout release branch 
    # pull release branch
    # checkout master
    # pull master
    # merge release branch into master
    # create tag on master
    # push master --follow-tags
    # create git release
    # create a pr to merge release branch into develop
