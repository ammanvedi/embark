import strformat

const VERSION* = "1.0.0"

const CONFIG_LOCATION* = "config.embark.json"

const SYNOPSIS* = fmt"""

Embark CLI v{VERSION}

Usage: 

embark test (major|minor|patch)     Create a new major minor or patch release
embark prod x.x.x                   Complete a previously created major minor or patch release

Specify configs in a config.embark.json file in the
root of your repository and run the embark command in the
same directory

Make sure you have npm, git flow and docker cli commands installed

"""

const INSTALL_DOCKER* = """

It looks like you dont have the Docker CLI installed

You can find instructions on how to install this here
https://docs.docker.com/install/

"""

const INSTALL_NPM* = """

It looks like you dont have the npm CLI installed

You can find instructions on how to install this here
https://www.npmjs.com/get-npm

"""

const INSTALL_GIT_FLOW* = """

It looks like there is a problem with git flow

You can find instructions on how to install this here
https://github.com/nvie/gitflow/wiki/Installation

Also make sure you have run git flow init in your repo

"""

const NO_PACKAGE_JSON* = """

It looks like you dont have a package.json file in the 
current directory, Embark is made to work with javascript
packages that are supported by a package.json file

Perhaps you need to run

npm init

in this directory

"""