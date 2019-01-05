//
//  DefaultSpec.swift
//  RxPullToRefreshUITests
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble

@testable import RxPullToRefreshExample

class DefaultSpec: QuickSpec {
    override func spec() {
        let cases: [SpecCase] = [
            SpecCase.caseDrag1Prepend1Append1Force(type: .default, orientation: .portrait, shouldFailLoad: true),
            SpecCase.caseDrag1Prepend1Append1Force(type: .default, orientation: .portrait, shouldFailLoad: false),

//            SpecCase.caseDrag1Prepend1Append1(type: .default, orientation: .portrait, shouldFailLoad: true),
            SpecCase.caseDrag1Prepend1Append1(type: .default, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag1Prepend1Append0(type: .default, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag1Prepend0Append1(type: .default, orientation: .portrait, shouldFailLoad: false),
            SpecCase.caseDrag1Prepend0Append0(type: .default, orientation: .portrait, shouldFailLoad: false),

//            SpecCase.caseDrag1Prepend1Append1(type: .default, orientation: .landscapeLeft, shouldFailLoad: false),
//            SpecCase.caseDrag1Prepend1Append0(type: .default, orientation: .landscapeLeft, shouldFailLoad: false),
//            SpecCase.caseDrag1Prepend0Append1(type: .default, orientation: .landscapeLeft, shouldFailLoad: false),
//            SpecCase.caseDrag1Prepend0Append0(type: .default, orientation: .landscapeLeft, shouldFailLoad: false),
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
