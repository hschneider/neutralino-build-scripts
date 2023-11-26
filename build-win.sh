#!/bin/bash
#
# build-win.sh 1.0.0
#
# Windows build script for NeutralinoJS
#
# Call:
# ./build-win
#
# Requirements:
# brew install jq 
#
# (c)2023 Harald Schneider - marketmix.com

VERSION='1.0.0'

echo
echo -e "\033[1mNeutralino BuildScript for Windows platform, version ${VERSION}\033[0m"

CONF=./neutralino.config.json

if [ ! -e "./${CONF}" ]; then
    echo
    echo -e "\033[31m\033[1mERROR: ${CONF} not found.\033[0m"
    exit 1
fi

if ! jq -e '.buildScript | has("win")' "${CONF}" > /dev/null; then
    echo
    echo -e "\033[31m\033[1mERROR: Missing buildScript JSON structure in ${CONF}\033[0m"
    exit 1
fi

APP_ARCH_LIST=($(jq -r '.buildScript.win.architecture[]' ${CONF}))
APP_BINARY=$(jq -r '.cli.binaryName' ${CONF})
APP_NAME=$(jq -r '.buildScript.win.appName' ${CONF})

echo
echo -e "\033[1mBuilding Neutralino Apps ...\033[0m"
rm -rf "./dist/${APP_BINARY}"
neu build
echo -e "\033[1mDone.\033[0m"

for APP_ARCH in "${APP_ARCH_LIST[@]}"; do

    APP_DST=./dist/win_${APP_ARCH}
 
    EXE=./dist/${APP_BINARY}/${APP_BINARY}-win_${APP_ARCH}.exe
    RES=./dist/${APP_BINARY}/resources.neu
    EXT=./dist/${APP_BINARY}/extensions

    echo 
    echo -e "\033[1mBuilding App Bundle (${APP_ARCH}):\033[0m"
    echo
    echo "  App Name:      ${APP_NAME}"
    echo "  Target Folder: ${APP_DST}"
    echo

    if [ ! -e "./${EXE}" ]; then
        echo -e "\033[31m\033[1m  ERROR: Binary file not found: ${EXE}\033[0m"
        exit 1
    fi

    if [ ! -e "./${RES}" ]; then
        echo -e "\033[31m\033[1m  ERROR: Resource file not found: ${RES}\033[0m"
        exit 1
    fi

    echo "  Creating target folder ..."
    mkdir -p "${APP_DST}"
    
    echo "  Copying App-Content:"
    echo "    - Binary File"
    cp "${EXE}" "${APP_DST}/${APP_NAME}"
    echo "    - Resources"
    cp "${RES}" "${APP_DST}/"

    if [ -e "./${EXT}" ]; then
        echo "    - Extensions"
        cp -r "${EXT}" "${APP_DST}/"
    fi

    if [ -e "./postproc-win.sh" ]; then
        echo "  Running post-processor ..."
        . postproc-win.sh
    fi

    echo
    echo -e "\033[1mBuild finished.\033[0m"
done

echo 
echo -e "\033[1mAll done.\033[0m"
