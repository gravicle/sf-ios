fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### update_build
```
fastlane update_build
```
#### Options

 ***`build`**: The build to set in the *.plist files (`CFBundleVersion`)

#### Example:

```fastlane update_build build:69```
### update_version
```
fastlane update_version
```
Sets the version of the project

#### Options

 **`version`**: The version to set in the *.plist (`CFBundleShortVersionString`)

#### Example:

```fastlane update_version version:1.0.4```
### release
```
fastlane release
```
update plists, tag, build, distribute to iTC

#### Options

 **`version`**: The version to set in the *.plist (`CFBundleShortVersionString`)

 **`build`**: The build to set in the *.plist (`CFBundleVersion`)

#### Example:

```fastlane release build:68 version:1.0.4```

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
