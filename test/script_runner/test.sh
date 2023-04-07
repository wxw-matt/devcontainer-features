#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'color' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "color": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in the
# Feature's 'devcontainer-feature.json'.
# For the 'color' feature, that means the default favorite color is 'red'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
#
# This test can be run with the following command:
#
#    devcontainer features test    \
#               --features color   \
#               --remote-user root \
#               --skip-scenarios   \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#               /path/to/this/repo

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

CACHE_DIR="$HOME/.cache/scripts_cache"
mkdir -p $CACHE_DIR
function has_regular_files() {
    local directory="$1"
    local files=$(find "$directory" -type f)

    for file in $files; do
        if [ -f "$file" ]; then
            return 1
        fi
    done

    return 0
}

has_regular_files "$CACHE_DIR"
exit_code=$?
if [ $exit_code -eq 0 ]; then
    check "No file found if no scripts specified" true
else
    check "No file found if no scripts specified" false
fi

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
