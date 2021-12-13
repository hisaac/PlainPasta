# https://github.com/casey/just

# Prints list of available recipes
default:
	@just --list

edit:
	#!/bin/bash
	if [ ! -d "Manifests.xcworkspace" ]; then
		tuist edit --permanent
	fi
	xed "Manifests.xcworkspace"

open:
	#!/bin/bash
	if [ ! -d "Plain Pasta.xcworkspace" ]; then
		just bootstrap
	fi
	xed "Plain Pasta.xcworkspace"

tuist:
	#!/bin/bash
	if ! command -v tuist &> /dev/null; then
		curl -Ls https://install.tuist.io | bash
	fi

dependencies:
	tuist dependencies fetch

generate:
	#!/bin/bash
	tuist generate

	# Setup local environment if defined
	if [ -d ".env" ]; then
		.env/setup.sh
	fi

bootstrap: tuist dependencies generate

clean:
	rm -rf Derived
	rm -rf "Manifests.xcodeproj"
	rm -rf "Manifests.xcworkspace"
	rm -rf "Plain Pasta.xcodeproj"
	rm -rf "Plain Pasta.xcworkspace"
	tuist dependencies clean
	tuist clean

nuke: clean
	rm -rf $HOME/Library/Developer/Xcode/DerivedData

reset: nuke bootstrap
