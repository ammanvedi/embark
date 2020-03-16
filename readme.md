<img src="https://i.imgur.com/rjy5WYy.png" alt="embark-logo" width="480"/>



Text File Example

```json
{
    "readVersionCommand": "cat version.txt",
    "writeVersionCommands": [
        "printf \"%s\" \"{newVersion}\" > version.txt"
    ]
}
```



NPM / package.json Example

```json
{
    "readVersionCommand": "node -p \"require('./package.json').version\"",
    "writeVersionCommands": [
        "npm version {version} --no-git-tag-version"
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

