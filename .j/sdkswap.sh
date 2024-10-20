#!/bin/bash

# Prints usage instructions and available versions
function print_usage() {
    CANDIDATE=$1
    # Get available versions and current version
    VERSIONS=$(\ls $SDKMAN_DIR/candidates/$CANDIDATE | \grep -v current | \awk -F'[.-]' '{ printf("%d.%d.%d\n", $1,$2,$3); }' | \sort -nr | \uniq)
    CURRENT_IDENTIFIER=$(\basename $(\readlink $SDKMAN_DIR/candidates/$CANDIDATE/current || \echo $SDKMAN_DIR/candidates/$CANDIDATE/current))
    CURRENT_VERSION=$(\echo $CURRENT_IDENTIFIER | \awk -F'[.-]' '{printf("%d.%d.%d\n", $1,$2,$3);}')
    # Print available versions, current version, and usage instructions
    \echo "Available versions for $CANDIDATE: "
    \echo "$VERSIONS"
    \echo "Current: $CURRENT_VERSION ($CURRENT_IDENTIFIER)"
    \echo "Usage: $0 $CANDIDATE <version>"
}

# Sorts version numbers in descending order
function version_sort() {
    \sort -t. -k 1,1nr -k 2,2nr -k 3,3nr
}

# Switches to a specific version of a candidate
function switch_version() {
    CANDIDATE=$1
    VERSION_NUMBER=$2
    # Find the identifier for the desired version
    IDENTIFIER=$(\ls $SDKMAN_DIR/candidates/$CANDIDATE | \grep -v current | \grep -E "^$VERSION_NUMBER(\.|$|-)" | version_sort | \head -n 1)
    # If the version was not found, print an error message and usage instructions
    if [ -z "$IDENTIFIER" ]; then
        \echo "Version not found"
         print_usage $CANDIDATE
    else
        # If the version was found, switch to that version
        sdk use $CANDIDATE $IDENTIFIER
    fi
}

# If there are exactly two arguments, switch to the specified version
# Otherwise, print usage instructions
if [[ $# -eq 2 ]]; then
  switch_version $1 $2
else
  print_usage $1
fi