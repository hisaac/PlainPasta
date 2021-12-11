#!/usr/bin/env bash

set -e

project_root=$(dirname $CI_PROJECT_FILE_PATH)

$project_root/.tuist-bin/tuist dependencies fetch
$project_root/.tuist-bin/tuist generate

exit 0
