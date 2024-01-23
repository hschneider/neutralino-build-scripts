![](https://marketmix.com/git-assets/neutralino-build-scripts/neutralino-macos-appbundles.jpg)

# neutralino-build-scripts

**Neutralino Build-Automation for macOS, Linux and Windows App-Bundles**.

This set of scripts replace the `neu build` command for macOS-, Linux and Windows-builds. Instead of plain binaries, it outputs ready-to-use app-bundles.

> The macOS build-script solves the problem, that Neutralino only produces plain macOS binaries and not macOS AppBundles. These files cannot be signed and notarized.
> **build-mac.sh** generates valid AppBundles which pass Apple's notarization process successfully :-

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
      "appName": "ExtBunDemo",
      "appBundleName": "ExtBunDemo",
      "appIdentifier": "com.marketmix.ext.bun.demo",
      "appIcon":  "icon.icns"
    },
    "win": {
      "architecture": ["x64"],
      "appName": "ExtBunDemo",
      "appIcon": "icon.ico"
    },
    "linux": {
      "architecture": ["x64", "arm64", "armhf"],
      "appName": "ExtBunDemo",
      "appIcon": "icon.png",
      "appPath":  "/usr/share/ExtBunDemo",
      "appIconLocation": "/usr/share/ExtBunDemo/icon.png"
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
- Execute `preproc-mac.sh`
- Clone the app-bundle scaffold from `_app_scaffolds/mac` and adapt it to your app.
- Copy all resources and extensions to the app-bundle.
- Execute `postproc-mac.sh`

All build targets are created in the ./dist folder.

Because the macOS-platform consists of 3 binary architectures, you might want to add different resources after the app has been built. That's what `postproc-mac.sh` is for. Just add your custom code there and you are good to go.

If you need to prepare platform-specific resource before bundling starts, you can add your custom code to `preproc-mac.sh`.

Keep in mind that alle additional resources have to be copied to `${APP_RESOURCES}/`, which resolves to `MyApp.app/Contents/Resources`. If you place them elsewhere, your signature or notarization might break.

The `buildScript/mac` JSON segment in the config-file contains the following fields:

| Key           | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| architecture  | This is an array of the architectures, you want to build. In our example we build all 3 architectures. |
| minimumOS     | The minimum macOS version.                                   |
| appName       | The app-name as displayed in the Finder.                     |
| appBundleName | The macOS app-bundle name.                                   |
| appIdentifier | The macOS app-identifier.                                    |
| appIcon       | Path to the app-icon in **.icns-format**. If only the filename is submitted, the file is expected in the project's root. |

If you want to streamline your deployment process under macOS, you might also be interested in **[Sign and Notarize Automation](https://github.com/hschneider/macos-sign-notarize)** from commandline.

## Build for Windows

```bash
./build-win.sh
```

This starts the following procedure:

- Erase the target folder ./dist/APPNAME  
- Run `neu build`
- Execute `preproc-win.sh`
- Copy all resources and extensions to the app-bundle.
- Execute `postproc-win.sh`
- Create the `install-icon.cmd` helper script from its template in `_app_scaffolds/win/`, if an app icon file exists.

The build is created in the ./dist folder.

In contrast to macOS, the whole process is straight-forward. The app-bundle is just a plain folder with the binary, resources.neu, the extensions-folder and WebView2Loader.dll.  The DLL can be deleted, if you deploy on WIndows 11 or newer.

If you need to prepare platform-specific resource before bundling starts, you can add your custom code to `preproc-win.sh`.

You can also put custom code into `postproc-win.sh` to perform any action after the bundle has been built.

The `buildScript/win` JSON segment in the config-file contains the following fields:

| Key          | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| architecture | This is an array of the architectures, you want to build. Because Neutralino currently only support 'x64', you should leave this untouched. |
| appName      | The app-name as displayed in the File Explorer, with or without .exe-suffix. |
| appIcon      | Path to the app-icon in **.ico-format**. If only the filename is submitted, the file is expected in the project's root. The icon is copied from this path into the app-bundle. To apply the icon to the executable file, you'll have to run **[Resource Hacker](https://www.angusj.com/resourcehacker/)** from a Windows machine. To do so, just double-click **install-icon.cmd** in the app-bundle. |

The icon installer in action:

![](https://marketmix.com//git-assets/neutralino-build-scripts/neutralino-icon-installer.gif)

## Build for Linux

```bash
./build-linux.sh
```

This starts the following procedure:

- Erase the target folder ./dist/APPNAME  
- Run `neu build`
- Execute `preproc-linux.sh`
- Copy all resources and extensions to the app-bundle.
- Clones  the  .desktop-file from `_app_scaffolds/linux` to the app-bundle and adapts its content.
- Execute `postproc-linux.sh`

All build targets are created in the ./dist folder.

Because the Linux-platform consists of 3 binary architectures, you might want to add different resources after the app has been built. That's what `postproc-linux.sh` is for. Just add your custom code there and you are good to go.

If you need to prepare platform-specific resource before bundling starts, you can add your custom code to `preproc-linux.sh`.

> The **APP_NAME.desktop**-file and the **app icon** have to be copied to their proper places, when you deploy your app. 

The following paths are proposed:

| Resource           | Path                                     |
| ------------------ | ---------------------------------------- |
| Application Folder | /usr/share/APP_NAME                      |
| Application Icon   | /usr/share/APP_NAME/icon.png             |
| Desktop File       | /usr/share/applications/APP_NAME.desktop |

The `buildScript/win` JSON segment in the config-file contains the following fields:

| Key          | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| architecture | This is an array of the architectures, you want to build. In our example we build all 3 architectures. |
| appName      | The app-name as displayed in the File Explorer.              |
| appPath      | The application path without the executable name and without ending slash. |
| appIcon      | Path to the app-icon in .**png- or svg-format**. If only the filename is submitted, the file is expected in the project's root. The icon is copied from this path into the app-bundle. |
| appIconPath  | This is the icon's path **after** the has been installed on a Linux system. That path is written to the .desktop-file. |

Calling `sudo ./install.sh` from your build folder automatically installs the app to the locations you defined.

## More about Neutralino

- [NeutralinoJS Home](https://neutralino.js.org) 

- [Neutralino related blog posts at marketmix.com](https://marketmix.com/de/tag/neutralinojs/)



<img src="https://marketmix.com/git-assets/star-me-2.svg">
