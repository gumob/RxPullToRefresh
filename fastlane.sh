#!/bin/bash

executeCommand () {
	cmd=$1
    echo
	echo "$ $cmd"
    echo
	eval $cmd
	echo
}

direnv allow
executeCommand "bundle exec fastlane"
