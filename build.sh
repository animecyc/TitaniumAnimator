#!/bin/bash

# Copyright (c) 2015 Seth Benjamin
# All rights reserved.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

cTITLE=`tput bold; tput setaf 7`
cERROR=`tput bold; tput setaf 1`
cGREEN=`tput setaf 2`
cASIDE=`tput setaf 3`
cNONE=`tput sgr0`
MODULE_PLATFORM='none'

showHelp() {
  printf '\n'
  printf "  ${cTITLE}Usage:${cNONE} `basename ${0}` [options]\n\n"
  printf "  ${cTITLE}Options:${cNONE}\n"
  printf "    ${cGREEN}-p, --platform${cNONE}   Platform to build for ${cASIDE}[ios, android]${cNONE}\n"
  printf "    ${cGREEN}-h, --help${cNONE}       This help text\n"
  printf '\n'
  exit
}

for i in "$@"; do
  case $i in
    -p|--platform)
      MODULE_PLATFORM="$2"
      shift
      ;;
    -h|--help)
      showHelp
      ;;
  esac
  shift
done

if [[ ${MODULE_PLATFORM} == 'none' ]]; then
  showHelp
elif [[ ${MODULE_PLATFORM} != 'ios' && $MODULE_PLATFORM != 'android' ]]; then
  printf '\n'
  printf "  ${cERROR}Error:${cNONE} ${cASIDE}Invalid platform supplied. Must be one of \"ios\" or \"android\", please try again.${cNONE}\n"
  printf '\n'
  exit
elif [[ ${MODULE_PLATFORM} == 'ios' ]]; then
  MODULE_PLATFORM='iphone'
fi

MODULE_ID=''
MODULE_VERSION=''
MODULE_MANIFEST=`cat ${MODULE_PLATFORM}/manifest`

if [[ ${MODULE_MANIFEST} =~ moduleid:(.+) ]]; then
  MODULE_ID=`printf ${BASH_REMATCH[1]}`
fi

if [[ ${MODULE_MANIFEST} =~ version:(.+) ]]; then
  MODULE_VERSION=`printf ${BASH_REMATCH[1]}`
fi

if [[ ${MODULE_VERSION} == '' ]]; then
  printf '\n'
  printf "  ${cERROR}Error:${cNONE} ${cASIDE}Invalid module id detected.${cNONE}\n"
  printf '\n'
  exit
elif [[ ${MODULE_VERSION} == '' ]]; then
  printf '\n'
  printf "  ${cERROR}Error:${cNONE} ${cASIDE}Invalid module version detected.${cNONE}\n"
  printf '\n'
  exit
fi

MODULE_ZIP="${MODULE_ID}-${MODULE_PLATFORM}-${MODULE_VERSION}.zip"

buildModule() {
  if [[ ${MODULE_PLATFORM} == 'android' ]]; then
    ant -buildfile android/build.xml
  else
    python ./iphone/build.py
  fi
}

cleanHarness() {
  rm -rf ./harness/{build,modules}
}

prepareHarness() {
  cleanHarness

  if [[ ${MODULE_PLATFORM} == 'android' ]]; then
    unzip "android/dist/${MODULE_ZIP}" -d harness/
  else
    unzip "iphone/${MODULE_ZIP}" -d harness/
  fi

  cp -r harness/modules/${MODULE_PLATFORM}/${MODULE_ID}/${MODULE_VERSION}/example/* harness/Resources/
}

runHarness() {
  buildModule && prepareHarness && \
  ti build -p ${MODULE_PLATFORM} -d harness/ --retina
}

runHarness
