//
//  Extensions.swift
//  RxPullToRefreshUITests
//
//  Created by kojirof on 2018/12/24.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest

/**
 Extension
 */
extension XCUIApplication {
    func setEnv(_ config: String) {
        self.launchEnvironment["testConfig"] = config
    }
}

extension Bool {
    var int: Int { return self == true ? 1 : 0 }
}
