//
//  Specs
//  RxPullToRefreshUITests
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Quick
import Nimble
@testable import RxPullToRefresh
@testable import RxPullToRefreshExample

/**
 Specs
 */

enum SpecType: CaseIterable, CustomStringConvertible {
    case `default`, custom
    var buttonId: String {
        switch self {
        case .`default`: return "DefaultButtonID"
        case .custom: return "CustomButtonID"
        }
    }
    var refreshHeight: CGFloat {
        switch self {
        case .`default`: return 48.0
        case .custom: return 64.0
        }
    }
    var description: String {
        switch self {
        case .`default`: return "default"
        case .custom: return "custom"
        }
    }
}

enum SpecCase {
    case caseDrag0Prepend1Append1Force(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag1Prepend1Append1Force(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    case caseDrag0Prepend1Append1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend1Append0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    case caseDrag1Prepend1Append1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag1Prepend1Append0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag1Prepend0Append1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag1Prepend0Append0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    case caseDrag0Prepend1Append1Nav1Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend1Append0Nav1Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append1Nav1Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append0Nav1Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    case caseDrag0Prepend1Append1Nav0Tool1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend1Append0Nav0Tool1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append1Nav0Tool1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append0Nav0Tool1(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    case caseDrag0Prepend1Append1Nav0Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend1Append0Nav0Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append1Nav0Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)
    case caseDrag0Prepend0Append0Nav0Tool0(type: SpecType, orientation: UIDeviceOrientation, shouldFailLoad: Bool)

    var caseDescription: String {
        let desc: String = String(describing: self)
        return desc.components(separatedBy: "(").first ?? desc
    }

    var paramDescription: String {
        let data: SpecData = self.data
        return "type:\(data.type) portrait:\(data.orientation.isPortrait.int) nav:\(data.showNavBar.int) tool:\(data.showToolBar.int) failLoad:\(data.shouldFailLoad.int)"
    }

    var data: SpecData {
        switch self {
        case .caseDrag0Prepend1Append1Force(let type, let orientation, let shouldFailLoad): /* Force pull to refresh */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: [SpecCommand.forceTopPullToRefresh,
                                       SpecCommand.endAllPullToRefresh,
                                       SpecCommand.forceTopPullToRefresh,
                                       SpecCommand.forceTopPullToRefresh,
                                       SpecCommand.forceTopPullToRefresh,
                                       SpecCommand.forceBottomPullToRefresh,
                                       SpecCommand.endAllPullToRefresh,
                                       SpecCommand.forceBottomPullToRefresh,
                                       SpecCommand.forceBottomPullToRefresh,
                                       SpecCommand.forceBottomPullToRefresh,
                                       SpecCommand.wait(2)])
        case .caseDrag1Prepend1Append1Force(let type, let orientation, let shouldFailLoad): /* Force pull to refresh */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: true, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend1Append1Force(type: type,
                                                                             orientation: orientation,
                                                                             shouldFailLoad: shouldFailLoad).data.commands)

        case .caseDrag0Prepend1Append1(let type, let orientation, let shouldFailLoad): /* Refresh both */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: [SpecCommand.topPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.wait(2)])
        case .caseDrag0Prepend1Append0(let type, let orientation, let shouldFailLoad): /* Refresh top only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 24,
                            canPrepend: true, canAppend: false, showNavBar: true, showToolBar: true,
                            commands: [SpecCommand.topPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.wait(2)])
        case .caseDrag0Prepend0Append1(let type, let orientation, let shouldFailLoad): /* Refresh bottom only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: [SpecCommand.bottomPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.wait(2)])
        case .caseDrag0Prepend0Append0(let type, let orientation, let shouldFailLoad): /* Refresh neither */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: false, showNavBar: true, showToolBar: true,
                            commands: [SpecCommand.topPullToRefresh,
                                       SpecCommand.topPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.bottomPullToRefresh,
                                       SpecCommand.wait(2)])

        case .caseDrag1Prepend1Append1(let type, let orientation, let shouldFailLoad): /* Refresh both */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: true, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend1Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag1Prepend1Append0(let type, let orientation, let shouldFailLoad): /* Refresh top only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: true, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 24,
                            canPrepend: true, canAppend: false, showNavBar: true, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend1Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag1Prepend0Append1(let type, let orientation, let shouldFailLoad): /* Refresh bottom only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: true, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: true, showNavBar: true, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend0Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag1Prepend0Append0(let type, let orientation, let shouldFailLoad): /* Refresh neither */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: true, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: false, showNavBar: true, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend0Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)

        case .caseDrag0Prepend1Append1Nav1Tool0(let type, let orientation, let shouldFailLoad): /* Refresh both */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend1Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend1Append0Nav1Tool0(let type, let orientation, let shouldFailLoad):
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: true, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend1Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append1Nav1Tool0(let type, let orientation, let shouldFailLoad): /* Refresh bottom only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: true, showNavBar: true, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend0Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append0Nav1Tool0(let type, let orientation, let shouldFailLoad): /* Refresh neither */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: false, showNavBar: true, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend0Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)

        case .caseDrag0Prepend1Append1Nav0Tool1(let type, let orientation, let shouldFailLoad): /* Refresh both */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: false, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend1Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend1Append0Nav0Tool1(let type, let orientation, let shouldFailLoad):
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: false, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend1Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append1Nav0Tool1(let type, let orientation, let shouldFailLoad): /* Refresh bottom only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: true, showNavBar: false, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend0Append1(type: type, orientation: orientation, shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append0Nav0Tool1(let type, let orientation, let shouldFailLoad): /* Refresh neither */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: false, showNavBar: false, showToolBar: true,
                            commands: SpecCase.caseDrag0Prepend0Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)

        case .caseDrag0Prepend1Append1Nav0Tool0(let type, let orientation, let shouldFailLoad): /* Refresh both */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: false, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend1Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend1Append0Nav0Tool0(let type, let orientation, let shouldFailLoad):
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: true, canAppend: true, showNavBar: false, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend1Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append1Nav0Tool0(let type, let orientation, let shouldFailLoad): /* Refresh bottom only */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: true, showNavBar: false, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend0Append1(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        case .caseDrag0Prepend0Append0Nav0Tool0(let type, let orientation, let shouldFailLoad): /* Refresh neither */
            return SpecData(type: type,
                            orientation: orientation, loadWhileDragging: false, shouldFailLoad: shouldFailLoad,
                            refreshDuration: 0.5, initialCellCount: 30,
                            canPrepend: false, canAppend: false, showNavBar: false, showToolBar: false,
                            commands: SpecCase.caseDrag0Prepend0Append0(type: type,
                                                                        orientation: orientation,
                                                                        shouldFailLoad: shouldFailLoad).data.commands)
        }
    }

    func getEnv() -> String {
        return self.data.env
    }

    func execute(app: XCUIApplication) {

        /*
         RootViewController
         */
        /* Set orientation */
        XCUIDevice.shared.orientation = self.data.orientation
        sleep(1)

        /* Wait until elements is ready */
        let vcButton: XCUIElement = app.buttons.element(matching: .button, identifier: self.data.type.buttonId)
        expect(vcButton.exists && vcButton.isHittable).toEventually(beTrue(), timeout: 10)
        printf("vcButton.exists", vcButton.exists && vcButton.isHittable)
        /* Push view controller */
        vcButton.tap()

        /*
         TableViewController
         */

        /* Wait until table is ready */
        let table: XCUIElementQuery = app.tables
        expect(table.element.exists).toEventually(beTrue(), timeout: 30)
        printf("table.element.exists", table.element.exists)

        /* Wait until cells are ready */
        while true {
            if table.element.cells.count > 0 { break }
        }

        /* Commence command */
        for command: SpecCommand in self.data.commands {
            printf("command", command, icon: "💟")

            printf("cells.count", table.element.cells.count)
            switch command {

            case .wait(let duration):
                sleep(duration)

            case .topPullToRefresh:
                /* Find cell at top */
                var topCell: XCUIElement!
                while true {
                    topCell = table.element.cells.element(matching: .cell, identifier: "Cell-0")
                    if topCell.exists && topCell.isEnabled && topCell.isHittable { break }
                    table.element.swipeDown()
                    sleep(1)
                }
                table.element.swipeDown()
                sleep(1)
                expect(topCell.exists && topCell.isEnabled && topCell.isHittable).to(beTrue())
                printf("topCell.exists", topCell.exists, icon: "🔺")
                /* Drag cell */
                let dragAmount: CGFloat = (self.data.type.refreshHeight / topCell.frame.height) * 6
                let vec1: CGVector = CGVector(dx: 0.2, dy: 0.5)
                let vec2: CGVector = CGVector(dx: 0.2, dy: 0.5 + dragAmount)
                let coord1: XCUICoordinate = topCell.coordinate(withNormalizedOffset: vec1)
                let coord2: XCUICoordinate = topCell.coordinate(withNormalizedOffset: vec2)
                printf("coord1", coord1, icon: "🔺")
                printf("coord2", coord2, icon: "🔺")
                coord1.press(forDuration: 0.02, thenDragTo: coord2)
                sleep(2)

            case .bottomPullToRefresh:
                /* Find cell at bottom */
                var bottomCell: XCUIElement!
                while true {
                    bottomCell = table.element.cells.element(matching: .cell, identifier: "Cell-\(table.element.cells.count - 1)")
                    if bottomCell.exists && bottomCell.isEnabled && bottomCell.isHittable { break }
                    table.element.swipeUp()
                    sleep(1)
                }
                table.element.swipeUp()
                sleep(1)
                expect(bottomCell.exists && bottomCell.isEnabled && bottomCell.isHittable).to(beTrue())
                printf("bottomCell.exists", bottomCell.exists, icon: "🔽")
                /* Drag cell */
                let dragAmount: CGFloat = (self.data.type.refreshHeight / bottomCell.frame.height) * 6
                let vec1: CGVector = CGVector(dx: 0.2, dy: 0.5)
                let vec2: CGVector = CGVector(dx: 0.2, dy: 0.5 - dragAmount)
                let coord1: XCUICoordinate = bottomCell.coordinate(withNormalizedOffset: vec1)
                let coord2: XCUICoordinate = bottomCell.coordinate(withNormalizedOffset: vec2)
                printf("coord1", coord1, icon: "🔽")
                printf("coord2", coord2, icon: "🔽")
                coord1.press(forDuration: 0.02, thenDragTo: coord2)
                sleep(2)

            case .forceReload:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "ReloadButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(2)

            case .forceTopPullToRefresh:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "RefreshTopButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(3)

            case .forceBottomPullToRefresh:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "RefreshBottomButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(3)

            case .endAllPullToRefresh:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "EndAllRefreshButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(1)

            case .toggleNavBar:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "ToggleNavBarButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(1)

            case .toggleToolBar:
                let button: XCUIElement = app.buttons.element(matching: .button, identifier: "ToggleToolbarButtonID")
                expect(button.exists).toEventually(beTrue(), timeout: 10)
                printf("button.exists", button.exists)
                button.tap()
                sleep(1)

            }
        }

        /* Back to top using swipe gesture */
//        let vec1: CGVector = CGVector(dx: 0.0, dy: 0.5)
//        let vec2: CGVector = CGVector(dx: 1.0, dy: 0.5)
//        let coord1: XCUICoordinate = table.element.coordinate(withNormalizedOffset: vec1)
//        let coord2: XCUICoordinate = table.element.coordinate(withNormalizedOffset: vec2)
//        coord1.press(forDuration: 0.02, thenDragTo: coord2)
        /* Back top using debug button*/
        let backButton: XCUIElement = app.buttons.element(matching: .button, identifier: "BackButtonID")
        expect(backButton.exists).toEventually(beTrue(), timeout: 10)
        printf("backButton.exists", backButton.exists)
        backButton.tap()
        sleep(2)
    }
}

struct SpecData {
    var type: SpecType
    var orientation: UIDeviceOrientation
    var loadWhileDragging: Bool
    var shouldFailLoad: Bool
    var refreshDuration: TimeInterval = 0.5
    var initialCellCount: Int
    var canPrepend: Bool
    var canAppend: Bool
    var showNavBar: Bool
    var showToolBar: Bool
    var commands: [SpecCommand]

    var env: String {
        return """
               {
               "isTesting": \(true),
               "orientation": \(self.orientation.rawValue),
               "loadWhileDragging": \(self.loadWhileDragging),
               "shouldFailLoad": \(self.shouldFailLoad),
               "refreshDuration": \(self.refreshDuration),
               "initialCellCount": \(self.initialCellCount),
               "canPrepend": \(self.canPrepend),
               "canAppend": \(self.canAppend),
               "showNavBar": \(self.showNavBar),
               "showToolBar": \(self.showToolBar),
               }
               """
    }

    init(type: SpecType,
         orientation: UIDeviceOrientation,
         loadWhileDragging: Bool, shouldFailLoad: Bool,
         refreshDuration: TimeInterval, initialCellCount: Int,
         canPrepend: Bool, canAppend: Bool, showNavBar: Bool, showToolBar: Bool,
         commands: [SpecCommand]) {
        self.type = type
        self.orientation = orientation
        self.loadWhileDragging = loadWhileDragging
        self.shouldFailLoad = shouldFailLoad
        self.refreshDuration = refreshDuration
        self.initialCellCount = initialCellCount
        self.canPrepend = canPrepend
        self.canAppend = canAppend
        self.showNavBar = showNavBar
        self.showToolBar = showToolBar
        self.commands = commands
    }
}

enum SpecCommand {
    case wait(_ duration: UInt32)
    case topPullToRefresh, bottomPullToRefresh
    case forceReload, forceTopPullToRefresh, forceBottomPullToRefresh
    case endAllPullToRefresh
    case toggleNavBar, toggleToolBar
}

