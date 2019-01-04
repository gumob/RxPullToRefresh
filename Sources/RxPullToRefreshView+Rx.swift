//
//  RxPullToRefreshView+Rx.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/29.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: RxPullToRefreshView {
    /** Reactive wrapper for `RxPullToRefreshView.canLoadMore` property. */
    public var canLoadMore: Driver<Bool> {
        return self.observeWeakly(Bool.self, #keyPath(RxPullToRefreshView.canLoadMore))
                   .filter { $0 != nil }
                   .map { $0! }
                   .distinctUntilChanged()
                   .takeUntil(deallocated)
                   .asDriver(onErrorDriveWith: Driver.empty())
    }
}
