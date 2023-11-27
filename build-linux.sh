#!/bin/bash
#
# build-linux.sh
#
# Linux build script for NeutralinoJS
#
# Call:
# ./build-linux
#
# Requirements:
# brew install jq 
#
# (c)2023 Harald Schneider - marketmix.com

VERSION='1.0.0'

echo
echo -e "\033[1mNeutralino BuildScript for Linux platform, version ${VERSION}\033[0m"

CONF=./neutralino.config.json

if [ ! -e "./${CONF}" ]; then
    echo
    echo -e "\033[31m\033[1mERROR: ${CONF} not found.\033[0m"
    exit 1
fi

if ! jq -e '.buildScript | has("linux")' "${CONF}" > /dev/null; then
    echo
    echo -e "\033[31m\033[1mERROR: Missing buildScript JSON structure in ${CONF}\033[0m"
    exit 1
fi

APP_ARCH_LIST=($(jq -r '.buildScript.linux.architecture[]' ${CONF}))
APP_VERSION=$(jq -r '.version' ${CONF})
APP_BINARY=$(jq -r '.cli.binaryName' ${CONF})
APP_NAME=$(jq -r '.buildScript.linux.appName' ${CONF})
APP_ICON=$(jq -r '.buildScript.linux.appIcon' ${CONF})
APP_ICON_LOCATION=$(jq -r '.buildScript.linux.appIconLocation' ${CONF})

APP_SRC=./_app_scaffolds/linux/myapp.desktop

if [ ! -e "./${APP_SRC}" ]; then
    echo
    echo -e "\033[31m\033[1mERROR: App scaffold not found: ${APP_SRC}\033[0m"
    exit 1
fi

echo
echo -e "\033[1mBuilding Neutralino Apps ...\033[0m"
rm -rf "./dist/${APP_BINARY}"
neu build
echo -e "\033[1mDone.\033[0m"

for APP_ARCH in "${APP_ARCH_LIST[@]}"; do

    APP_DST=./dist/linux_${APP_ARCH}/${APP_NAME}

    EXE=./dist/${APP_BINARY}/${APP_BINARY}-linux_${APP_ARCH}
    RES=./dist/${APP_BINARY}/resources.neu
    EXT=./dist/${APP_BINARY}/extensions

    echo 
    echo -e "\033[1mBuilding App Bundle (${APP_ARCH}):\033[0m"
    echo
    echo "  App Name:           ${APP_NAME}"
    echo "  Icon:               ${APP_ICON}"
    echo "  Icon Install Path:  ${APP_ICON_LOCATION}"
    echo "  Target Folder:      ${APP_DST}"
    echo

    if [ ! -e "./${EXE}" ]; then
        echo -e "\033[31m\033[1m  ERROR: File not found: ${EXE}\033[0m"
        exit 1
    fi

    if [ ! -e "./${RES}" ]; then
        echo -e "\033[31m\033[1m  ERROR: Resource file not found: ${RES}\033[0m"
        exit 1
    fi

    echo "  Cloning App-Scaffold ..."
    mkdir -p "${APP_DST}"
    cp "${APP_SRC}" "${APP_DST}/${APP_NAME}.desktop"

    echo "  Copying App-Content:"
    echo "    - Binary File"
    cp "${EXE}" "${APP_DST}/"
    echo "    - Resources"
    cp "${RES}" "${APP_DST}/"

    if [ -e "./${EXT}" ]; then
        echo "    - Extensions"
        cp -r "${EXT}" "${APP_DST}/"
    fi

    if [ -e "./${APP_ICON}" ]; then
        echo "    - Icon"
        cp -r "${APP_ICON}" "${APP_DST}/"
    fi

    echo "  Processing Desktop File ..."
    sed -i '' "s/{APP_NAME}/${APP_NAME}/g" "${APP_DST}/${APP_NAME}.desktop"
    sed -i '' "s|{APP_ICON_LOCATION}|${APP_ICON_LOCATION}|g" "${APP_DST}/${APP_NAME}.desktop"


    if [ -e "./postproc-linux.sh" ]; then
        echo "  Running post-processor ..."
        . postproc-linux.sh
    fi

    echo
    echo -e "\033[1mBuild finished.\033[0m"
done

echo
echo -e "\033[1mI propose the following paths for your installer:\033[0m"
echo
echo "  Application Folder: /usr/share/${APP_NAME}"
echo "  Application Icon:   ${APP_ICON_LOCATION}"
echo "  Desktop File:       /usr/share/applications/${APP_NAME}.desktop"
echo
echo "If you change the Application Icon's path, you have to adapt its path in the .desktop file."

echo 
echo -e "\033[1mAll done.\033[0m"
