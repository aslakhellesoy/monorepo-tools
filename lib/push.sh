#!/usr/bin/env bash

source `which monorepo-tools-common`

## output usage
usage () {
  echo "usage: push [dir]"
  return 0
}

## main
push () {
  local dir="${1:-.}"
  shift

  branch=$(git_branch)
  tag=$(git_tag)

  subrepos "${dir}" | while read subrepo; do
    pushd "${dir}" > /dev/null
    
    remote=$(subrepo_remote "${subrepo}")
    log "remote" ${remote}
    push_subrepo_branch "${subrepo}" "${branch}" "${remote}"
    
    if [ -z "${tag}" ]; then
      log "tags" "none"
    else
      push_subrepo_tag "${subrepo}" "${tag}" "${remote}"
    fi

    popd > /dev/null
  done

  return $?
}

push_subrepo_branch() {
  subrepo=$1
  branch=$2
  remote=$3
  
  pwd
  log "push_subrepo_branch" "${remote}#${branch}"
  git push --force "${remote}" $(splitsh-lite --prefix=${subrepo}):refs/heads/${branch}
}

push_subrepo_tag() {
  subrepo=$1
  tag=$2
  remote=$3

  log "pushing tag" "${tag} => ${remote}"
  git push --force "${remote}" $(splitsh-lite --prefix=${subrepo} --origin=refs/tags/${tag}):refs/tags/${tag}
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f push
else
  push "${@}"
  exit $?
fi