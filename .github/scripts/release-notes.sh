#!/usr/bin/env bash
set -euo pipefail

version=${1:?Provide the package version.}
awk -v version="$version" '
  $0 == "## " version { found = 1 }
  found && /^## / && $0 != "## " version { exit }
  found { print }
  END {
    if (!found) {
      print "Missing changelog section for " version > "/dev/stderr"
      exit 1
    }
  }
' CHANGELOG.md
