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
import RxTest
import RxBlocking

@testable import RxPullToRefresh

class MiscSpec: QuickSpec {

    override func spec() {
        describe("Spec Miscellaneous") {
            describe("Spec Codable") {
                it("DefaultRefreshView") {
                    let coder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: Data())
                    let refreshView: DefaultRefreshView? = DefaultRefreshView(coder: coder)
                    expect(refreshView).notTo(beNil())
                }
            }
        }
    }

}
