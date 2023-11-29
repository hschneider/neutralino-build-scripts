#!/bin/bash
#
# postproc-win.sh 1.0.1
#
# Windows build script post-processor.
#
# This is called from build-win.sh after the app-bundle has been built.
# Use this e.g. to copy additional resources to the app-bundle.
# You can use all variables from the main script here.
#
# (c)2023 Harald Schneider - marketmix.com

if [ $APP_ARCH = "x64" ]; then
    :   
    # Handle Intel releases here
    # cp SOME_FILE "${APP_DST}/"
fi
