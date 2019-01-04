//
//  RxPullToRefreshView.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit

/**
  A protocol to customize RxPullToRefreshView.
 */
internal protocol RxPullToRefreshAnimatable {
    var canLoadMore: Bool { set get }
    func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat)
}

/**
  A base class to customize a refresh view conforming to RxPullToRefreshAnimatable.
 */
open class RxPullToRefreshView: UIView, RxPullToRefreshAnimatable {
    /**
     A Boolean value indicating whether the view can load more content.
     */
    @objc open dynamic internal(set) var canLoadMore: Bool = true
    /**
     A function that called each time a user performs an action.

     - parameter state: A RxPullToRefreshState value.
     - parameter progress: A CGFloat value indicating a progress rate. The value is limited to between 0 and 1.
     - parameter scroll: A CGFloat value indicating a scroll rate. The value is limited to between 0 and 1.
     */
    @objc open dynamic func action(state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) {
        fatalError("You must override this method.")
    }
}
