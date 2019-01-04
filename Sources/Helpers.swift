//
//  Helpers.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/17.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

/**
 Functions to clamp numbers
 */
internal func clamp<T: Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
    if value < lower { return lower }
    if value > upper { return upper }
    return value
}

/**
 Calculable protocol
 */
internal protocol Calculable {
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, scalar: CGFloat) -> Self
    static func += (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, scalar: CGFloat)
    func decimal(_ digit: Int) -> Self
    func rounded() -> Self
    func isAlmostEqual(to: Self) -> Bool
}

extension CGFloat: Calculable {
    func decimal(_ digit: Int) -> CGFloat {
        var val: CGFloat = 1.0
        val += 1.0
        let d: CGFloat = pow(10.0, CGFloat(digit))
        return (self * d).rounded() / d
    }

    func isAlmostEqual(to: CGFloat) -> Bool {
        return self.rounded() == to.rounded() || abs(self.distance(to: to)) < 1.0
    }
}

extension CGPoint: Calculable {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func / (lhs: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / scalar, y: lhs.y / scalar)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    static func /= (lhs: inout CGPoint, scalar: CGFloat) {
        lhs = lhs / scalar
    }

    func decimal(_ digit: Int) -> CGPoint {
        return CGPoint(x: self.x.decimal(digit), y: self.y.decimal(digit))
    }

    func rounded() -> CGPoint {
        return CGPoint(x: self.x.rounded(), y: self.y.rounded())
    }

    func isAlmostEqual(to: CGPoint) -> Bool {
        return self.rounded() == to.rounded() || abs(self.distance(to: to)) < 1.0
    }

    func distance(to: CGPoint) -> CGFloat {
        return hypot(to.x - self.x, to.y - self.y)
    }
}

extension UIEdgeInsets: Calculable {
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }

    static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top - rhs.top,
                            left: lhs.left - rhs.left,
                            bottom: lhs.bottom - rhs.bottom,
                            right: lhs.right - rhs.right)
    }

    static func / (lhs: UIEdgeInsets, scalar: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top / scalar,
                            left: lhs.left / scalar,
                            bottom: lhs.bottom / scalar,
                            right: lhs.right / scalar)
    }

    static func += (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
        lhs = lhs - rhs
    }

    static func /= (lhs: inout UIEdgeInsets, scalar: CGFloat) {
        lhs = lhs / scalar
    }

    func decimal(_ digit: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top.decimal(digit),
                            left: self.left.decimal(digit),
                            bottom: self.bottom.decimal(digit),
                            right: self.right.decimal(digit))
    }

    func rounded() -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top.rounded(),
                            left: self.left.rounded(),
                            bottom: self.bottom.rounded(),
                            right: self.right.rounded())
    }

    func isAlmostEqual(to: UIEdgeInsets) -> Bool {
        let condTop: Bool = abs(self.top.distance(to: to.top)) < 1.0
        let condBottom: Bool = abs(self.bottom.distance(to: to.bottom)) < 1.0
        let condLeft: Bool = abs(self.left.distance(to: to.left)) < 1.0
        let condRight: Bool = abs(self.right.distance(to: to.right)) < 1.0
        return self.rounded() == to.rounded() || (condTop && condBottom && condLeft && condRight)
    }
}

/**
 Functions to calculate geometry
 */
internal extension CGPoint {
    func replaced(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
        return CGPoint(x: x ?? self.x, y: y ?? self.y)
    }

    @discardableResult
    mutating func replace(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
        self.x = x ?? self.x
        self.y = y ?? self.y
        return self
    }

    func add(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }

    func subtract(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: self.x - x, y: self.y - y)
    }
}

internal extension CGSize {
    func replaced(width: CGFloat? = nil,
                  height: CGFloat? = nil) -> CGSize {
        return CGSize(width: width ?? self.width,
                      height: height ?? self.height)
    }

    @discardableResult
    mutating func replace(width: CGFloat? = nil,
                          height: CGFloat? = nil) -> CGSize {
        self.width = width ?? self.width
        self.height = height ?? self.height
        return self
    }
}

internal extension CGRect {
    func replaced(x: CGFloat? = nil,
                  y: CGFloat? = nil,
                  width: CGFloat? = nil,
                  height: CGFloat? = nil) -> CGRect {
        return CGRect(x: x ?? self.origin.x,
                      y: y ?? self.origin.y,
                      width: width ?? self.size.width,
                      height: height ?? self.size.height)
    }

    @discardableResult
    mutating func replace(x: CGFloat? = nil,
                          y: CGFloat? = nil,
                          width: CGFloat? = nil,
                          height: CGFloat? = nil) -> CGRect {
        self.origin.replace(x: x, y: y)
        self.size.replace(width: width, height: height)
        return self
    }
}

internal extension UIEdgeInsets {
    func replaced(top: CGFloat? = nil,
                  left: CGFloat? = nil,
                  bottom: CGFloat? = nil,
                  right: CGFloat? = nil) -> UIEdgeInsets {
        return UIEdgeInsets(top: top ?? self.top,
                            left: left ?? self.left,
                            bottom: bottom ?? self.bottom,
                            right: right ?? self.right)
    }
}

/**
 Functions to normalize a content offset with content insets of UIScrollView.
 */
internal extension CGPoint {
    /**
     A Function normalizing content offset.
     */
    func normalize(from inset: UIEdgeInsets) -> CGPoint {
        return self.add(x: inset.left, y: inset.top)
    }

    /**
     A Function reverting a normalized content offset.
     */
    func revert(to inset: UIEdgeInsets) -> CGPoint {
        return self.subtract(x: inset.left, y: inset.top)
    }
}

extension Array {
    /**
     A Function to safely subscript an element from an Array.
     */
    internal subscript(safe index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
}
