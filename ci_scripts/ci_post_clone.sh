#!/usr/bin/env zsh

set -e

$CI_PROJECT_FILE_PATH/.tuist-bin/tuist dependencies fetch
$CI_PROJECT_FILE_PATH/.tuist-bin/tuist generate
