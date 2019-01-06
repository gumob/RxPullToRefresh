[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/gumob/RxPullToRefresh)
[![Version](http://img.shields.io/cocoapods/v/RxPullToRefresh.svg)](http://cocoadocs.org/docsets/RxPullToRefresh)
[![Platform](http://img.shields.io/cocoapods/p/RxPullToRefresh.svg)](http://cocoadocs.org/docsets/RxPullToRefresh)
[![Build Status](https://travis-ci.com/gumob/RxPullToRefresh.svg?branch=master)](https://travis-ci.com/gumob/RxPullToRefresh)
[![codecov](https://codecov.io/gh/gumob/RxPullToRefresh/branch/master/graph/badge.svg)](https://codecov.io/gh/gumob/RxPullToRefresh)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)
![Language](https://img.shields.io/badge/Language-Swift%204.2-orange.svg)
![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)

# RxPullToRefresh
A Swift library enables you to create a pull to refreshable UIScrollView with a custom view supporting RxSwift.

<img src="Metadata/screenshot-animation.gif" alt="drawing" width="480" style="width:40%;"/>

## Features

- Support UIScrollView, UITableView, and UICollectionView
- Customizable refresh view
- Customizable animaton options
- Configurable option whether to load while dragging or to load you after a finger
- Error handling
- Support RxSwift/RxCocoa

## Requirements

- iOS 9.0 or later
- Swift 4.2

## Installation

### Carthage

Add the following to your `Cartfile` and follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

```
github "gumob/RxPullToRefresh"
```

Do not forget to include RxSwift.framework. Otherwise it will fail to build the application.<br/>

<img src="Metadata/carthage-xcode-config.jpg" alt="drawing" width="480" style="width:100%; max-width: 480px;"/>

### CocoaPods

To integrate RxPullToRefresh into your project, add the following to your `Podfile`.

```ruby
platform :ios, '9.3'
use_frameworks!

pod 'RxPullToRefresh'
```

## Usage

Read the [usage](https://gumob.github.io/RxPullToRefresh/usage.html) and the [API reference](https://gumob.github.io/RxPullToRefresh/Classes/RxPullToRefresh.html) for detailed information.

## Copyright

RxPullToRefresh is released under MIT license, which means you can modify it, redistribute it or use it however you like.
