package main

import (
	"flag"
	"fmt"
	"os"
)

type DockerConfig struct {
	imageName string
	tagFormat string
}

type EmbarkConfig struct {
	docker DockerConfig
}

func main() {
	versionPtr := flag.String("incrementVersion", "", "The version to increment (major | minor | patch)")

	flag.Parse()

	if *versionPtr == "" {
		os.Exit(1)
	}

	fmt.Printf("%s", *versionPtr)
}
