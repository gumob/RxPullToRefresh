//
//  AnimatorSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2019/01/03.
//  Copyright © 2019 Gumob. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import RxPullToRefresh

class AnimatorSpec: QuickSpec {

    override func spec() {
        describe("Spec Animator") {
            var scrollView: UIScrollView!
            var initialContentOffset: CGPoint!
            var animator: Animator!
            var animations: [AnimatorAnimation]!

            beforeEach {
                scrollView = UIScrollView()
                scrollView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                scrollView.contentSize = CGSize(width: 100, height: 10000)
                initialContentOffset = scrollView.contentOffset
                animator = Animator()
            }

            it("Normal") {
                animations = [
                    AnimatorAnimation(properties: [AnimatorProperty(obj: scrollView, keyPath: #keyPath(UIScrollView.contentOffset),
                                                                    value: CGPoint(x: 0, y: -100),
                                                                    scalar: 4)],
                                      update: {
                                          expect(scrollView.contentOffset).notTo(equal(initialContentOffset))
                                      },
                                      completion: { (isFinished: Bool) in
                                          expect(isFinished).to(beTrue())
                                          expect(scrollView.contentOffset).to(equal(CGPoint(x: 0, y: -100)))
                                      }),
                    AnimatorAnimation(properties: [AnimatorProperty(obj: scrollView, keyPath: #keyPath(UIScrollView.contentOffset),
                                                                    value: CGPoint(x: 0, y: -200),
                                                                    scalar: 4)],
                                      update: {
                                          expect(scrollView.contentOffset).notTo(equal(initialContentOffset))
                                      },
                                      completion: { (isFinished: Bool) in
                                          expect(isFinished).to(beTrue())
                                          expect(scrollView.contentOffset).to(equal(CGPoint(x: 0, y: -200)))
                                      })
                ]
                expect(animator.state).toEventually(equal(AnimatorState.ready), timeout: 30)
                animator.animate(animations: animations,
                                 completion: { (isFinishedAll: Bool) in
                                     expect(isFinishedAll).to(beTrue())
                                     expect(scrollView.contentOffset).to(equal(CGPoint(x: 0, y: -200)))
                                 })
                expect(animator.state).toEventually(equal(AnimatorState.running), timeout: 30)
                expect(animator.state).toEventually(equal(AnimatorState.finished), timeout: 30)
            }
            it("Abort") {
                animations = [
                    AnimatorAnimation(properties: [AnimatorProperty(obj: scrollView, keyPath: #keyPath(UIScrollView.contentOffset),
                                                                    value: CGPoint(x: 0, y: -100),
                                                                    scalar: 4)],
                                      update: {
                                          expect(scrollView.contentOffset).notTo(equal(initialContentOffset))
                                      },
                                      completion: { (isFinished: Bool) in
                                          expect(isFinished).to(beFalse())
                                          expect(scrollView.contentOffset).notTo(equal(CGPoint(x: 0, y: -100)))
                                      }),
                    AnimatorAnimation(properties: [AnimatorProperty(obj: scrollView, keyPath: #keyPath(UIScrollView.contentOffset),
                                                                    value: CGPoint(x: 0, y: -200),
                                                                    scalar: 4)],
                                      update: {
                                          expect(scrollView.contentOffset).notTo(equal(initialContentOffset))
                                      },
                                      completion: { (isFinished: Bool) in
                                          expect(isFinished).to(beFalse())
                                          expect(scrollView.contentOffset).notTo(equal(CGPoint(x: 0, y: -200)))
                                      })
                ]
                expect(animator.state).toEventually(equal(AnimatorState.ready), timeout: 30)
                animator.animate(animations: animations,
                                 completion: { (isFinishedAll: Bool) in
                                     expect(isFinishedAll).to(beFalse())
                                     expect(scrollView.contentOffset).notTo(equal(CGPoint(x: 0, y: -200)))
                                 })

                expect(animator.state).toEventually(equal(AnimatorState.running), timeout: 30)
                animator.abort()
                expect(animator.state).toEventually(equal(AnimatorState.aborted), timeout: 30)
            }
        }
    }

}
