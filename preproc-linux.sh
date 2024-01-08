#!/bin/bash
#
# preproc-linux.sh 1.0.1
#
# Linux build script pre-processor.
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
    # Handle ARM releases here
fi

if [ $APP_ARCH = "armhf" ]; then
    :   
    # Handle ARM hard_float releases here.
fi
