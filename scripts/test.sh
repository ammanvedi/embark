#!/bin/bash

mkdir bin || mkdir bin/test

# compile test files

nim compile -o:./bin/test/cptest --path=src/ src/test/checkpointsTest && \
nim compile -o:./bin/test/cltest --path=src/ src/test/configLoaderTest && \
nim compile -o:./bin/test/prtest --path=src/ src/test/prodReleaseTest && \
nim compile -o:./bin/test/trtest --path=src/ src/test/testReleaseTest 

# run test files checking for failure

if ./bin/test/cptest | grep 'Check failed'; then
  exit 1
fi

if ./bin/test/cltest | grep 'Check failed'; then
  exit 1
fi

if ./bin/test/prtest | grep 'Check failed'; then
  exit 1
fi

if ./bin/test/trtest | grep 'Check failed'; then
  exit 1
fi