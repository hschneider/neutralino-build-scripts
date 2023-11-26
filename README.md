# neutralino-build-scripts

**Build-Automation for macOS and Windows App-Bundles**.

This set of scripts replace the `neu build` command for macOS- and Windows-builds. Instead of plain binaries, it outputs ready-to-use app-bundles.

> The macOS build-script solves the problem, that Neutralino only produces plain macOS binaries and no valid macOS AppBundles. These files can be signed, but not notarized.
> build-mac.sh generates valid AppBundles which pass Apple's notarization process successfully :-)

## Setup

Copy all, **except neutralino.config.json** (which is just an example) to your project's root folder. The scripts are tested under macOS and should also run on Linux or Windows/WSL.

Install **jq**, which is required for parsing JSON files:

```bash
# On macOS:
brew install jq
# On Linux or Windows/WSL:
sudo apt-get install jq
```

If your are a Mac-user and never heard of Homebrew, visit https://brew.sh

Add this to your neutralino.config.json:

```json
 "buildScript": {
    "mac": {
      "architecture": ["x64", "arm64", "universal"],
      "minimumOS": "10.13.0",
      "appName":  "ExtBunDemo",
      "appBundleName":    "ExtBunDemo",
      "appIdentifier":    "com.marketmix.ext.bun.demo",
      "appIcon":  "icon.icns"
    },
    "win": {
      "architecture": ["x64"],
      "appName":  "ExtBunDemo.exe"
    }
  }
```

If you are unsure where to add, examine **the example neutralino.config.json**, included in this repo.

## Build for macOS

```bash
./build-mac.sh
```

This starts the following procedure:

- Erase the target folder ./dist/APPNAME  
- Run `neu build`
- Clone the app-bundle scaffold from `_app_scaffolds/mac` and adapt it to your app.
- Copy all resources and extensions to the app-bundle.
- Execute `postproc-mac.sh`

All build targets are created in the ./dist folder.

Because the macOS-platform consists of 3 architectures, you might want to add different resources after the app has been built. That's what **postproc-mac.sh** is for. Just add your custom code there and you are good to go.

The `buildScript/mac` JSON segment in the config file contains the following fields:

| Key           | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| architecture  | This is an array of the architectures, you want to build. In our example we build all 3 architectures. |
| minimumOS     | The minimum macOS version.                                   |
| appName       | The app-name as displayed in the Finder.                     |
| appBundleName | The macOS app-bundle name.                                   |
| appIdentifier | The macOS app-identifier.                                    |
| appIcon       | Path to the app-icon in .icns-format. If only the filename is submitted, the file is expected in the project's root. |

## Build for Windows

```bash
./build-win.sh
```

This starts the following procedure:

- Erase the target folder ./dist/APPNAME  
- Run `neu build`
- Copy all resources and extensions to the app-bundle.
- Execute `postproc-win.sh`

All build is created in the ./dist folder.

In contrast to macOS, the whole process is straight-forward. The app-bundle is just a plain folder with the binary, resources.neu and the extensions-folder. You can also put custom code into `postproc-win.sh` to perform any action after the bundle has been built.

The `buildScript/win` JSON segment in the config file contains the following fields:

| Key          | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| architecture | This is an array of the architectures, you want to build. Because Neutralino currently only support 'x64', you should leave this untouched. |
| appName      | The app-name as displayed in the File Explorer.              |

## Build for Linux?

Felld free to send me a Pull-Request :-)

## More about Neutralino

[NeutralinoJS Home](https://neutralino.js.org) 

[Neutralino related blog posts at marketmix.com](https://marketmix.com/de/tag/neutralinojs/)

<img src="https://marketmix.com/git-assets/star-me-2.svg">