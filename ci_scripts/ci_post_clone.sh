#!/usr/bin/env bash

set -e

cd "$(dirname "$CI_PROJECT_FILE_PATH")"
.tuist-bin/tuist dependencies fetch
.tuist-bin/tuist generate

exit 0
