#!/bin/bash

set -e

brew install just

# Get the full path of the folder containing this script so that we can construct relative paths
scripts_dir=$(cd -- "$(dirname "${0}")" >/dev/null 2>&1 ; pwd -P)

project_root=$(dirname "${scripts_dir}")
tuist_bin_dir="${project_root}/.tuist-bin"

rm -rf "${tuist_bin_dir}"
mkdir "${tuist_bin_dir}"

if [ -s "${project_root}/.tuist-version" ]; then
	read -r tuist_version < "${project_root}/.tuist-version"
	echo "Downloading Tuist ${tuist_version}"
	tuist_download_url="https://github.com/tuist/tuist/releases/download/${tuist_version}/tuist.zip"
else
	echo "Downloading the latest release of Tuist"
	tuist_download_url="https://github.com/tuist/tuist/releases/latest/download/tuist.zip"
fi

curl \
	--fail \
	--silent \
	--location \
	--show-error \
	--output "${tuist_bin_dir}/tuist.zip" \
	"${tuist_download_url}"

unzip "${tuist_bin_dir}/tuist.zip" -d "${tuist_bin_dir}"
rm "${tuist_bin_dir}/tuist.zip"

cd "${project_root}"
"${tuist_bin_dir}/tuist" dependencies fetch
"${tuist_bin_dir}/tuist" generate

exit 0
