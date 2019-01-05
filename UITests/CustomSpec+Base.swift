//
//  CustomSpec+Base.swift
//  RxPullToRefreshUITests
//
//  Created by kojirof on 2018/12/29.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble

@testable import RxPullToRefreshExample

class CustomBaseSpec: QuickSpec {
    override func spec() {
        let cases: [SpecCase] = [
            SpecCase.caseDrag0Prepend1Append1Force(type: .custom, orientation: .portrait, shouldFailLoad: true),
            SpecCase.caseDrag0Prepend1Append1Force(type: .custom, orientation: .portrait, shouldFailLoad: false),

//            SpecCase.caseDrag0Prepend1Append1(type: .custom, orientation: .portrait, shouldFailLoad: true),
            SpecCase.caseDrag0Prepend1Append1(type: .custom, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag0Prepend1Append0(type: .custom, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag0Prepend0Append1(type: .custom, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag0Prepend0Append0(type: .custom, orientation: .portrait, shouldFailLoad: false),
        ]
        cases.forEach { (specCase: SpecCase) in
            describe(specCase.caseDescription) {
                var app: XCUIApplication!
                beforeEach {
                    app = XCUIApplication()
                    app.setEnv(specCase.getEnv())
                    self.continueAfterFailure = false
                    app.launch()
                }
                it(specCase.paramDescription) {
                    specCase.execute(app: app)
                }
            }
        }
    }
}
