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
## iOS
### ios prebuild
```
fastlane ios prebuild
```
Prebuild
### ios set_version
```
fastlane ios set_version
```
Set version number
### ios bump_version
```
fastlane ios bump_version
```
Bump version number
### ios clean_test_all
```
fastlane ios clean_test_all
```
Clean & Run Test for all iOS versions
### ios clean_test
```
fastlane ios clean_test
```
Clean & Run Test
### ios test
```
fastlane ios test
```
Run Test
### ios coverage
```
fastlane ios coverage
```
Run Coverage
### ios lint
```
fastlane ios lint
```
Run Swiftlint
### ios create_doc
```
fastlane ios create_doc
```
Create documentation
### ios reset_simulator
```
fastlane ios reset_simulator
```
Reset Simulator
### ios reset_derived_data
```
fastlane ios reset_derived_data
```
Reset Derived Data
### ios update_carthage
```
fastlane ios update_carthage
```
Update Carthage
### ios build_carthage
```
fastlane ios build_carthage
```
Build Carthage
### ios lint_cocoapods
```
fastlane ios lint_cocoapods
```
Lint Cocoapods
### ios push_cocoapods
```
fastlane ios push_cocoapods
```
Push Cocoapods

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
