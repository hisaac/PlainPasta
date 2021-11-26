# https://github.com/casey/just

# Prints list of available recipes
default:
	@just --list

# Use ZSH to run commands
set shell := ["zsh", "-cu"]

edit:
	#!/usr/bin/env zsh
	if [ ! -d "Manifests.xcworkspace" ]; then
		tuist edit --permanent
	fi
	xed "Manifests.xcworkspace"

open:
	xed PlainPasta.xcworkspace

dependencies:
	tuist dependencies fetch

generate:
	tuist generate

bootstrap: dependencies generate

clean:
	rm -rf Derived
	rm -rf "Manifests.xcodeproj"
	rm -rf "Manifests.xcworkspace"
	rm -rf "PlainPasta.xcodeproj"
	rm -rf "PlainPasta.xcworkspace"
	tuist dependencies clean
	tuist clean

nuke: clean
	rm -rf $HOME/Library/Developer/Xcode/DerivedData

reset: nuke bootstrap
