//
//  RxPullToRefresh+Refreshing.swift
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
 Manage refreshing
 */
public extension RxPullToRefresh {

    /**
     A function to start refreshing forcibly.
     */
    func startRefreshing() {
        guard let sv: UIScrollView = self.scrollView,
              !self.isOppositeLoading,
              self.state == .initial,
              self.isEnabled else { return }

        let initialOffset: CGPoint = {
            switch self.position {
            case .top: return sv.contentOffset.replaced(
                    y: -(scrollViewInitialEffectiveInsets.top)
            )
            case .bottom:return sv.contentOffset.replaced(
                    y: self.scrollViewInitialEffectiveInsets.bottom + sv.p2r.scrollableHeight
            )
            }
        }()
        let targetOffset: CGPoint = {
            switch self.position {
            case .top: return sv.contentOffset.replaced(
                    y: -(self.scrollViewInitialEffectiveInsets.top + refreshView.frame.height)
            )
            case .bottom: return sv.contentOffset.replaced(
                    y: self.scrollViewInitialEffectiveInsets.bottom + sv.p2r.scrollableHeight + refreshView.frame.height
            )
            }
        }()

        self.debug?.log(true, .simple, "🍄", ["initialOffset: \(initialOffset)",
                                              "targetOffset: \(targetOffset)"])

        /* Start pulling */
        let scalar: CGFloat = self.canLoadMore ? 3 : 6
        let pullAnimation = AnimatorAnimation(property: AnimatorProperty(obj: sv,
                                                                         keyPath: #keyPath(UIScrollView.contentOffset),
                                                                         value: targetOffset,
                                                                         scalar: scalar),
                                              completion: { [weak self] (isFinished: Bool) in
                                                  guard let `self`: RxPullToRefresh = self else { return }
                                                  self.debug?.log(true, .simple, "🍄", ["isFinished: \(isFinished)"])
                                                  guard isFinished else { return }
                                                  if self.canLoadMore {
                                                      /* Start loading */
                                                      self.state = .overThreshold
                                                      self.state = .loading
                                                  } else {
                                                      /* Start backing */
                                                      self.state = .backing
                                                  }
                                              })
        /* Start backing */
        let backAnimation = AnimatorAnimation(property: AnimatorProperty(obj: sv,
                                                                         keyPath: #keyPath(UIScrollView.contentOffset),
                                                                         value: initialOffset),
                                              completion: { [weak self] (isFinished: Bool) in
                                                  guard let `self`: RxPullToRefresh = self else { return }
                                                  self.debug?.log(true, .simple, "🍄", ["isFinished: \(isFinished)"])
                                                  guard isFinished else { return }
                                                  self.state = .initial
                                              })
        let animations: [AnimatorAnimation] = {
            switch self.canLoadMore {
            case true:  return [pullAnimation]
            case false: return [pullAnimation, backAnimation]
            }
        }()

        /* Stop animation */
        self.animator?.abort()
        self.animator = nil
        /* Start animation */
        self.isForciblyRefreshing = true
        sv.bounces = false
        self.animator = Animator()
        self.animator?.animate(animations: animations,
                               completion: { [weak self] (isFinishedAll: Bool) in
                                   guard let `self`: RxPullToRefresh = self,
                                         let sv: UIScrollView = self.scrollView else { return }
                                   self.debug?.log(true, .simple, "🍄", ["isFinishedAll: \(isFinishedAll)"])
                                   self.isForciblyRefreshing = false
                                   sv.bounces = true
                               })
    }

    /**
     A function to end refreshing.
     */
    func endRefreshing() {
        self.debug?.log(true, .simple, "--")

        /* Cancel animation */
        self.animator?.abort()
        self.animator = nil

        /* Change state */
        switch self.state {
        case .loading:
            self.state = .finished
        case .initial:
            break
        default:
            self.state = .backing
            self.backToInitialOffset()
        }
    }

    /**
     A function to fail refreshing.
     */
    func failRefreshing() {
        self.debug?.log(true, .simple, "--")

        /* Cancel animation */
        self.animator?.abort()
        self.animator = nil

        /* Change state */
        switch self.state {
        case .loading:
            self.state = .failed
        case .initial:
            break
        default:
            self.state = .backing
            self.backToInitialOffset()
        }
    }

    private func backToInitialOffset() {
        guard let sv: UIScrollView = self.scrollView else { return }

        let initialOffset: CGPoint = {
            switch self.position {
            case .top: return sv.contentOffset.replaced(
                    y: -(scrollViewInitialEffectiveInsets.top)
            )
            case .bottom:return sv.contentOffset.replaced(
                    y: self.scrollViewInitialEffectiveInsets.bottom + sv.p2r.scrollableHeight
            )
            }
        }()

        /* Start backing */
        let backAnimation = AnimatorAnimation(property: AnimatorProperty(obj: sv,
                                                                         keyPath: #keyPath(UIScrollView.contentOffset),
                                                                         value: initialOffset),
                                              completion: { [weak self] (isFinished: Bool) in
                                                  guard let `self`: RxPullToRefresh = self else { return }
                                                  self.debug?.log(true, .simple, "🍄", ["isFinished: \(isFinished)"])
                                                  guard isFinished else { return }
                                                  self.state = .initial
                                              })
        /* Stop animation */
        self.animator?.abort()
        self.animator = nil
        /* Start animation */
        self.isForciblyRefreshing = true
        sv.bounces = false
        self.animator = Animator()
        self.animator?.animate(animations: [backAnimation],
                               completion: { [weak self] (isFinishedAll: Bool) in
                                   guard let `self`: RxPullToRefresh = self,
                                         let sv: UIScrollView = self.scrollView else { return }
                                   self.debug?.log(true, .simple, "🍄", ["isFinishedAll: \(isFinishedAll)"])
                                   self.isForciblyRefreshing = false
                                   sv.bounces = true
                               })
    }
}
