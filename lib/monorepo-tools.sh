#!/usr/bin/env bash

source `which monorepo-tools-common`

## monorepo-tools version
VERSION="0.0.1"

## output usage
usage () {
  echo "usage: monorepo-tools [-hV] <command> [args]"
}

## main
monorepo_tools() {
  local arg=""
  local cmd=""

  ## parse opts
  case "${1}" in

    ## flags
    -V|--version)
      log version "${VERSION}"
      return 0
      ;;

    -h|--help)
      usage
      return 0
      ;;

    *)
      if [ -z "${1}" ]; then
        usage
        return 1
      fi

      ## aliases
      case "${1}" in
        auth)
          arg="authorization"
          ;;

        *)
          arg="${1}"
      esac

      cmd="monorepo-tools-${arg}"
      shift
      if type -f "${cmd}" > /dev/null 2>&1; then
        "${cmd}" "${@}"
        return $?
      else
        return 1
      fi
      ;;
  esac
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f monorepo_tools
else
  monorepo_tools "${@}"
  exit $?
fi
