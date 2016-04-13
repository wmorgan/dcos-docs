#!/usr/bin/env bash

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"

function reindex() {
  #echo "> $(pwd)"
  for i in */; do
    if [ "${i}" == "*/" ]; then
      # current dir has no subdirs
      continue
    fi
    local subdir="${i%%/}"
    if [[ -L "${subdir}" ]]; then
      # subdirs is a symlink
      continue
    fi
    if [[ -f "${subdir}.md" ]]; then
      echo "${subdir}.md -> ${subdir}/index.md"
      git mv "${subdir}.md" "${subdir}/index.md"
    fi
    cd "${subdir}"
    reindex
    cd ".."
  done
}

cd "${REPO_ROOT}/latest"
reindex
