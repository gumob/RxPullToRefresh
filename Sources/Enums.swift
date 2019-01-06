//
//  Enums.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation

/**
 An Enumerations indicating the position of a RxPullToRefresh object.
 */
public enum RxPullToRefreshPosition {
    /** A position value for a header. */
    case top
    /** A position value for a footer. */
    case bottom
    /** A position value at the opposite position of a current RxPullToRefresh object. */
    var opposite: RxPullToRefreshPosition {
        switch self {
        case .top: return .bottom
        case .bottom: return .top
        }
    }
}

/**
 An Enumerations indicating scrolling status.
 */
@objc public enum RxPullToRefreshState: Int {
    /** A state indicating that a view is not being dragged by user and not scrolling. */
    case initial
    /** A state indicating that a view is being dragged by user. */
    case pulling
    /** A state indicating that user is dragging a view and an offset is over threshold. */
    case overThreshold
    /** A state indicating that user is stop dragging a view and an offset is moved to threshold. */
    case loading
    /** A state indicating that loading is finished. ⚠️To change state to RxPullToRefreshState.finish, you need to explicitly call UIScrollView.p2r.endAllRefreshing(), UIScrollView.p2r.endRefreshing(at:), or RxPullToRefresh.endRefreshing(). */
    case finished
    /** A state indicating that loading is failed. ⚠️To change state to RxPullToRefreshState.failed, you need to explicitly call UIScrollView.p2r.failRefreshing(at:), or RxPullToRefresh.failRefreshing(). */
    case failed
    /** A state indicating that a view is backing to a default offset. */
    case backing
}

extension RxPullToRefreshState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .initial: return "initial"
        case .pulling: return "pulling"
        case .overThreshold: return "overThreshold"
        case .loading: return "loading"
        case .finished: return "finished"
        case .failed: return "failed"
        case .backing: return "backing"
        }
    }
}

extension RxPullToRefreshState: Equatable {
    public static func == (a: RxPullToRefreshState, b: RxPullToRefreshState) -> Bool {
        switch (a, b) {
        case (.initial, .initial): return true
        case (.pulling, .pulling): return true
        case (.overThreshold, .overThreshold): return true
        case (.loading, .loading): return true
        case (.finished, .finished): return true
        case (.failed, .failed): return true
        case (.backing, .backing): return true
        default: return false
        }
    }
}

/**
 An enumeration for animation presets indicating duration and velocity when loading and backing.
 */
public enum RxPullToRefreshAnimationType {
    /**
     A linear animation preset.

     - parameter duration: The total duration of the animations, measured in seconds.
     */
    case linear(duration: TimeInterval)
    /**
     A spring animation preset.

     - parameter duration: The total duration of the animations, measured in seconds.
     */
    case spring(duration: TimeInterval)
    /**
     A customizable animation preset. See [the Apple doc](https://developer.apple.com/documentation/uikit/uiview/1622594-animatewithduration) for more information.

     - parameter duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
     - parameter delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
     - parameter damping: The damping ratio for the spring animation as it approaches its quiescent state.
     - parameter velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
     - parameter options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see [UIViewAnimationOptions](https://developer.apple.com/documentation/uikit/uiviewanimationoptions?language=objc).
     */
    case custom(duration: TimeInterval,
                delay: TimeInterval,
                springDamping: CGFloat,
                initialSpringVelocity: CGFloat,
                options: UIView.AnimationOptions)

    var option: RxPullToRefreshAnimationOption {
        switch self {
        case .custom(let duration,
                     let delay,
                     let damping,
                     let velocity,
                     let options):
            return RxPullToRefreshAnimationOption(duration,
                                                  delay,
                                                  damping,
                                                  velocity,
                                                  options)
        case .spring(let duration):
            return RxPullToRefreshAnimationOption(duration, 0.0, 0.4, 0.8, [.curveLinear])
        case .linear(let duration):
            return RxPullToRefreshAnimationOption(duration, 0.0, 1.0, 0.2, [.curveLinear])
        }
    }
}

/**
 A struct for animation options.
 */
internal struct RxPullToRefreshAnimationOption {
    /** A TimeInterval value indicating animation duration. */
    var duration: TimeInterval
    /** A TimeInterval value indicating a delay to wait before beginning the animations. */
    var delay: TimeInterval
    /** A CGFloat value indicating a spring damping. */
    var damping: CGFloat
    /** A CGFloat value indicating an initial spring velocity. */
    var velocity: CGFloat
    /** A AnimationOptions value indicating animation options. */
    var options: UIView.AnimationOptions

    /**
     A function for initialization.

     - duration: A TimeInterval value indicating animation duration.
     - delay: A TimeInterval value indicating a delay to wait before beginning the animations.
     - damping: A CGFloat value indicating a spring damping.
     - velocity: A CGFloat value indicating an initial spring velocity.
     - options: A AnimationOptions value indicating animation options.
     */
    init(_ duration: TimeInterval,
         _ delay: TimeInterval,
         _ damping: CGFloat,
         _ velocity: CGFloat,
         _ options: UIView.AnimationOptions) {
        self.duration = duration
        self.delay = delay
        self.damping = damping
        self.velocity = velocity
        self.options = options
    }
}
