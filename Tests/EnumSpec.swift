//
//  EnumSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2018/12/15.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Quick
import Nimble

@testable import RxPullToRefresh

class EnumSpec: QuickSpec {

    override func spec() {
        describe("Spec RxPullToRefreshPosition") {
            describe("Spec RxPullToRefreshPosition") {
                it("is equal") {
                    let top: RxPullToRefreshPosition = RxPullToRefreshPosition.top
                    let bottom: RxPullToRefreshPosition = RxPullToRefreshPosition.bottom
                    expect(top.opposite).to(equal(bottom))
                    expect(bottom.opposite).to(equal(top))
                }
            }
            describe("Spec RxPullToRefreshState") {
                it("is equal") {
                    expect(RxPullToRefreshState.initial.description).to(equal("initial"))
                    expect(RxPullToRefreshState.pulling.description).to(equal("pulling"))
                    expect(RxPullToRefreshState.overThreshold.description).to(equal("overThreshold"))
                    expect(RxPullToRefreshState.loading.description).to(equal("loading"))
                    expect(RxPullToRefreshState.finished.description).to(equal("finished"))
                    expect(RxPullToRefreshState.backing.description).to(equal("backing"))

                    expect(RxPullToRefreshState.initial).to(equal(.initial))
                    expect(RxPullToRefreshState.pulling).to(equal(.pulling))
                    expect(RxPullToRefreshState.overThreshold).to(equal(.overThreshold))
                    expect(RxPullToRefreshState.loading).to(equal(.loading))
                    expect(RxPullToRefreshState.finished).to(equal(.finished))
                    expect(RxPullToRefreshState.backing).to(equal(.backing))
                }
                it("is not equal") {
                    expect(RxPullToRefreshState.initial).notTo(equal(.pulling))
                    expect(RxPullToRefreshState.initial).notTo(equal(.overThreshold))
                    expect(RxPullToRefreshState.initial).notTo(equal(.loading))
                    expect(RxPullToRefreshState.initial).notTo(equal(.finished))
                    expect(RxPullToRefreshState.initial).notTo(equal(.backing))
                }
            }
            describe("Spec RxPullToRefreshAnimationType") {
                it("is equal") {
                    let linearType: RxPullToRefreshAnimationType = .linear(duration: 1.0)
                    let springType: RxPullToRefreshAnimationType = .spring(duration: 1.0)
                    let customType: RxPullToRefreshAnimationType = .custom(duration: 1.0,
                                                                           delay: 0.0,
                                                                           springDamping: 0.4,
                                                                           initialSpringVelocity: 0.8,
                                                                           options: [.curveLinear])
                    let linear: RxPullToRefreshAnimationOption = RxPullToRefreshAnimationOption(1.0, 0.0, 1.0, 0.2, [.curveLinear])
                    let spring: RxPullToRefreshAnimationOption = RxPullToRefreshAnimationOption(1.0, 0.0, 0.4, 0.8, [.curveLinear])
                    let custom: RxPullToRefreshAnimationOption = RxPullToRefreshAnimationOption(1.0, 0.0, 0.4, 0.8, [.curveLinear])
                    expect(linearType.option.duration).to(equal(linear.duration))
                    expect(springType.option.duration).to(equal(spring.duration))
                    expect(customType.option.duration).to(equal(custom.duration))
                }
            }
        }
    }

}
