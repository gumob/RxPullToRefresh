//
//  RxPullToRefreshDelegate.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/29.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation

/** The interface for handling actions in a RxPullToRefresh object. */
@objc public protocol RxPullToRefreshDelegate: NSObjectProtocol {
    /**
     A delegate method that called each time a user performs an action.

     - parameter state: A RxPullToRefreshState value.
     - parameter progress: A CGFloat value indicating a progress rate. The value is limited to between 0 and 1.
     - parameter scroll: A CGFloat value indicating a scroll rate. The value is limited to between 0 and 1.
     */
    func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)
}

//public extension RxPullToRefreshDelegate {
//    func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {}
//}
