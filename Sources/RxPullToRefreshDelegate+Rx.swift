//
//  RxPullToRefreshDelegate+Rx.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/29.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension RxPullToRefresh: HasDelegate {
    public typealias Delegate = RxPullToRefreshDelegate
}

internal class RxPullToRefreshDelegateProxy: DelegateProxy<RxPullToRefresh, RxPullToRefreshDelegate>,
                                             RxPullToRefreshDelegate, DelegateProxyType {
    init(parentObject: ParentObject) {
        super.init(parentObject: parentObject, delegateProxy: RxPullToRefreshDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxPullToRefreshDelegateProxy(parentObject: $0) }
    }

    var actionSubject: PublishSubject<(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)>
            = PublishSubject<(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)>()

    func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        self.actionSubject.on(.next((state: state, progress: progress, scroll: scroll)))
        self._forwardToDelegate?.action(state: state, progress: progress, scroll: scroll)
    }

    deinit {
        self.actionSubject.on(.completed)
    }
}

extension Reactive where Base: RxPullToRefresh {
    public var delegate: DelegateProxy<RxPullToRefresh, RxPullToRefreshDelegate> {
        return RxPullToRefreshDelegateProxy.proxy(for: base)
    }

    /** Reactive wrapper for `RxPullToRefreshDelegate.action` method. */
    public var action: ControlEvent<(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)> {
        let source: PublishSubject<(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)>
                = (self.delegate as! RxPullToRefreshDelegateProxy)
                .actionSubject
        return ControlEvent(events: source)
    }
}
