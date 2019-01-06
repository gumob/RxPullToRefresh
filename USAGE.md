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

RxPullToRefresh allows you flexibly customize a refresh view by extending RxPullToRefresh and RxPullToRefreshView classes. Please check [example sources](https://github.com/gumob/RxPullToRefresh/blob/master/Example/") for advanced usage.

- [CustomRefresh](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift"): A class inheriting from RxPullToRefresh.
- [CustomRefreshView](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift"): A class inheriting from RxPullToRefreshView. Animation logics are implemented in this class.
- [BaseTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift"): A view controller that conforms to MVVM architecture.
- [CustomTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift"): A view controller that creates a CustomPullToRefresh instance.
- [TableViewModel](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewModel.swift"): A view model that manipulates data sources.

##### Build the example app

1) Update Carthage frameworks
```bash
$ carthage update --platform iOS
```
2) Open `RxPullToRefresh.xcodeproj`
3) Select the scheme `RxPullToRefreshExample` from the drop-down menu in the upper left of the Xcode window
4) Press ⌘R
