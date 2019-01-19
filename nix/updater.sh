#! /usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p curl jq nix

# TODO: we need a bunch of system tests/commands that are run to make sure
# that all environments are good after upgrade.
# TODO: stuff being gc-ed.. https://github.com/NixOS/nix/issues/2208
# http://datakurre.pandala.org/2015/10/nix-for-python-developers.html

# nix/updater.sh nix/nixpkgs.json nixpkgs nixos-18.09
# https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/

set -eufo pipefail

# Read in cmd line args
FILE=$1
PROJECT=$2
BRANCH=${3:-master}

# use jq to parse json file
OWNER=$(jq -r '.[$project].owner' --arg project "$PROJECT" < "$FILE")
REPO=$(jq -r '.[$project].repo' --arg project "$PROJECT" < "$FILE")
DATE=$(jq -r '.[$project].date' --arg project "$PROJECT" < "$FILE")

# Hit thte github api to get commit info
API_OUTPUT=$(curl "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH")
REV=$(echo $API_OUTPUT | jq -r '.commit.sha')
DATE=$(echo $API_OUTPUT | jq -r '.commit.commit.committer.date')

# Pull the commit and generate a sha
SHA256=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$REV.tar.gz")

# Update our File
TJQ=$(jq '.[$project] = {owner: $owner, repo: $repo, rev: $rev, sha256: $sha256, date: $date}' \
  --arg project "$PROJECT" \
  --arg owner "$OWNER" \
  --arg repo "$REPO" \
  --arg rev "$REV" \
  --arg sha256 "$SHA256" \
  --arg date "$DATE" \
  --arg branch "$BRANCH" \
  < "$FILE")
[[ $? == 0 ]] && echo "${TJQ}" >| "$FILE"
