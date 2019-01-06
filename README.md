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

<img src="https://raw.githubusercontent.com/gumob/RxPullToRefresh/master/Metadata/screenshot-animation.gif" alt="drawing" width="40%" style="width:40%;"/>

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

Do not forget to include RxSwift.framework and RxCocoa.framework. Otherwise it will fail to build the application.<br/>

<img src="https://raw.githubusercontent.com/gumob/RxPullToRefresh/master/Metadata/carthage-xcode-config.jpg" alt="drawing" width="480" style="width:100%; max-width: 480px;"/>

### CocoaPods

To integrate RxPullToRefresh into your project, add the following to your `Podfile`.

```ruby
platform :ios, '9.3'
use_frameworks!

pod 'RxPullToRefresh'
```

## Usage

Read the [API reference](https://gumob.github.io/RxPullToRefresh/Classes/RxPullToRefresh.html) and the [USAGE.md](https://gumob.github.io/RxPullToRefresh/usage.html) for detailed information.


### Basic Usage

##### Import frameworks to your project

```swift
import RxSwift
import RxCocoa
import RxPullToRefresh
```

##### Add RxPullToRefresh to header

```swift
self.topPullToRefresh = RxPullToRefresh(position: .top)
self.topPullToRefresh.rx.action
        .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
            switch state {
            case .loading: self?.viewModel.load()
            default:       break
            }
        })
        .disposed(by: self.disposeBag)
self.tableView.addPullToRefresh(self.topPullToRefresh)
```

### Advanced Usage

##### About the example project

RxPullToRefresh allows you flexibly customize a refresh view by extending RxPullToRefresh and RxPullToRefreshView classes. Please check [example sources](https://github.com/gumob/RxPullToRefresh/blob/master/Example/) for advanced usage.

- [CustomRefresh](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from RxPullToRefresh.
- [CustomRefreshView](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from RxPullToRefreshView. Animation logics are implemented in this class.
- [BaseTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that conforms to MVVM architecture.
- [CustomTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that creates a CustomPullToRefresh instance.
- [TableViewModel](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewModel.swift): A view model that manipulates data sources.

##### Build the example app

1. Update Carthage frameworks
```bash
$ carthage update --platform iOS
```
2. Open `RxPullToRefresh.xcodeproj`
3. Select the scheme `RxPullToRefreshExample` from the drop-down menu in the upper left of the Xcode window
4. Press ⌘R



## Copyright

RxPullToRefresh is released under MIT license, which means you can modify it, redistribute it or use it however you like.
