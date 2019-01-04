//
//  RxPullToRefresh.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 A main class for RxPullToRefresh.
 */
open class RxPullToRefresh: NSObject {

    /** For debugging */
    internal var debug: Debug?

    /** A RxPullToRefreshPosition value indicating where placed at. */
    public var position: RxPullToRefreshPosition = .top

    /** An option for loading animations. */
    internal var loadAnimationOption: RxPullToRefreshAnimationOption
    /** An option for backing animations. */
    internal var backAnimationOption: RxPullToRefreshAnimationOption
    /** A TimeInterval value indicating the duration to display an error on failure. */
    public var waitDurationOnFailure: TimeInterval = 1.0

    /** A Boolean value indicating whether to start loading while dragging. If set to false, loading starts after the user finishes dragging. */
    public var shouldStartLoadingWhileDragging: Bool = true
    /** A Boolean value indicating whether a scroll view is being dragged. */
    @objc dynamic public internal(set) var isDragging: Bool = false
    /** A Boolean value indicating whether a scroll view is being forcibly refreshing. */
    internal var isForciblyRefreshing: Bool = false
    /** An Animator instance to animate UIScrollView. */
    internal var animator: Animator?

    /** A Boolean value indicating whether a RxPullToRefresh object is enabled. If set to false, a RxPullToRefresh object will not be displayed regardless of whether a data source exists or not. */
    @objc dynamic public var isEnabled: Bool = false {
        willSet {
            self.isEnabled = (self.scrollView?.canBeEnabled(at: self.position) ?? false) ? newValue : false
        }
        didSet {
            self.refreshView.isHidden = !isEnabled && !self.isVisible
        }
    }
    /** A Boolean value indicating whether RxPullToRefresh can load more content. If set to false, the text "No Content" will be displayed by default. */
    @objc dynamic public var canLoadMore: Bool = true {
        didSet { self.refreshView.canLoadMore = self.canLoadMore }
    }
    /** A Boolean value indicating whether a refresh view is visible. */
    @objc dynamic internal var isVisible: Bool {
        guard let sv: UIScrollView = self.scrollView else { return false }
        switch self.position {
        case .top:    return sv.relativeContentOffset(for: .top).y < 0
        case .bottom: return sv.relativeContentOffset(for: .bottom).y > 0
        }
    }
    /** A Boolean value indicating whether an opposite refresh view is loading. */
    internal var isOppositeLoading: Bool {
        guard let sv: UIScrollView = self.scrollView,
              let opposite: RxPullToRefresh = sv.getPullToRefresh(at: self.position.opposite) else { return false }
        return opposite.state != .initial
    }

    /** A scroll rate of a RxPullToRefreshState object */
    @objc dynamic internal var scrollRate: CGFloat = 0 {
        didSet {
            guard oldValue != self.scrollRate else { return }
            self.scrollRate = clamp(self.scrollRate.decimal(3), 0.0, 1.0)
        }
    }
    /** A pulling rate of a RxPullToRefreshState object */
    @objc dynamic public internal(set) var progressRate: CGFloat = 0 {
        didSet {
            guard oldValue != self.progressRate else { return }
            self.progressRate = clamp(self.progressRate.decimal(3), 0.0, 1.0)
            self.performAction()
        }
    }
    /** A RxPullToRefreshState value indicating a pulling state */
    @objc dynamic public internal(set) var state: RxPullToRefreshState = .initial {
        didSet {
            guard oldValue != self.state else { return }
            self.performAction()
            self.onStateChanged(oldValue)
        }
    }

    /** The object that acts as RxPullToRefreshDelegate. */
    public weak var delegate: RxPullToRefreshDelegate?

    /** A Boolean value indicating whether the RxPullToRefresh is observing scrolling. */
    internal var isObserving: Bool = false
    /** A DisposeBag object stored KVO observers */
    internal var kvoDisposeBag: DisposeBag?

    /** A customizable UIView which added to a header or a footer. */
    public internal(set) var refreshView: RxPullToRefreshView!

    /** A reference to an instance of UIScrollView. */
    internal weak var scrollView: UIScrollView? {
        willSet {
            self.stopObservingScrollView()
            self.scrollViewInitialInsets = .zero
            self.scrollViewInitialEffectiveInsets = .zero
        }
        didSet {
            guard let sv: UIScrollView = self.scrollView else { return }
            self.scrollViewInitialInsets = sv.contentInset
            self.scrollViewInitialEffectiveInsets = sv.effectiveContentInset
            self.startObservingScrollView()
        }
    }

    /** A UIEdgeInsets value indicating a content insets of the RxPullToRefresh when state is .initial excluding adjustedContentInsets. */
    internal var scrollViewInitialInsets: UIEdgeInsets = .zero
    /** A UIEdgeInsets value indicating a effective content insets of the RxPullToRefresh when state is .initial including adjustedContentInsets. */
    internal var scrollViewInitialEffectiveInsets: UIEdgeInsets = .zero
    /** A UIEdgeInsets value indicating a content insets of the RxPullToRefresh when state is .loading excluding adjustedContentInsets. */
    internal var scrollViewLoadingInsets: UIEdgeInsets {
        guard let sv: UIScrollView = self.scrollView else { return .zero }
        switch self.position {
        case .top: return sv.contentInset.replaced(
                top: self.scrollViewInitialInsets.top + self.refreshView.frame.height
        )
        case .bottom: return sv.contentInset.replaced(
                bottom: self.scrollViewInitialInsets.bottom + self.self.refreshView.frame.height
        )
        }
    }

    /**
     An function that initialize RxPullToRefresh

     - parameter refreshView: A UIView which will added to header or footer view.
     - parameter position: A RxPullToRefreshPosition value indicating a position.
     - parameter animationOption: A RxPullToRefreshPosition value indicating a position.
     */
    public init(refreshView: RxPullToRefreshView,
                position: RxPullToRefreshPosition,
                shouldStartLoadingWhileDragging: Bool = true,
                waitDurationOnFailure: TimeInterval = 1.0,
                loadAnimationType: RxPullToRefreshAnimationType = .linear(duration: 0.3),
                backAnimationType: RxPullToRefreshAnimationType = .linear(duration: 1.0)) {
        self.refreshView = refreshView
        self.position = position
        self.shouldStartLoadingWhileDragging = shouldStartLoadingWhileDragging
        self.waitDurationOnFailure = waitDurationOnFailure
        self.loadAnimationOption = loadAnimationType.option
        self.backAnimationOption = backAnimationType.option
        super.init()
        self.debug = Debug(self)
    }

    /**
     An function that initialize RxPullToRefresh

     - parameter height: A CGFloat value indicating the RxPullToRefresh height.
     - parameter position: A RxPullToRefreshPosition value indicating a position.
     - parameter animationOption: A RxPullToRefreshPosition value indicating a position.
     */
    public convenience init(position: RxPullToRefreshPosition,
                            shouldStartLoadingWhileDragging: Bool = true,
                            waitDurationOnFailure: TimeInterval = 1.0,
                            loadAnimationType: RxPullToRefreshAnimationType = .linear(duration: 0.3),
                            backAnimationType: RxPullToRefreshAnimationType = .linear(duration: 1.0)) {
        let refreshView: DefaultRefreshView = DefaultRefreshView()
        self.init(refreshView: refreshView,
                  position: position,
                  shouldStartLoadingWhileDragging: shouldStartLoadingWhileDragging,
                  waitDurationOnFailure: waitDurationOnFailure,
                  loadAnimationType: loadAnimationType,
                  backAnimationType: backAnimationType)
    }

    deinit {
        self.debug?.log(true, .simple, "🍄")
        self.stopObservingScrollView()
        self.scrollView?.removePullToRefresh(at: self.position)
        self.scrollView = nil
        self.refreshView = nil
        self.kvoDisposeBag = nil
        self.delegate = nil
    }
}
