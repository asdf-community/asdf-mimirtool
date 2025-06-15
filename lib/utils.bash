#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/grafana/mimir"
TOOL_NAME="mimirtool"
TOOL_TEST="mimirtool version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if mimirtool is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if mimirtool has other means of determining installable versions.
	list_github_tags | grep '^mimir-[0-9]\+[.][0-9]\+[.][0-9]' | sed 's/^mimir-//'
}

get_arch() {
	local machine
	machine=$(uname -m)

	if [[ "$machine" =~ "x86_64" ]]; then
		echo "amd64"
		return
	fi

	if [[ "$machine" =~ "aarch64" ]]; then
		echo "arm64"
		return
	fi

	echo $machine
}

get_platform() {
	local uname
	uname=$(uname)

	if [[ "$uname" =~ "Darwin" ]]; then
		echo "darwin"
		return
	fi

	if [[ "$uname" =~ "Linux" ]]; then
		echo "linux"
		return
	fi

	fail "Unknown platform"
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/releases/download/mimir-$version/mimirtool-$(get_platform)-$(get_arch)"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
	chmod +x "$filename"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-mimirtool supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
