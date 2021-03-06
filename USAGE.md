## Usage

Read the [API reference](https://gumob.github.io/RxPullToRefresh/Classes/RxPullToRefresh.html) and the [USAGE.md](https://gumob.github.io/RxPullToRefresh/usage.html) for detailed information.

### Basic Usage

#### Import frameworks to your project

```swift
import RxSwift
import RxCocoa
import RxPullToRefresh
```

#### Add RxPullToRefresh

Create a RxPullToRefresh object.

```swift
// Create a RxPullToRefresh object
self.topPullToRefresh = RxPullToRefresh(position: .top)
// Add a RxPullToRefresh object to UITableView
self.tableView.p2r.addPullToRefresh(self.topPullToRefresh)
```

#### Observe RxPullToRefreshDelegate

By observing [RxPullToRefreshDelegate](https://gumob.github.io/RxPullToRefresh/Protocols/RxPullToRefreshDelegate.html), you can watch the state of a RxPullToRefresh object. This delegate is get called by the RxPullToRefresh object every time its [state](https://gumob.github.io/RxPullToRefresh/Enums/RxPullToRefreshState.html) or scrolling rate is changed.
```swift
// Observe RxPullToRefreshDelegate
self.topPullToRefresh.rx.action
        .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
            // Send request if RxPullToRefreshState is changed to .loading
            switch state {
            case .loading: self?.prepend()
            default:       break
            }
        })
        .disposed(by: self.disposeBag)
```

#### Load and append contents

```swift
self.viewModel.prepend()
              .subscribe(onSuccess: { [weak self] in
                  // Successfully loaded, collapse refresh view immediately
                  self?.tableView.p2r.endRefreshing(at: .top)
              }, onError: { [weak self] (_: Error) in
                  // Failed to load, show error
                  self?.tableView.p2r.failRefreshing(at: .top)
              })
              .disposed(by: self.disposeBag)
```

#### Disable refreshing by binding Boolean value to canLoadMore property

```swift
self.viewModel.canPrepend
        .asDriver()
        .drive(self.topPullToRefresh.rx.canLoadMore)
        .disposed(by: self.disposeBag)
```

#### Dispose RxPullToRefresh objects

```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tableView.p2r.endAllRefreshing()
    self.tableView.p2r.removeAllPullToRefresh()
}
```

### Advanced Usage

#### About the example project

`RxPullToRefresh` allows you flexibly customize a refresh view by inheriting [RxPullToRefresh](https://gumob.github.io/RxPullToRefresh/Classes/RxPullToRefresh.html) and [RxPullToRefreshView](https://gumob.github.io/RxPullToRefresh/Classes/RxPullToRefreshView.html) classes. Please check [example sources](https://github.com/gumob/RxPullToRefresh/blob/master/Example/) for advanced usage.

- [CustomRefresh](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from `RxPullToRefresh`.
- [CustomRefreshView](https://github.com/gumob/RxPullToRefresh/blob/master/Example/CustomRefresh.swift): A class inheriting from `RxPullToRefreshView`. Animation logics are implemented in this class.
- [BaseTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that conforms to MVVM architecture.
- [CustomTableViewController](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewController.swift): A view controller that creates a `CustomPullToRefresh` instance.
- [TableViewModel](https://github.com/gumob/RxPullToRefresh/blob/master/Example/TableViewModel.swift): A view model that manipulates data sources.

#### Build the example app

1. Update Carthage frameworks
```bash
$ carthage update --platform iOS
```
2. Open `RxPullToRefresh.xcodeproj`
3. Select the scheme `RxPullToRefreshExample` from the drop-down menu in the upper left of the Xcode window
4. Press ⌘R
