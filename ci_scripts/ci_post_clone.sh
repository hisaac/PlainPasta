#!/usr/bin/env/ zsh

set -e

brew upgrade
brew install just

just bootstrap
