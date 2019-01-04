//
//  UIScrollView+RxPullToRefresh.swift
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
public extension UIScrollView {

    fileprivate struct Keys {
        static var topPullToRefresh: String = "com.gumob.RxPullToRefresh.topPullToRefresh"
        static var bottomPullToRefresh: String = "com.gumob.RxPullToRefresh.bottomPullToRefreshKey"
    }

    /**
     A RxPullToRefresh object placed at the top.
     */
    private(set) var topPullToRefresh: RxPullToRefresh? {
        get { return objc_getAssociatedObject(self, &Keys.topPullToRefresh) as? RxPullToRefresh }
        set { objc_setAssociatedObject(self, &Keys.topPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     A RxPullToRefresh object placed at the bottom.
     */
    private(set) var bottomPullToRefresh: RxPullToRefresh? {
        get { return objc_getAssociatedObject(self, &Keys.bottomPullToRefresh) as? RxPullToRefresh }
        set { objc_setAssociatedObject(self, &Keys.bottomPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

}

//extension UIScrollView {
//    override open func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        if superview == nil {
//            self.endAllRefreshing()
//            self.removeAllPullToRefresh()
//        }
//    }
//}

public extension UIScrollView {
    /**
     A function to add a RxPullToRefresh object to a UIScrollView.

     - parameter pullToRefresh: A RxPullToRefresh object being added to a UIScrollView.
     */
    func addPullToRefresh(_ pullToRefresh: RxPullToRefresh) {
        pullToRefresh.scrollView = self

        let refreshView: RxPullToRefreshView = pullToRefresh.refreshView
        switch pullToRefresh.position {
        case .top:
            self.removePullToRefresh(at: .top)
            self.topPullToRefresh = pullToRefresh
        case .bottom:
            self.removePullToRefresh(at: .bottom)
            self.bottomPullToRefresh = pullToRefresh
        }
        self.addSubview(refreshView)
        self.sendSubviewToBack(refreshView)

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
        case .top: return self.topPullToRefresh
        case .bottom: return self.bottomPullToRefresh
        }
    }

    /**
     A function to remove a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func removePullToRefresh(at position: RxPullToRefreshPosition) {
        switch position {
        case .top:
            self.topPullToRefresh?.refreshView.removeFromSuperview()
            self.topPullToRefresh = nil
        case .bottom:
            self.bottomPullToRefresh?.refreshView.removeFromSuperview()
            self.bottomPullToRefresh = nil
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
        case .top: self.topPullToRefresh?.startRefreshing()
        case .bottom: self.bottomPullToRefresh?.startRefreshing()
        }
    }

    /**
     A function to end refreshing a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func endRefreshing(at position: RxPullToRefreshPosition) {
        switch position {
        case .top: self.topPullToRefresh?.endRefreshing()
        case .bottom: self.bottomPullToRefresh?.endRefreshing()
        }
    }

    /**
     A function to fail refreshing a RxPullToRefresh object placed at a specific position.

     - parameter position: A position of RxPullToRefresh object.
     */
    func failRefreshing(at position: RxPullToRefreshPosition) {
        switch position {
        case .top: self.topPullToRefresh?.failRefreshing()
        case .bottom: self.bottomPullToRefresh?.failRefreshing()
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

internal extension UIScrollView {

    /** A CGFloat indicating a scrollable height. */
    var scrollableHeight: CGFloat { return max(0.0, self.contentSize.height - self.frame.height) }

    /** A Function indicating whether a RxPullToRefresh object can be enabled. */
    func canBeEnabled(at position: RxPullToRefreshPosition) -> Bool {
        switch position {
        case .top: return self.contentSize.height > 0.0
        case .bottom: return self.contentSize.height > self.frame.height
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
        return self.contentOffset.normalize(from: self.effectiveContentInset)
    }

    /**
     A UIEdgeInsets value indicating a effective content offset depending on the contentInsetAdjustmentBehavior value.
     */
    var effectiveContentInset: UIEdgeInsets {
        if #available(iOS 11, *) { return self.adjustedContentInset } else { return self.contentInset }
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
                          case .bottom: return contentSize.height
                          }
                      }(),
                      width: self.frame.width,
                      height: refreshView.frame.height)
    }

}
