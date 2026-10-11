#!/usr/bin/env bash
set -euo pipefail

lane=${1:?Provide the target release lane (main or dev).}
package=$(awk '$1 == "name:" {print $2}' pubspec.yaml)
version=$(awk '$1 == "version:" {print $2}' pubspec.yaml)

if [[ "$package" != "string_search_algorithms" ]]; then
  echo "Unexpected package name: $package" >&2
  exit 1
fi
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid package version: $version" >&2
  exit 1
fi
prerelease=${BASH_REMATCH[1]:-}
case "$lane" in
  main)
    if [[ -n "$prerelease" ]]; then
      echo "Main requires a stable version." >&2
      exit 1
    fi
    ;;
  dev)
    if [[ -z "$prerelease" ]]; then
      echo "Dev requires a prerelease version." >&2
      exit 1
    fi
    ;;
  *)
    echo "Unsupported release lane: $lane" >&2
    exit 1
    ;;
esac

printf 'package=%s\nversion=%s\ntag=%s-v%s\n' "$package" "$version" "$package" "$version"
