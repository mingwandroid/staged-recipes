#!/usr/bin/env sh

function _get_sourced_dirname() {
  if [ -n "${BASH_SOURCE[0]}" ]; then
    dirname "${BASH_SOURCE[0]}"
  elif [ -n "${(%):-%x}" ]; then
    # in zsh use prompt-style expansion to introspect the same information
    # see http://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
    dirname "${(%):-%x}"
  else
    # You are using some ancient shell, I can do no better than this!
    echo "${CONDA_PREFIX}"/bin
  fi
}

if [ -n "${JAVA_HOME}" ]; then
  "${JAVA_HOME}"/bin/java -jar "$(_get_sourced_dirname)"/java-config.jar "$@"
else
  java -jar "$(_get_sourced_dirname)"/java-config.jar "$@"
fi
