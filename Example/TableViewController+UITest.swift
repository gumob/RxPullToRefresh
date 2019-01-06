//
//  BaseTableViewController+UITest.swift
//  RxPullToRefresh
//
//  Created by kojirof on 2018/12/25.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxPullToRefresh

extension BaseTableViewController {

    func setupUIControl() {
        guard let superView: UIView = UIApplication.shared.keyWindow,
              let nc: UINavigationController = self.navigationController else { return }
        /*
         * Navigation Controller
         */
        /* Initialize navigation bar item */
        self.toggleDebugButtonItem = UIBarButtonItem(title: "Debug", style: .plain, target: nil, action: nil)
        self.toggleDebugButtonItem.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.debugView.isHidden = !(self?.debugView.isHidden ?? false)
                })
                .disposed(by: self.disposeBag)
        self.navigationItem.rightBarButtonItem = self.toggleDebugButtonItem

        /* Initialize toolbar items */
        self.refreshTopButtonItem = UIBarButtonItem(title: "Top", style: .plain, target: nil, action: nil)
        self.refreshTopButtonItem.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.forcePrepend()
                })
                .disposed(by: self.disposeBag)

        self.refreshBottomButtonItem = UIBarButtonItem(title: "Bottom", style: .plain, target: nil, action: nil)
        self.refreshBottomButtonItem.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.forceAppend()
                })
                .disposed(by: self.disposeBag)

        self.reloadButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: nil, action: nil)
        self.reloadButtonItem.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.reload()
                })
                .disposed(by: self.disposeBag)

        self.setToolbarItems([self.refreshTopButtonItem,
                              UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                              self.refreshBottomButtonItem,
                              UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                              self.reloadButtonItem],
                             animated: false)

        self.navigationController?.setNavigationBarHidden(!self.env.showNavBar, animated: false)
        self.navigationController?.setToolbarHidden(!self.env.showToolBar, animated: false)

        /*
         * Debug View
         */

        /* Initialize button holder */
        self.debugView = UIView(frame: .zero)
        /* Initialize button */
        self.toggleDragLoad = DebugButton(title: "Load on Drag")
        self.toggleDragLoad.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.topPullToRefresh.shouldStartLoadingWhileDragging = !self.topPullToRefresh.shouldStartLoadingWhileDragging
                    self.bottomPullToRefresh.shouldStartLoadingWhileDragging = !self.bottomPullToRefresh.shouldStartLoadingWhileDragging
                    self.updateDebugView()
                })
                .disposed(by: self.disposeBag)
        self.toggleError = DebugButton(title: "Fail Load")
        self.toggleError.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.viewModel.shouldFailLoad.accept(!self.viewModel.shouldFailLoad.value)
                    self.updateDebugView()
                })
                .disposed(by: self.disposeBag)
        self.toggleNavBarButton = DebugButton(title: "NavBar")
        self.toggleNavBarButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self,
                          let nc: UINavigationController = self.navigationController else { return }
                    nc.setNavigationBarHidden(!nc.isNavigationBarHidden, animated: true)
                    self.updateDebugView(isNavbarShown: !nc.isNavigationBarHidden)
                })
                .disposed(by: self.disposeBag)
        self.toggleToolbarButton = DebugButton(title: "ToolBar")
        self.toggleToolbarButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self,
                          let nc: UINavigationController = self.navigationController else { return }
                    nc.setToolbarHidden(!nc.isToolbarHidden, animated: true)
                    self.updateDebugView(isToolbarShown: !nc.isToolbarHidden)
                })
                .disposed(by: self.disposeBag)
        self.refreshTopButton = DebugButton(title: "Refresh Top")
        self.refreshTopButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.forcePrepend()
                })
                .disposed(by: self.disposeBag)
        self.refreshBottomButton = DebugButton(title: "Refresh Bottom")
        self.refreshBottomButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.forceAppend()
                })
                .disposed(by: self.disposeBag)
        self.endAllRefreshButton = DebugButton(title: "End Refresh")
        self.endAllRefreshButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.tableView.p2r.endAllRefreshing()
                })
                .disposed(by: self.disposeBag)
        self.reloadButton = DebugButton(title: "Reload")
        self.reloadButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.reload()
                })
                .disposed(by: self.disposeBag)
        self.backButton = DebugButton(title: "Back to Top")
        self.backButton.rx.tap
                .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    guard let `self`: BaseTableViewController = self else { return }
                    self.navigationController?.popToRootViewController(animated: true)
                })
                .disposed(by: self.disposeBag)
        /* Initialize label */
//        self.envLabel = UILabel(frame: .zero)
//        self.envLabel.isUserInteractionEnabled = false
//        self.envLabel.numberOfLines = 0
//        self.envLabel.textColor = .darkText
//        self.envLabel.font = UIFont(name: "Menlo-Regular", size: 10)
//        self.envLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.updateDebugView(isNavbarShown: !nc.isNavigationBarHidden,
                             isToolbarShown: !nc.isToolbarHidden)
        /* Add views */
        superView.addSubview(self.debugView)
        self.debugView.addSubview(self.toggleDragLoad)
        self.debugView.addSubview(self.toggleError)
        self.debugView.addSubview(self.toggleNavBarButton)
        self.debugView.addSubview(self.toggleToolbarButton)
        self.debugView.addSubview(self.refreshTopButton)
        self.debugView.addSubview(self.refreshBottomButton)
        self.debugView.addSubview(self.endAllRefreshButton)
        self.debugView.addSubview(self.reloadButton)
        self.debugView.addSubview(self.backButton)
//        self.debugView.addSubview(self.envLabel)
        /* Rx - Update debug view */
        Observable.combineLatest(self.viewModel.shouldFailLoad,
                                 self.viewModel.canPrepend,
                                 self.viewModel.canAppend)
                  .subscribe(onNext: { [weak self] (_, _, _) in
                      self?.updateDebugView()
                  })
                  .disposed(by: self.disposeBag)
        /* Rx - Accessibility */
        self.tableView.rx.willDisplayCell
                .subscribe(onNext: { [weak self] (evt: (cell: UITableViewCell, indexPath: IndexPath)) in
                    self?.addAccessibility(cell: evt.cell, indexPath: evt.indexPath)
                })
                .disposed(by: self.disposeBag)
        self.tableView.rx.didEndDisplayingCell
                .subscribe(onNext: { [weak self] (evt: (cell: UITableViewCell, indexPath: IndexPath)) in
                    self?.removeAccessibility(cell: evt.cell)
                })
                .disposed(by: self.disposeBag)
        Observable.combineLatest(self.tableView.rx.contentOffset,
                                 self.tableView.rx.contentInset,
                                 self.tableView.rx.contentSize)
                  .subscribe({ [weak self] (evt) in
                      self?.updateAccessibility()
                  })
                  .disposed(by: self.disposeBag)
        Observable.combineLatest(self.tableView.rx.willDisplayCell,
                                 self.tableView.rx.didEndDisplayingCell,
                                 self.tableView.rx.contentOffset,
                                 self.tableView.rx.contentInset,
                                 self.tableView.rx.contentSize)
                  .subscribe({ [weak self] (evt) in
                      self?.updateAccessibility()
                  })
                  .disposed(by: self.disposeBag)
        /* Configure accessibility identifier */
        self.toggleDragLoad.isAccessibilityElement = true
        self.toggleDragLoad.accessibilityIdentifier = "ToggleDragLoadButtonID"
        self.toggleError.isAccessibilityElement = true
        self.toggleError.accessibilityIdentifier = "ToggleErrorButtonID"
        self.toggleNavBarButton.isAccessibilityElement = true
        self.toggleNavBarButton.accessibilityIdentifier = "ToggleNavBarButtonID"
        self.toggleToolbarButton.isAccessibilityElement = true
        self.toggleToolbarButton.accessibilityIdentifier = "ToggleToolbarButtonID"
        self.refreshTopButton.isAccessibilityElement = true
        self.refreshTopButton.accessibilityIdentifier = "RefreshTopButtonID"
        self.refreshBottomButton.isAccessibilityElement = true
        self.refreshBottomButton.accessibilityIdentifier = "RefreshBottomButtonID"
        self.endAllRefreshButton.isAccessibilityElement = true
        self.endAllRefreshButton.accessibilityIdentifier = "EndAllRefreshButtonID"
        self.reloadButton.isAccessibilityElement = true
        self.reloadButton.accessibilityIdentifier = "ReloadButtonID"
        self.backButton.isAccessibilityElement = true
        self.backButton.accessibilityIdentifier = "BackButtonID"
        /* Set vertical position */
        self.toggleDragLoad.frame.origin.y = 0
        self.toggleError.frame.origin.y = self.toggleDragLoad.frame.maxY + 6
        self.toggleNavBarButton.frame.origin.y = self.toggleError.frame.maxY + 6
        self.toggleToolbarButton.frame.origin.y = self.toggleNavBarButton.frame.maxY + 6
        self.refreshTopButton.frame.origin.y = self.toggleToolbarButton.frame.maxY + 6
        self.refreshBottomButton.frame.origin.y = self.refreshTopButton.frame.maxY + 6
        self.endAllRefreshButton.frame.origin.y = self.refreshBottomButton.frame.maxY + 6
        self.reloadButton.frame.origin.y = self.endAllRefreshButton.frame.maxY + 6
        self.backButton.frame.origin.y = self.reloadButton.frame.maxY + 6
//        self.envLabel.frame.origin.y = self.backButton.frame.maxY + 6
        /* Set debugView geometry */
        self.debugView.frame.size.width = self.backButton.frame.width
        self.debugView.frame.size.height = self.backButton.frame.maxY
        var center: CGPoint = superView.convert(superView.center, from: self.debugView)
        center.x = superView.frame.width - self.debugView.frame.width / 2 - 6
        self.debugView.center = center
        /* Set constraint */
        self.debugView.translatesAutoresizingMaskIntoConstraints = false
        self.debugView.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin,
                                           UIView.AutoresizingMask.flexibleBottomMargin,
                                           UIView.AutoresizingMask.flexibleLeftMargin]
    }

    func updateDebugView(isNavbarShown: Bool? = nil, isToolbarShown: Bool? = nil) {
        guard let nc: UINavigationController = self.navigationController else { return }
        self.toggleDragLoad.toggleTitle(self.topPullToRefresh.shouldStartLoadingWhileDragging)
        self.toggleError.toggleTitle(self.viewModel.shouldFailLoad.value)
        self.toggleNavBarButton.toggleTitle(isNavbarShown ?? !nc.isNavigationBarHidden)
        self.toggleToolbarButton.toggleTitle(isToolbarShown ?? !nc.isToolbarHidden)
//        let env: UITestEnv = UITestEnv.getEnv()
//        self.envLabel.text = """
//                             isTesting :\(env.isTesting)
//                             canPrepend:\(self.topPullToRefresh.canLoadMore)
//                             canAppend :\(self.bottomPullToRefresh.canLoadMore)
//                             """
////                             refreshDuration : \(env.refreshDuration)
////                             initialCellCount  : \(env.initialCellCount)
//        self.envLabel.sizeToFit()
//        self.envLabel.frame.size.width = self.envLabel.frame.size.width + 18
    }

    func addAccessibility(cell: UITableViewCell, indexPath: IndexPath) {
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "Cell-\(indexPath.row)"
    }

    func removeAccessibility(cell: UITableViewCell) {
        cell.isAccessibilityElement = false
        cell.accessibilityIdentifier = nil
        cell.accessibilityLabel = nil
    }

    func updateAccessibility() {
        guard self.tableView.visibleCells.count > 0 else { return }
        for cell in self.tableView.visibleCells {
            guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { continue }
            cell.isAccessibilityElement = true
            cell.accessibilityIdentifier = "Cell-\(indexPath.row)"
        }
    }
}

class DebugButton: UIButton {
    var title: String = ""

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    init(title: String) {
        self.title = title
        super.init(frame: CGRect(x: 0, y: 0, width: 82, height: 16))
        self.setTitle(title, for: .normal)
        self.setTitleColor(.darkText, for: .normal)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1 / UIScreen.main.scale
        self.titleLabel?.font = UIFont.systemFont(ofSize: 7,
                                                  weight: .regular)
    }

    func toggleTitle(_ isOn: Bool) {
        let str: String = self.title + ": " + (isOn ? "On" : "Off")
        self.setTitle(str, for: .normal)
    }
}

struct UITestEnv: Codable {
    var isTesting: Bool = false
    var orientation: Int = 0
    var loadWhileDragging: Bool = true
    var shouldFailLoad: Bool = false
    var refreshDuration: TimeInterval = 4.0
    var initialCellCount: Int = 24
    var canPrepend: Bool = true
    var canAppend: Bool = true
    var showNavBar: Bool = true
    var showToolBar: Bool = true

    static func getEnv() -> UITestEnv {
        let env: [String: String] = ProcessInfo.processInfo.environment
        let decoder = JSONDecoder()
        guard let json: Data = env["testConfig"]?.data(using: .utf8),
              let info: UITestEnv = try? decoder.decode(UITestEnv.self, from: json) else { return UITestEnv() }
        return info
    }
}
