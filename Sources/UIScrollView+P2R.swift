//
//  UIScrollView+Proxy.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

/**
  An extension UIScrollView to manage RxPullToRefresh objects.
 */
internal extension UIScrollView {
    fileprivate struct Keys {
        static var topPullToRefresh: String = "com.gumob.RxPullToRefresh.topPullToRefresh"
        static var bottomPullToRefresh: String = "com.gumob.RxPullToRefresh.bottomPullToRefreshKey"
    }

    /**
     A RxPullToRefresh object placed at the top.
     */
    var topPullToRefresh: RxPullToRefresh? {
        get { return objc_getAssociatedObject(self, &Keys.topPullToRefresh) as? RxPullToRefresh }
        set { objc_setAssociatedObject(self, &Keys.topPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     A RxPullToRefresh object placed at the bottom.
     */
    var bottomPullToRefresh: RxPullToRefresh? {
        get { return objc_getAssociatedObject(self, &Keys.bottomPullToRefresh) as? RxPullToRefresh }
        set { objc_setAssociatedObject(self, &Keys.bottomPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

//public extension UIScrollView {
public extension RxPullToRefreshProxy where Base: UIScrollView {
    /**
     A function to add a RxPullToRefresh object to a UIScrollView.

     - parameter pullToRefresh: A RxPullToRefresh object being added to a UIScrollView.
     */
    func addPullToRefresh(_ pullToRefresh: RxPullToRefresh) {
        pullToRefresh.scrollView = self.base

        let refreshView: RxPullToRefreshView = pullToRefresh.refreshView
        switch pullToRefresh.position {
        case .top:
            self.removePullToRefresh(at: .top)
            self.base.topPullToRefresh = pullToRefresh
        case .bottom:
            self.removePullToRefresh(at: .bottom)
            self.base.bottomPullToRefresh = pullToRefresh
        }
        self.base.addSubview(refreshView)
        self.base.sendSubviewToBack(refreshView)

        refreshView.frame = self.defaultFrame(for: pullToRefresh)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.autoresizingMask = [.flexibleWidth]
    }

    /**
     A function to get a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     - returns: A RxPullToRefresh object.
     */
    func getPullToRefresh(at position: RxPullToRefreshPosition) -> RxPullToRefresh? {
        switch position {
        case .top: return self.base.topPullToRefresh
        case .bottom: return self.base.bottomPullToRefresh
        }
    }

    /**
     A function to remove a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func removePullToRefresh(at position: RxPullToRefreshPosition) {
        switch position {
        case .top:
            self.base.topPullToRefresh?.refreshView.removeFromSuperview()
            self.base.topPullToRefresh = nil
        case .bottom:
            self.base.bottomPullToRefresh?.refreshView.removeFromSuperview()
            self.base.bottomPullToRefresh = nil
        }
    }

    /**
     A function to remove all RxPullToRefresh objects.
     */
    func removeAllPullToRefresh() {
        self.removePullToRefresh(at: .top)
        self.removePullToRefresh(at: .bottom)
    }

    /**
     A function to start refreshing a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func startRefreshing(at position: RxPullToRefreshPosition) {
        switch position {
        case .top: self.base.topPullToRefresh?.startRefreshing()
        case .bottom: self.base.bottomPullToRefresh?.startRefreshing()
        }
    }

    /**
     A function to end refreshing a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func endRefreshing(at position: RxPullToRefreshPosition) {
        switch position {
        case .top: self.base.topPullToRefresh?.endRefreshing()
        case .bottom: self.base.bottomPullToRefresh?.endRefreshing()
        }
    }

    /**
     A function to fail refreshing a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func failRefreshing(at position: RxPullToRefreshPosition) {
        switch position {
        case .top: self.base.topPullToRefresh?.failRefreshing()
        case .bottom: self.base.bottomPullToRefresh?.failRefreshing()
        }
    }

    /**
     A function to end refreshing all RxPullToRefresh objects.
     */
    func endAllRefreshing() {
        self.endRefreshing(at: .top)
        self.endRefreshing(at: .bottom)
    }

}

//internal extension UIScrollView {
internal extension RxPullToRefreshProxy where Base: UIScrollView {

    /** A CGFloat indicating a scrollable height. */
    var scrollableHeight: CGFloat { return max(0.0, self.base.contentSize.height - self.base.frame.height) }

    /** A Function indicating whether a RxPullToRefresh object can be enabled. */
    func canBeEnabled(at position: RxPullToRefreshPosition) -> Bool {
        switch position {
        case .top: return self.base.contentSize.height > 0.0
        case .bottom: return self.base.contentSize.height > self.base.frame.height
        }
    }

    /** A Function indicating a content offset relative to a refresh view. */
    func relativeContentOffset(for position: RxPullToRefreshPosition) -> CGPoint {
        switch position {
        case .top:    return self.normalizedContentOffset
        case .bottom: return self.normalizedContentOffset.subtract(
                y: self.effectiveContentInset.top + self.scrollableHeight + self.effectiveContentInset.bottom
        )
        }
    }

    /**
     A CGPoint value indicating a normalized content offset depending on the effectiveContentInset value.
     */
    var normalizedContentOffset: CGPoint {
        return self.base.contentOffset.normalize(from: self.effectiveContentInset)
    }

    /**
     A UIEdgeInsets value indicating a effective content offset depending on the contentInsetAdjustmentBehavior value.
     */
    var effectiveContentInset: UIEdgeInsets {
        if #available(iOS 11, *) { return self.base.adjustedContentInset } else { return self.base.contentInset }
    }

    /**
     A function to get the frame size of a RxPullToRefresh object.

     - parameter pullToRefresh: A RxPullToRefresh object.
     - returns: A default frame size.
     */
    func defaultFrame(for pullToRefresh: RxPullToRefresh) -> CGRect {
        let refreshView: RxPullToRefreshView = pullToRefresh.refreshView
        return CGRect(x: 0,
                      y: {
                          switch pullToRefresh.position {
                          case .top: return -refreshView.frame.size.height
                          case .bottom: return self.base.contentSize.height
                          }
                      }(),
                      width: self.base.frame.width,
                      height: refreshView.frame.height)
    }

}
