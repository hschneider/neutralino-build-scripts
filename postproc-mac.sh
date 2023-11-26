#!/bin/bash
#
# postproc-mac.sh 1.0.0
#
# macOS build script post-processor.
#
# This is called from build-mac.sh after each app-bundle has been built.
# Use this e.g. to copy additional resources to the app-bundle.
# You can use all variables from the main script here.
#
# (c)2023 Harald Schneider - marketmix.com

if [ $APP_ARCH = "x64" ]; then
    :   
    # Handle Intel releases here
    # cp SOME_FILE "${APP_RESOURCES}/"
fi

if [ $APP_ARCH = "arm64" ]; then
    :   
    # Handle Apple Silicon releases here
    # cp SOME_FILE "${APP_RESOURCES}/"
fi

if [ $APP_ARCH = "universal" ]; then
    :   
    # Handle Universal releases here.
    # cp SOME_FILE "${APP_RESOURCES}/"
fi
