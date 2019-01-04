//
// Created by kojirof on 2018-12-17.
// Copyright (c) 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/** Reactive Extension for `RxPullToRefresh` and `RxPullToRefreshView`. */
extension Reactive where Base: RxPullToRefresh {
    /** Reactive wrapper for `RxPullToRefresh.isEnabled` property. */
    public var isEnabled: ControlProperty<Bool> {
        let source: Observable<Bool> = self.observeWeakly(Bool.self,
                                                          #keyPath(RxPullToRefresh.isEnabled),
                                                          options: [.initial, .new])
                                           .filter { $0 != nil }
                                           .map { $0! }
                                           .distinctUntilChanged()
                                           .takeUntil(deallocated)
        let observer = Binder(self.base) { (refresh: RxPullToRefresh, isEnabled: Bool) in
            refresh.isEnabled = isEnabled
        }
        return ControlProperty(values: source, valueSink: observer)
    }

    /** Reactive wrapper for `RxPullToRefresh.canLoadMore` property. */
    public var canLoadMore: ControlProperty<Bool> {
        let source: Observable<Bool> = self.observeWeakly(Bool.self,
                                                          #keyPath(RxPullToRefresh.canLoadMore),
                                                          options: [.initial, .new])
                                           .filter { $0 != nil }
                                           .map { $0! }
                                           .distinctUntilChanged()
                                           .takeUntil(deallocated)
        let observer = Binder(self.base) { (refresh: RxPullToRefresh, canLoadMore: Bool) in
            refresh.canLoadMore = canLoadMore
        }
        return ControlProperty(values: source, valueSink: observer)
    }

    /** Reactive wrapper for `RxPullToRefresh.isVisible` property. */
    public var isVisible: Driver<Bool> {
        return self.observeWeakly(CGFloat.self, #keyPath(RxPullToRefresh.scrollRate))
                   .filter { $0 != nil }
                   .map { $0! > 0 }
                   .distinctUntilChanged()
                   .takeUntil(deallocated)
                   .asDriver(onErrorDriveWith: Driver.empty())
    }
}
