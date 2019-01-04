//
//  HelperSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Quick
import Nimble

@testable import RxPullToRefresh

class HelperSpec: QuickSpec {

    override func spec() {
        describe("Spec Helpers") {
            describe("Spec clamp") {
                it("is equal") {
                    expect(clamp(50, 0, 100)).to(equal(50))
                    expect(clamp(-50, 0, 100)).to(equal(0))
                    expect(clamp(150, 0, 100)).to(equal(100))
                    expect(CGFloat(1.23456789).decimal(3)).to(equal(1.235))
                }
            }
            describe("Spec Calculable") {
                it("is equal") {
                    /* CGFloat */
                    expect(CGFloat(2.2222222).decimal(3)).to(equal(CGFloat(2.222)))
                    expect(CGFloat(2.2225555).decimal(3)).to(equal(CGFloat(2.223)))
                    expect(CGFloat(2.0).isAlmostEqual(to: 2.5)).to(beTrue())
                    expect(CGFloat(2.0).isAlmostEqual(to: 1.5)).to(beTrue())
                    expect(CGFloat(2.0).isAlmostEqual(to: 3.5)).to(beFalse())
                    expect(CGFloat(2.0).distance(to: CGFloat(3.0))).to(equal(CGFloat(1.0)))
                    /* CGPoint */
                    expect(CGPoint(x: 2.0, y: 2.0) + CGPoint(x: 1.0, y: 1.0)).to(equal(CGPoint(x: 3.0, y: 3.0)))
                    expect(CGPoint(x: 2.0, y: 2.0) - CGPoint(x: 1.0, y: 1.0)).to(equal(CGPoint(x: 1.0, y: 1.0)))
                    var point: CGPoint = CGPoint(x: 2.0, y: 2.0)
                    point += CGPoint(x: 1.0, y: 1.0)
                    expect(point).to(equal(CGPoint(x: 3.0, y: 3.0)))
                    point -= CGPoint(x: 1.0, y: 1.0)
                    expect(point).to(equal(CGPoint(x: 2.0, y: 2.0)))
                    point /= 2.0
                    expect(point).to(equal(CGPoint(x: 1.0, y: 1.0)))
                    expect(CGPoint(x: 2.2222222, y: 2.2222222).decimal(3)).to(equal(CGPoint(x: 2.222, y: 2.222)))
                    expect(CGPoint(x: 2.2225555, y: 2.2225555).decimal(3)).to(equal(CGPoint(x: 2.223, y: 2.223)))
                    expect(CGPoint(x: 2.0, y: 2.0).isAlmostEqual(to: CGPoint(x: 2.5, y: 2.5))).to(beTrue())
                    expect(CGPoint(x: 2.0, y: 2.0).isAlmostEqual(to: CGPoint(x: 1.5, y: 1.5))).to(beTrue())
                    expect(CGPoint(x: 2.0, y: 2.0).isAlmostEqual(to: CGPoint(x: 2.0, y: 3.5))).to(beFalse())
                    expect(CGPoint(x: 2.0, y: 2.0).distance(to: CGPoint(x: 2.0, y: 3.0))).to(equal(CGFloat(1.0)))
                    /* UIEdgeInsets */
                    expect(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0) + UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
                            .to(equal(UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)))
                    expect(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0) - UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
                            .to(equal(UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)))
                    var insets: UIEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
                    insets += UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
                    expect(insets).to(equal(UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)))
                    insets -= UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
                    expect(insets).to(equal(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)))
                    insets /= 2.0
                    expect(insets).to(equal(UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)))
                    expect(UIEdgeInsets(top: 2.2222222, left: 2.2222222, bottom: 2.2222222, right: 2.2222222).decimal(3))
                            .to(equal(UIEdgeInsets(top: 2.222, left: 2.222, bottom: 2.222, right: 2.222)))
                    expect(UIEdgeInsets(top: 2.2225555, left: 2.2225555, bottom: 2.2225555, right: 2.2225555).decimal(3))
                            .to(equal(UIEdgeInsets(top: 2.223, left: 2.223, bottom: 2.223, right: 2.223)))
                    expect(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0).isAlmostEqual(to: UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)))
                            .to(beTrue())
                    expect(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0).isAlmostEqual(to: UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5)))
                            .to(beTrue())
                    expect(UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0).isAlmostEqual(to: UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 3.5)))
                            .to(beFalse())
                }
            }
            describe("Spec CGPoint Normalizer") {
                it("is equal") {
                    let point: CGPoint = CGPoint(x: 0, y: 0)
                    let insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                    let pointNormalized: CGPoint = point.normalize(from: insets)
                    let pointReverted: CGPoint = pointNormalized.revert(to: insets)
                    expect(point).to(equal(pointReverted))
                    expect(pointNormalized).to(equal(CGPoint(x: 0, y: 10)))
                    expect(pointReverted).to(equal(CGPoint(x: 0, y: 0)))
                    expect(point).notTo(equal(pointNormalized))
                    expect(pointNormalized).notTo(equal(pointReverted))
                }
            }
            describe("Spec CGPoint Geometry") {
                it("is equal") {
                    let point0: CGPoint = CGPoint(x: 10, y: 10)
                    let point1: CGPoint = CGPoint(x: 10, y: 10)
                    let pointReplace: CGPoint = point0.replaced(x: 0, y: 0)
                    let pointAdd: CGPoint = point0.add(x: 10, y: 10)
                    let pointSubtract: CGPoint = point0.subtract(x: 10, y: 10)
                    let pointPlus: CGPoint = point0 + point1
                    let pointMinus: CGPoint = point0 - point1
                    expect(pointReplace).to(equal(CGPoint.zero))
                    expect(pointAdd).to(equal(CGPoint(x: 20, y: 20)))
                    expect(pointSubtract).to(equal(CGPoint.zero))
                    expect(pointPlus).to(equal(CGPoint(x: 20, y: 20)))
                    expect(pointMinus).to(equal(CGPoint.zero))
                }
            }
            describe("Spec CGSize Geometry") {
                it("is equal") {
                    let size0: CGSize = CGSize(width: 10, height: 10)
                    var size1: CGSize = CGSize(width: 10, height: 10)
                    let sizeReplace: CGSize = size0.replaced(width: 0, height: 0)
                    size1.replace(width: 0, height: 0)
                    expect(sizeReplace).to(equal(CGSize.zero))
                    expect(size1).to(equal(CGSize.zero))
                }
            }
            describe("Spec CGRect Geometry") {
                it("is equal") {
                    let rect0: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
                    var rect1: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
                    let rectReplace: CGRect = rect0.replaced(width: 1, height: 1)
                    rect1.replace(width: 1, height: 1)
                    expect(rectReplace).to(equal(CGRect(x: 0, y: 0, width: 1, height: 1)))
                    expect(rect1).to(equal(CGRect(x: 0, y: 0, width: 1, height: 1)))
                }
            }
            describe("Spec UIEdgeInsets Geometry") {
                it("is equal") {
                    let inset0: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                    let inset1: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    let insetReplace: UIEdgeInsets = inset0.replaced(top: 0, bottom: 0)
                    let insetPlus: UIEdgeInsets = inset0 + inset1
                    let insetMinus: UIEdgeInsets = inset0 - inset1
                    expect(insetReplace).to(equal(UIEdgeInsets.zero))
                    expect(insetPlus).to(equal(UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)))
                    expect(insetMinus).to(equal(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)))
                }
            }
        }
    }

}
