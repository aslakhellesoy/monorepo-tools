#!/usr/bin/env bash

## Log <type> <msg>
log () {
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" $1 $2
}

## abort
abort () {
  printf "\n  \033[31mError: $@\033[0m\n\n" && exit 1
}

subrepos() {
  dir=$1
  pushd "${dir}" > /dev/null
  git ls-files | grep "\.subrepo" | xargs -n 1 dirname
  popd > /dev/null
}

# Prints the remote (git URL) of a subrepo
subrepo_remote() {
  dir=$1
  pushd "${dir}" > /dev/null
  suffix=$(cat .subrepo).git
  if [ -z "${GITHUB_TOKEN}" ]; then
    echo "git@github.com:${suffix}"
  else
    echo "https://${GITHUB_TOKEN}@github.com/${suffix}"
  fi
  popd > /dev/null
}

git_tag() {
  dir=$1
  pushd "${dir}" > /dev/null
  if [ -z "${TRAVIS_TAG}" ]; then
    git describe --exact-match --tags $(git log -n1 --pretty='%h') 2> /dev/null | tr '\n' ' '
  else
    echo "${TRAVIS_TAG}"
  fi
  popd > /dev/null
}

git_branch() {
  dir=$1
  pushd "${dir}" > /dev/null
  if [ -z "${TRAVIS_BRANCH}" ]; then
    git rev-parse --abbrev-ref HEAD | tr '\n' ' '
  else
    echo "${TRAVIS_BRANCH}"
  fi
  popd > /dev/null
}


## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  # TODO: read config from monotools.json
  
  # export GH_API_URL=${GH_API_URL:=https://api.github.com}
  # export GH_AUTH_URL=${GH_AUTH_URL:-${GH_API_URL}/user}
  # export GH_DIR="${GH_DIR:-${HOME}/.gh}"
  # export GH_TOKEN_PATH="${GH_TOKEN_PATH:-${GH_DIR}/token}"
  # export GH_TOKEN="${GH_TOKEN:-$(
  #   test -f ${GH_TOKEN_PATH} && cat ${GH_TOKEN_PATH} | head -n1
  # )}"
  export log
  export abort
  export subrepos
fi