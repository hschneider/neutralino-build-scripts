#!/bin/bash
#
# preproc-mac.sh 1.0.0
#
# macOS build script pre-processor.
#
# This is called from build-win.sh before the app-bundle has been built.
# Use this e.g. to preoare platform specific resources.
#
# (c)2024 Harald Schneider - marketmix.com

if [ $APP_ARCH = "x64" ]; then
    :   
    # Handle Intel releases here
fi

if [ $APP_ARCH = "arm64" ]; then
    :   
    # Handle Apple Silicon releases here
fi

if [ $APP_ARCH = "universal" ]; then
    :   
    # Handle Universal releases here.
fi
