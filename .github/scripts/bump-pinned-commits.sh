#!/bin/bash
# Bump formulae pinned to a GitHub commit archive, for projects with no
# releases. A formula qualifies when its url is
#   https://github.com/OWNER/REPO/archive/<40-hex commit>.tar.gz
# and its head names a branch. When livecheck says it is outdated, repin
# url, version (commit date as YYYY.MM.DD) and sha256 to the newest commit
# on that branch.
#
# Usage: bump-pinned-commits.sh TAP           bump; print "name version" per bump
#        bump-pinned-commits.sh TAP --list    print names of pinned formulae
set -euo pipefail

tap="$1"
mode="${2:-bump}"
tap_dir="$(brew --repo "$tap")"
pinned_re='^https://github\.com/([^/]+/[^/]+)/archive/([0-9a-f]{40})\.tar\.gz$'

for file in "$tap_dir"/Formula/*.rb; do
  name="$(basename "$file" .rb)"
  url="$(sed -nE 's/^  url "([^"]+)".*/\1/p' "$file")"
  [[ "$url" =~ $pinned_re ]] || continue
  repo="${BASH_REMATCH[1]}"

  if [[ "$mode" == "--list" ]]; then
    echo "$name"
    continue
  fi

  branch="$(sed -nE 's/^  head ".*branch: "([^"]+)".*/\1/p' "$file")"
  if [[ -z "$branch" ]]; then
    echo "$name: pinned url but no head branch" >&2
    exit 1
  fi

  check="$(brew livecheck --json --formula "$tap/$name")"
  if jq -e '.[0].error' <<<"$check" >/dev/null; then
    echo "$name: livecheck failed: $(jq -r '.[0].messages // .[0].error | tostring' <<<"$check")" >&2
    exit 1
  fi
  echo "$name: $(jq -c '.[0].version' <<<"$check")" >&2
  [[ "$(jq -r '.[0].version.outdated' <<<"$check")" == "true" ]] || continue

  read -r commit date < <(gh api "repos/$repo/commits/$branch" --jq '.sha + " " + .commit.committer.date')
  version="$(tr - . <<<"${date:0:10}")"
  new_url="https://github.com/$repo/archive/$commit.tar.gz"
  sha256="$(curl -fsSL "$new_url" | shasum -a 256 | cut -d' ' -f1)"

  sed -i '' -E \
    -e "s|^  url \"[^\"]+\"|  url \"$new_url\"|" \
    -e "s|^  version \"[^\"]+\"|  version \"$version\"|" \
    -e "s|^  sha256 \"[^\"]+\"|  sha256 \"$sha256\"|" \
    "$file"
  echo "$name $version"
done
