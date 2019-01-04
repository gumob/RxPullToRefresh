//
//  Animator.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2019/01/02.
//  Copyright © 2019 Gumob. All rights reserved.
//

import Foundation
import UIKit

internal enum AnimatorState {
    case ready, running, finished, aborted
}

internal protocol ValueAnimatable {
    associatedtype ValueType: Calculable

    var obj: NSObject? { set get }
    var keyPath: String { set get }
    var value: ValueType { set get }
    var scalar: CGFloat { set get }
    var isFinished: Bool { set get }

    mutating func animate()
}

extension ValueAnimatable {
    mutating func animate() {
        guard let obj: NSObject = self.obj,
              var currentValue: ValueType = obj.value(forKeyPath: self.keyPath) as? ValueType else { return }
        let targetValue: ValueType = self.value
        currentValue += (targetValue - currentValue) / self.scalar
        if currentValue.isAlmostEqual(to: targetValue) {
            obj.setValue(self.value, forKeyPath: self.keyPath)
            self.isFinished = true
        } else {
            obj.setValue(currentValue, forKeyPath: self.keyPath)
        }
    }
}

internal class AnimatorProperty: ValueAnimatable {
    typealias ValueType = CGPoint

    weak internal var obj: NSObject?
    internal var keyPath: String
    internal var value: ValueType
    internal var scalar: CGFloat
    var isFinished: Bool = false

    init(obj: NSObject, keyPath: String, value: ValueType, scalar: CGFloat = 3) {
        self.obj = obj
        self.keyPath = keyPath
        self.value = value
        self.scalar = scalar
    }
}

internal class AnimatorAnimation {
    internal private(set) var properties: [AnimatorProperty] = [AnimatorProperty]()
    internal private(set) var update: (() -> Void)?
    internal private(set) var completion: ((Bool) -> Void)?
    fileprivate(set) var state: AnimatorState = .ready

    init(properties: [AnimatorProperty],
         update: (() -> Void)? = nil,
         completion: ((Bool) -> Void)? = nil) {
        self.properties = properties
        self.update = update
        self.completion = completion
    }

    init(property: AnimatorProperty,
         update: (() -> Void)? = nil,
         completion: ((Bool) -> Void)? = nil) {
        self.properties = [property]
        self.update = update
        self.completion = completion
    }
}

internal class Animator {

    internal private(set) var state: AnimatorState = .ready
    internal private(set) var index: Int = 0
    internal private(set) var animations: [AnimatorAnimation] = [AnimatorAnimation]()
    internal private(set) var completionHandler: ((Bool) -> Void)?

    private var displayLink: CADisplayLink?

    deinit {
        self.abort()
        self.animations.removeAll()
    }

    internal func animate(animations: [AnimatorAnimation],
                          completion: ((Bool) -> Void)? = nil) {
        self.animations = animations
        self.completionHandler = completion
        self.state = .ready
        self.start()
    }

    private func start() {
        guard self.state == .ready, self.displayLink == nil else { return }

        /* Prepare interval animation */
        self.displayLink = CADisplayLink(target: self, selector: #selector(Animator.update))

        /* Define frame rate */
        if #available(iOS 10.0, *) {
            self.displayLink?.preferredFramesPerSecond = 60
        } else {
            let framePerSecond: TimeInterval = 60.0
            self.displayLink?.frameInterval = Int(60.0 / framePerSecond)
        }

        /* Start interval */
        self.state = .running
        let mode: RunLoop.Mode = RunLoop.Mode.common
        self.displayLink?.add(to: RunLoop.current, forMode: mode)
    }

    @objc private func update(displayLink: CADisplayLink) {
        guard self.state == .running && self.index < self.animations.count,
              let currentAnimation: AnimatorAnimation = self.animations[safe: self.index] else {
            self.stop()
            return
        }

        /* Change state */
        if currentAnimation.state == .ready {
            currentAnimation.state = .running
        }

        /* Animate properties */
        for var prop in currentAnimation.properties {
            if !prop.isFinished { prop.animate() }
        }

        /* Callback */
        currentAnimation.update?()

        /* Check whether all property animations are finished. */
        if !(currentAnimation.properties.map { $0.isFinished }).contains(false) {

            /* Change state */
            currentAnimation.state = .finished

            /* Callback */
            currentAnimation.completion?(true)

            /* Proceed to next animation */
            self.index += 1
        }
    }

    private func stop() {
        guard self.state == .ready || self.state == .running else { return }

        /* Change state */
        self.state = .finished

        /* Clear interval */
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }

        /* Callback */
        self.completionHandler?(true)
    }

    internal func abort() {
        guard self.state == .ready || self.state == .running else { return }

        /* Change state */
        self.state = .aborted
        self.animations.forEach {
            if $0.state == .ready || $0.state == .running {
                $0.state = .aborted
            }
        }

        /* Clear interval */
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }

        /* Callback */
        if let currentAnimation: AnimatorAnimation = self.animations[safe: self.index] {
            currentAnimation.completion?(false)
        }
        self.completionHandler?(false)
    }
}
