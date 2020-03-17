  
<div align="center">
    <img align="center" src="https://i.imgur.com/rjy5WYy.png" alt="embark-logo" width="480"/>
</div>
<br />
<div align="center">Because you arent perfect and neither are your releases</div>
<br />
<div align="center">
  <img align="center" src="https://github.com/ammanvedi/embark/workflows/Build/badge.svg" />
  <img align="center" src="https://github.com/ammanvedi/embark/workflows/Build/badge.svg" />
</div>

## About

<div align="left">
    <img src="https://i.imgur.com/IvTOWU5.gif"/>
</div>


Embark is a command line tool for releasing new versions of code on github, it conforms to [git-flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) and handles;

1. Bumping versions
2. Creation of release branch
3. Creation of PR to merge release branch back into develop
4. Creating github release
5. Running custom commands at various points in deployment



## Aims

Releases will fail, something will fail merging, a timezone issue will cause your tests to fail at 4pm on a friday, your git credentials will bork themselves. The list is endless. Embark is designed so that when this happens it isnt the end of the world.

Embark generates an exact plan of what commands it will run <strong>before</strong> it begins to run them. It writes a file

`.embark.plan.log`

That contains all these commands, If something fails all you need to do is fix the failing command and run the remainder manually, Embark will tell you exactly where you tripped up and will also tell you how in the file;

`.embark.failure.log`



## Installation

```
brew tap ammanvedi/embark
brew install embark
```



## Usage

### Configuration

You will need to create a `embark.config.json` in the root of your project. In all the following commands you can interpolate

`{{version}}`- Will be replaced by the new version value

`{{releaseBranch}}`- Will be replaced by the new release branch



#### Options

`readVersionCommand` : `String` : `Required`

A shell command that will read your projects version from the filesystem

`writeVersionCommands` : `Array<String>` : `Required`

A set of commands that will be used to write the new version to the file system

`preReleaseStart` : `Array<String>` : `Required`

A set of custom commands to run before the first commit on the release branch. Normally this commit would just contain a version bump, but here you could do things like build binaries.

`postReleaseStart` : `Array<String>` : `Required`

A set cof commands to be run once the release branch has been completed

`postReleaseFinish` : `Array<String>` : `Required`

A set of commands to run once the release is complete and all changes are merged to the master branch



#### Examples

Here is an example config for an npm project

```json
{
    "readVersionCommand": "node -p \"require('./package.json').version\"",
    "writeVersionCommands": [
        "npm version {{version}} --no-git-tag-version"
    ],
  	"preReleaseStart": [
        "echo \"the release branch name is {{releaseBranch}}\"",
      	"echo \"new version is {{verison}}\""
    ],
    "postReleaseStart": [
        "echo \"the release branch name is {{releaseBranch}}\"",
      	"echo \"new version is {{verison}}\""
    ],
    "postReleaseFinish": [
        "echo \"the release branch name is {{releaseBranch}}\"",
      	"echo \"new version is {{verison}}\""
    ]
}
```

Or a project that just uses a text file for versioning

```json
{
    "readVersionCommand": "cat version.txt",
    "writeVersionCommands": [
        "printf \"%s\" \"{newVersion}\" > version.txt"
    ],
  	"preReleaseStart": [],
    "postReleaseStart": [],
    "postReleaseFinish": []
}
```



### Prerequisites

1. You should install [Hub](https://github.com/github/hub) and be able to run `hub pr list `without error
2. You should have a `master` and `develop` branch on your repository
3. A current version written to your filesystem in the format chosen in your config



### Commands

#### Start

```
embark start (major|minor|patch)
```

Begin a release by bumping the current project versions major minor or patch version and creating a new release branch for the release.

#### Finish

```
embark finish x.x.x
```

Finsh a release and merge changes to master, versions should be in the format `major.minor.patch`and you can only finish releases you have started



## Future Work

Here are some features id like to add to Embark

1. Make it independant of github, so you can choose where releases are created
2. Be able to checkpoint where a failure occurred and add a cli command to resume from that point