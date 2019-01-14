#! /usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p curl jq nix

# Update the nixpkgs.json file (commit and sha given the branch)
# FIXME: don't upgarde to nixos-18.09, aws command was broken..
# TODO: we need a bunch of system tests/commands that are run to make sure
# that all environments are good after upgrade.

# nix/updater.sh nix/nixpkgs.json nixpkgs nixos-18.03
# https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/

set -eufo pipefail

FILE=$1
PROJECT=$2
BRANCH=${3:-master}

OWNER=$(jq -r '.[$project].owner' --arg project "$PROJECT" < "$FILE")
REPO=$(jq -r '.[$project].repo' --arg project "$PROJECT" < "$FILE")
DATE=$(jq -r '.[$project].date' --arg project "$PROJECT" < "$FILE")

API_OUTPUT=$(curl "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH")
REV=$(echo $API_OUTPUT | jq -r '.commit.sha')
DATE=$(echo $API_OUTPUT | jq -r '.commit.commit.committer.date')

SHA256=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$REV.tar.gz")
TJQ=$(jq '.[$project] = {owner: $owner, repo: $repo, rev: $rev, sha256: $sha256, date: $date}' \
  --arg project "$PROJECT" \
  --arg owner "$OWNER" \
  --arg repo "$REPO" \
  --arg rev "$REV" \
  --arg sha256 "$SHA256" \
  --arg date "$DATE" \
  < "$FILE")
[[ $? == 0 ]] && echo "${TJQ}" >| "$FILE"
