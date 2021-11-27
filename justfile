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
	#!/usr/bin/env zsh
	if [ ! -d "PlainPasta.xcworkspace" ]; then
		just bootstrap
	fi
	xed PlainPasta.xcworkspace

tuist:
	#!/usr/bin/env zsh
	if ! command -v tuist &> /dev/null; then
		curl -Ls https://install.tuist.io | bash
	fi

carthage:
	#!/usr/bin/env zsh
	if ! command -v carthage &> /dev/null; then
		brew install carthage
	fi

dependencies:
	tuist dependencies fetch

generate:
	tuist generate

bootstrap: carthage tuist dependencies generate

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
