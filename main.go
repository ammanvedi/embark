package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
)

type DockerConfig struct {
	imageName string
	tagFormat string
}

type EmbarkConfig struct {
	docker DockerConfig
}

func checkCommandExists(command string) bool {
	cmd := exec.Command(command)
	stdout, err := cmd.Output()

	if err != nil {
		return false
	}

	if len(stdout) > 0 {
		return true
	}

	return false
}

const (
	versionMajor = "major"
	versionMinor = "minor"
	versionPatch = "patch"
)

func validateVersionBump(arg string) bool {
	switch arg {
	case
		versionPatch,
		versionMinor,
		versionMajor:
		return true
	}
	return false
}

func validateVersionNumber(arg string) bool {
	matched, _ := regexp.MatchString(`^[0-9]+\.[0-9]+\.[0-9]+$`, arg)
	return matched
}

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Error: release (test (major|minor|patch)|prod (version))")
		os.Exit(1)
	}

	switch os.Args[1] {

	case "release":
		switch os.Args[2] {
		case "test":
			if !validateVersionBump(os.Args[3]) {
				fmt.Printf("Error: Version to bump required (major|minor|patch)\n")
				os.Exit(1)
			}
		case "prod":
			if !validateVersionNumber(os.Args[3]) {
				fmt.Printf("Error: Version number required in x.x.x format\n")
				os.Exit(1)
			}
		}
	}
}
