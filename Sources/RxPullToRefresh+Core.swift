//
//  RxPullToRefresh+Core.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/18.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/**
 Key Value Observing
 */
internal extension RxPullToRefresh {

    /**
     A function to start observing KVO values of UIScrollView.
     */
    func startObservingScrollView() {
        guard let sv: UIScrollView = self.scrollView, !self.isObserving else { return }
        self.debug?.log(self.isVisible, .simple, "##")
        self.kvoDisposeBag = DisposeBag()
        sv.rx.willBeginDragging
                .subscribe(onNext: { [weak self] in self?.willBeginDragging() })
                .disposed(by: self.kvoDisposeBag!)
        sv.rx.willEndDragging
                .subscribe(onNext: { [weak self] (_: CGPoint, _: UnsafeMutablePointer<CGPoint>) in self?.willEndDragging() })
                .disposed(by: self.kvoDisposeBag!)
        sv.rx.contentOffset
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in self?.contentOffsetChanged() })
                .disposed(by: self.kvoDisposeBag!)
        sv.rx.contentSize
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in self?.contentSizeChanged() })
                .disposed(by: self.kvoDisposeBag!)
        sv.rx.contentInset
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in self?.contentInsetChanged() })
                .disposed(by: self.kvoDisposeBag!)
        self.isObserving = true
    }

    /**
     A function to stop observing KVO values of UIScrollView.
     */
    func stopObservingScrollView() {
        guard self.isObserving else { return }
        self.debug?.log(self.isVisible, .simple, "##")
        self.kvoDisposeBag = nil
        self.isObserving = false
    }
}

/**
 Functions for Observers
 */
private extension RxPullToRefresh {

    /**
     A function called when an user will begin dragging UIScrollView.
     */
    func willBeginDragging() {
        /* Stop animation */
        self.animator?.abort()
        self.animator = nil

        guard self.isEnabled else {
            self.isDragging = false
            return
        }

        /* If isVisible is true, set isDragging to true */
        if 0...1.0 ~= self.scrollRate { self.isDragging = true }
        self.debug?.log(true, .simple, "++")
    }

    /**
     A function called when an user will end dragging UIScrollView.
     */
    func willEndDragging() {
        guard self.isEnabled else { return }
        self.isDragging = false
        self.debug?.log(true, .simple, "++")
        if self.shouldStartLoadingWhileDragging && self.state == .loading {
            self.activateLoadingInset()
        }
    }

    /**
     A function called when UIScrollView.contentOffset is changed.
     */
    func contentOffsetChanged() {
        guard let sv: UIScrollView = self.scrollView, self.isEnabled else {
            self.scrollRate = 0.0
            self.progressRate = 0.0
            self.state = .initial
            return
        }
        let refreshHeight: CGFloat = self.refreshView.frame.size.height
        let relativeOffset: CGPoint = sv.relativeContentOffset(for: self.position)
        self.scrollRate = {
            switch self.position {
            case .top:    return -relativeOffset.y / refreshHeight
            case .bottom: return relativeOffset.y / refreshHeight
            }
        }()

        self.debug?.log(self.isVisible, .info, "++", [])

        /* Specify state by relativeOffset.y */
        switch self.state {

        case .initial:
            self.scrollViewInitialInsets = sv.contentInset
            self.scrollViewInitialEffectiveInsets = sv.effectiveContentInset
            switch self.position {
            case .top where -refreshHeight..<0.0 ~= relativeOffset.y:                 /* Offset is under threshold */
                if self.isDragging || self.isForciblyRefreshing { self.state = .pulling }
            case .bottom where 0.0..<refreshHeight ~= relativeOffset.y:               /* Offset is under threshold */
                if self.isDragging || self.isForciblyRefreshing { self.state = .pulling }
            default:
                self.progressRate = 0.0
            }

        case .pulling:
            var tmpRate: CGFloat = self.scrollRate
            var tmpState: RxPullToRefreshState = self.state
            switch self.position {
            case .top where -refreshHeight..<0.0 ~= relativeOffset.y:                 /* Offset is under threshold */
                if !self.isDragging && !self.isForciblyRefreshing { self.state = .backing }
            case .top where -CGFloat.infinity...(-refreshHeight) ~= relativeOffset.y: /* Offset is over threshold */
                tmpRate = 1.0
                tmpState = .overThreshold
            case .bottom where 0.0..<refreshHeight ~= relativeOffset.y:               /* Offset is under threshold */
                if !self.isDragging && !self.isForciblyRefreshing { self.state = .backing }
            case .bottom where refreshHeight...CGFloat.infinity ~= relativeOffset.y:  /* Offset is over threshold */
                tmpRate = 1.0
                tmpState = .overThreshold
            default:                                                                  /* Refresh view is completely hidden */
                tmpState = .initial
            }
            self.progressRate = tmpRate
            self.state = tmpState

        case .overThreshold:
            self.progressRate = 1.0
            switch self.position {
            case .top where -CGFloat.infinity...(-refreshHeight) ~= relativeOffset.y: /* Offset is over threshold */
                switch self.isDragging {
                case true where self.canLoadMore && !self.isOppositeLoading && self.shouldStartLoadingWhileDragging:
                    self.state = .loading
                case true:
                    break
                case false where self.canLoadMore && !self.isOppositeLoading:
                    self.state = .loading
                case false:
                    self.state = .backing
                }
            case .bottom where refreshHeight...CGFloat.infinity ~= relativeOffset.y:  /* Offset is over threshold */
                switch self.isDragging {
                case true where self.canLoadMore && !self.isOppositeLoading && self.shouldStartLoadingWhileDragging:
                    self.state = .loading
                case true:
                    break
                case false where self.canLoadMore && !self.isOppositeLoading:
                    self.state = .loading
                case false:
                    self.state = .backing
                }
            default:                                                                  /* Offset is backing to under threshold */
                self.state = .pulling
                break
            }

        case .loading:
            self.progressRate = 1.0

        case .finished:
            self.progressRate = 1.0

        case .failed:
            self.progressRate = 1.0

        case .backing:
            var tmpRate: CGFloat = self.scrollRate
            var tmpState: RxPullToRefreshState = self.state
            if self.progressRate <= 0.05 {
                tmpRate = 0.0
                tmpState = .initial
            }
            self.progressRate = tmpRate
            self.state = tmpState
        }
    }

    /**
     A function that called when UIScrollView.contentSize is changed.
     */
    func contentSizeChanged() {
        guard let sv: UIScrollView = self.scrollView else { return }
        self.debug?.log(self.isVisible, .info, "++")
        self.isEnabled = sv.canBeEnabled(at: self.position)
        if self.position == .bottom {
            self.refreshView.frame = CGRect(x: 0,
                                            y: sv.contentSize.height,
                                            width: sv.bounds.width,
                                            height: self.refreshView.bounds.height)
        }
        if self.state != .loading && self.state != .finished {
            self.scrollViewInitialInsets = sv.contentInset
            self.scrollViewInitialEffectiveInsets = sv.effectiveContentInset
        }
    }

    /**
     A function that called when UIScrollView.contentInset is changed.
     */
    func contentInsetChanged() {
        guard let sv: UIScrollView = self.scrollView else { return }
        self.debug?.log(self.isVisible, .info, "++")
        if self.state != .loading && self.state != .finished {
            self.scrollViewInitialInsets = sv.contentInset
            self.scrollViewInitialEffectiveInsets = sv.effectiveContentInset
        }
    }

}

/**
 Handle state and pulling rate
 */
internal extension RxPullToRefresh {

    /**
     A function to perform action when a state or a rate value is changed.
     */
    func performAction() {
        self.delegate?.action(state: self.state, progress: self.progressRate, scroll: self.scrollRate)
        self.refreshView.action(state: self.state, progress: self.progressRate, scroll: self.scrollRate)
    }

    /**
     A function called when a state value is changed.
     */
    func onStateChanged(_ oldValue: RxPullToRefreshState) {
        self.debug?.log(true, .info, "==")
        switch self.state {
        case .initial: break
        case .pulling: break
        case .overThreshold: break
        case .loading where (oldValue != .loading && !self.isOppositeLoading && !self.shouldStartLoadingWhileDragging):
            self.activateLoadingInset()
        case .finished:
            self.state = .backing
            self.deactivateLoadingInset(shouldKeepOffset: true)
        case .failed:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.waitDurationOnFailure) {
                self.state = .backing
                self.deactivateLoadingInset(shouldKeepOffset: false)
            }
        case .backing: break
        default: break
        }
    }

}

/**
 Switch scroll view insets
 */
internal extension RxPullToRefresh {

    /**
     A function that changes scroll view insets when the state is .loading.
     */
    func activateLoadingInset() {
        let targetInsets: UIEdgeInsets = self.scrollViewLoadingInsets
        let opts: RxPullToRefreshAnimationOption = self.loadAnimationOption

        self.debug?.log(true, .verbose, "🆔",
                        ["",
                         Debug.format(name: "targetInsets", prop: targetInsets),
                         "",
                         Debug.format(name: "opts", prop: opts)])

        UIView.animate(withDuration: opts.duration,
                       animations: { [weak self] in
                           guard let sv: UIScrollView = self?.scrollView else { return }
                           sv.contentInset = targetInsets
                       },
                       completion: { [weak self] (_: Bool) in
                           guard let sv: UIScrollView = self?.scrollView else { return }
                           sv.bounces = true
                       })
    }

    /**
     A function that changes scroll view insets when the state is not .loading.
     */
    func deactivateLoadingInset(shouldKeepOffset: Bool) {
        guard let sv: UIScrollView = self.scrollView else { return }
        let targetInsets: UIEdgeInsets = self.scrollViewInitialInsets
        let targetOffset: CGPoint? = {
            guard let sv: UIScrollView = self.scrollView else { return .zero }
            switch self.position {
            case .bottom where shouldKeepOffset && !self.isDragging:
                return sv.contentOffset.replaced(
                        y: self.scrollViewInitialEffectiveInsets.bottom + sv.scrollableHeight + self.refreshView.frame.height
                )
            case .bottom where !shouldKeepOffset && !self.isDragging:
                return sv.contentOffset.replaced(
                        y: self.scrollViewInitialEffectiveInsets.bottom + sv.scrollableHeight
                )
            default:
                return nil
            }
        }()
        let opts: RxPullToRefreshAnimationOption = self.backAnimationOption

        self.debug?.log(true, .verbose, "🆚",
                        ["",
                         Debug.format(name: "targetInsets", prop: targetInsets),
                         Debug.format(name: "targetOffset", prop: targetOffset),
                         "",
                         Debug.format(name: "opts", prop: opts)])

        sv.setContentOffset(sv.contentOffset, animated: false)
        UIView.animate(withDuration: opts.duration,
                       delay: opts.delay,
                       usingSpringWithDamping: opts.damping,
                       initialSpringVelocity: opts.velocity,
                       options: opts.options,
                       animations: { [weak self] in
                           guard let `self`: RxPullToRefresh = self,
                                 let sv: UIScrollView = self.scrollView else { return }
                           sv.contentInset = targetInsets
                           if let offset: CGPoint = targetOffset { sv.contentOffset = offset }
                           self.scrollRate = 0.0
                           self.progressRate = 0.0
                       },
                       completion: { [weak self] (_: Bool) in
                           guard let `self`: RxPullToRefresh = self else { return }
                           self.scrollRate = 0.0
                           self.progressRate = 0.0
                           self.state = .initial
                       }
        )
    }
}
