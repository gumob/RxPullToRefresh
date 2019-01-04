//
//  MiscSpec.swift
//  RxPullToRefreshTests
//
//  Created by kojirof on 2018/12/26.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation

import Quick
import Nimble
import RxSwift
import RxTest
import RxBlocking

@testable import RxPullToRefresh

class RxSpec: QuickSpec {

    override func spec() {
        var scrollView: UIScrollView!
        var topRefreshView: RxPullToRefreshView!
        var bottomRefreshView: RxPullToRefreshView!
        var topRefresh: RxPullToRefresh!
        var bottomRefresh: RxPullToRefresh!

        beforeEach {
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            topRefreshView = RxPullToRefreshView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            bottomRefreshView = RxPullToRefreshView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            topRefresh = RxPullToRefresh(refreshView: topRefreshView, position: .top)
            bottomRefresh = RxPullToRefresh(refreshView: bottomRefreshView, position: .bottom)
            topRefresh.scrollView = scrollView
            bottomRefresh.scrollView = scrollView
        }

        describe("Spec RxPullToRefresh") {
            it("isObserving") {
                expect(topRefresh.isObserving).to(beTrue())
                topRefresh.stopObservingScrollView()
                expect(topRefresh.isObserving).to(beFalse())
            }
            it("isVisible") {
                var latest: Bool = true
                let subscription = topRefresh.rx.isVisible
                        .drive(onNext: { (n: Bool) in
                    latest = n
                })
                expect(latest).to(beFalse())

                scrollView.contentSize = CGSize(width: 100, height: 200)
                scrollView.contentOffset = CGPoint(x: 0, y: -100)
                expect(latest).to(beTrue())

                scrollView.contentOffset = CGPoint(x: 0, y: 100)
                expect(latest).to(beFalse())

                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                expect(latest).to(beFalse())

                subscription.dispose()
            }
            it("isEnabled") {
                var latest: Bool = true
                let subscription: Disposable = topRefresh.rx.isEnabled
                        .subscribe(onNext: { (n: Bool) in
                    latest = n
                })
                let subject = PublishSubject<Bool>()
                let bag = subject.bind(to: topRefresh.rx.isEnabled)

                expect(topRefresh.isEnabled).to(beFalse())
                expect(latest).to(beFalse())

                subject.onNext(true)
                expect(topRefresh.isEnabled).to(beTrue())
                expect(latest).to(beTrue())

                subject.onNext(false)
                expect(topRefresh.isEnabled).to(beFalse())
                expect(latest).to(beFalse())

                subject.onNext(true)
                scrollView.contentSize = CGSize(width: 100, height: 0)
                expect(topRefresh.isEnabled).to(beFalse())
                expect(latest).to(beFalse())

                bag.dispose()
                subscription.dispose()
            }
            it("canLoadMore") {
                var latest: Bool = true
                let subscription: Disposable = topRefresh.rx.canLoadMore
                        .subscribe(onNext: { (n: Bool) in
                    latest = n
                })
                let subject = PublishSubject<Bool>()
                let bag = subject.bind(to: topRefresh.rx.canLoadMore)

                expect(topRefresh.canLoadMore).to(beTrue())
                expect(latest).to(beTrue())

                subject.onNext(false)
                expect(topRefresh.canLoadMore).to(beFalse())
                expect(latest).to(beFalse())

                subject.onNext(true)
                expect(topRefresh.canLoadMore).to(beTrue())
                expect(latest).to(beTrue())

                bag.dispose()
                subscription.dispose()
            }
        }
        describe("Spec RxPullToRefreshView") {
            it("canLoadMore") {
                var latest: Bool = true
                let subscription: Disposable = topRefreshView.rx.canLoadMore
                        .drive(onNext: { (n: Bool) in
                    latest = n
                })
                expect(topRefreshView.canLoadMore).to(beTrue())
                expect(latest).to(beTrue())

                topRefreshView.canLoadMore = false
                expect(topRefreshView.canLoadMore).to(beFalse())
                expect(latest).to(beFalse())

                topRefreshView.canLoadMore = true
                expect(topRefreshView.canLoadMore).to(beTrue())
                expect(latest).to(beTrue())

                subscription.dispose()
            }
            it("action") {
                expect {
                    topRefreshView.action(state: RxPullToRefreshState.initial, progress: 0.0, scroll: 0.0)
                }.to(throwAssertion())
            }
        }
        describe("Spec RxPullToRefreshDelegate") {
            it("action") {
                var latestState: RxPullToRefreshState = .initial
                var latestProgress: CGFloat = 0.0
                var latestScroll: CGFloat = 0.0
                let subscription: Disposable = topRefresh.rx.action
                        .subscribe(onNext: { (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
                    latestState = state
                    latestProgress = progress
                    latestScroll = scroll
                })

                expect(latestState).to(equal(RxPullToRefreshState.initial))
                expect(latestProgress).to(equal(0.0))
                expect(latestScroll).to(equal(0.0))

                topRefresh.delegate?.action(state: .pulling, progress: 0.1, scroll: 0.1)
                expect(latestState).to(equal(RxPullToRefreshState.pulling))
                expect(latestProgress).to(equal(0.1))
                expect(latestScroll).to(equal(0.1))

                topRefresh.delegate?.action(state: .loading, progress: 1.0, scroll: 1.0)
                expect(latestState).to(equal(RxPullToRefreshState.loading))
                expect(latestProgress).to(equal(1.0))
                expect(latestScroll).to(equal(1.0))

                topRefresh.delegate?.action(state: .backing, progress: 0.5, scroll: 0.5)
                expect(latestState).to(equal(RxPullToRefreshState.backing))
                expect(latestProgress).to(equal(0.5))
                expect(latestScroll).to(equal(0.5))

                subscription.dispose()
            }
        }
        describe("Spec UIScrollView") {
            it("contentSize") {
                var desired: CGSize = .zero
                var latest: CGSize = .zero
                let subscription: Disposable = scrollView.rx.contentSize
                        .subscribe(onNext: { (n: CGSize) in
                    latest = n
                })
                let subject = PublishSubject<CGSize>()
                let bag = subject.bind(to: scrollView.rx.contentSize)

                expect(scrollView.contentSize).to(equal(CGSize.zero))
                expect(latest).to(equal(CGSize.zero))

                desired.width = 100
                subject.onNext(desired)
                expect(scrollView.contentSize).to(equal(desired))
                expect(latest).to(equal(desired))

                desired.height = 100
                subject.onNext(desired)
                expect(scrollView.contentSize).to(equal(desired))
                expect(latest).to(equal(desired))

                desired.width = 200
                desired.height = 200
                scrollView.contentSize = desired
                expect(scrollView.contentSize).to(equal(desired))
                expect(latest).to(equal(desired))

                bag.dispose()
                subscription.dispose()
            }
            it("contentInset") {
                var desired: UIEdgeInsets = .zero
                var latest: UIEdgeInsets = .zero
                let subscription: Disposable = scrollView.rx.contentInset
                        .subscribe(onNext: { (n: UIEdgeInsets) in
                    latest = n
                })
                let subject = PublishSubject<UIEdgeInsets>()
                let bag = subject.bind(to: scrollView.rx.contentInset)

                expect(scrollView.contentInset).to(equal(UIEdgeInsets.zero))
                expect(latest).to(equal(UIEdgeInsets.zero))

                desired = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                subject.onNext(desired)
                expect(scrollView.contentInset).to(equal(desired))
                expect(latest).to(equal(desired))

                desired = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
                subject.onNext(desired)
                expect(scrollView.contentInset).to(equal(desired))
                expect(latest).to(equal(desired))

                desired = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                scrollView.contentInset = desired
                expect(scrollView.contentInset).to(equal(desired))
                expect(latest).to(equal(desired))

                bag.dispose()
                subscription.dispose()
            }
        }
    }

}

