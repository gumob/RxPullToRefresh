//
//  BaseTableViewController.swift
//  Example
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxPullToRefresh

class CustomTableViewController: BaseTableViewController {
    override var reuseId: String { return "CustomCellId" }

    override func createPullToRefresh(position: RxPullToRefreshPosition) -> RxPullToRefresh {
        return CustomPullToRefresh(position: position,
                                   shouldStartLoadingWhileDragging: self.env.loadWhileDragging)
    }
}

class DefaultTableViewController: BaseTableViewController {
    override var reuseId: String { return "DefaultCellId" }

    override func createPullToRefresh(position: RxPullToRefreshPosition) -> RxPullToRefresh {
        return RxPullToRefresh(position: position,
                               shouldStartLoadingWhileDragging: self.env.loadWhileDragging)
    }
}

class BaseTableViewController: UITableViewController {
    /* Rx */
    var disposeBag: DisposeBag! = DisposeBag()

    /* Data Source */
    var dataSource: RxTableViewSectionedAnimatedDataSource<SectionModel>!
    var viewModel: TableViewModel!
    var reuseId: String {
        /* Overrode in DefaultTableViewController and CustomTableViewController */
        fatalError("You must override this getter method.")
    }

    /* RxPullToRefresh */
    var topPullToRefresh: RxPullToRefresh!
    var bottomPullToRefresh: RxPullToRefresh!

    func createPullToRefresh(position: RxPullToRefreshPosition) -> RxPullToRefresh {
        /* Overrode in DefaultTableViewController and CustomTableViewController */
        fatalError("You must override this method.")
    }

    /* Params for UITest */
    let env: UITestEnv = { return UITestEnv.getEnv() }()

    /* Navigation Bar and Toolbar */
    var toggleDebugButtonItem: UIBarButtonItem!
    var refreshTopButtonItem: UIBarButtonItem!
    var refreshBottomButtonItem: UIBarButtonItem!
    var reloadButtonItem: UIBarButtonItem!

    /* UI Controls for Debugging */
    var debugView: UIView!
    var toggleDragLoad: DebugButton!
    var toggleError: DebugButton!
    var toggleNavBarButton: DebugButton!
    var toggleToolbarButton: DebugButton!
    var refreshTopButton: DebugButton!
    var refreshBottomButton: DebugButton!
    var endAllRefreshButton: DebugButton!
    var reloadButton: DebugButton!
    var backButton: DebugButton!
    var envLabel: UILabel!

    deinit {
        print("👶 deinit")
        self.disposeBag = nil
        self.viewModel = nil
    }
}

extension BaseTableViewController {
    override func viewDidLoad() {
        print("👶 viewDidLoad")
        super.viewDidLoad()

        /*
         * Initialize table view
         */
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionHeaderHeight = 0
//        self.tableView.delegate = nil
//        self.tableView.dataSource = nil
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.rx.itemSelected
                .subscribe(onNext: { [weak self] (indexPath: IndexPath) in
                    guard let `self`: BaseTableViewController = self,
                          let cell: UITableViewCell = self.tableView.cellForRow(at: indexPath) else { return }
                    cell.setSelected(false, animated: true)
                })
                .disposed(by: self.disposeBag)

        /*
         * Initialize data source
         */
        self.dataSource = RxTableViewSectionedAnimatedDataSource<SectionModel>(
                animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                               reloadAnimation: .fade,
                                                               deleteAnimation: .fade
                ),
                configureCell: { (dataSource: TableViewSectionedDataSource<SectionModel>,
                                  tableView: UITableView,
                                  indexPath: IndexPath,
                                  rowModel: RowModel) in
                    guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.reuseId) else {
                        return UITableViewCell(style: .value2, reuseIdentifier: self.reuseId)
                    }
                    cell.textLabel?.text = rowModel.title
                    cell.textLabel?.textColor = rowModel.color
                    return cell
                },
                titleForHeaderInSection: { (dataSource: TableViewSectionedDataSource<SectionModel>,
                                            index: Int) in
                    return dataSource.sectionModels[index].title
                }
        )
        self.viewModel = TableViewModel()
        self.viewModel.sections
                .asDriver()
                .drive(self.tableView.rx.items(dataSource: self.dataSource))
                .disposed(by: self.disposeBag)

        /*
         * Initialize RxPullToRefresh at top
         */
        self.topPullToRefresh = self.createPullToRefresh(position: .top)
        self.topPullToRefresh.rx.action
                .filter { $0.state == .loading }
                .debug("🔺🎬🎬🎬🎬")
                .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
                    if state == .loading { self?.prepend() }
                })
                .disposed(by: self.disposeBag)
        self.viewModel.canPrepend
                .asDriver()
                .drive(self.topPullToRefresh.rx.canLoadMore)
                .disposed(by: self.disposeBag)
        self.tableView.addPullToRefresh(self.topPullToRefresh)

        /*
         * Initialize RxPullToRefresh at bottom
         */
        self.bottomPullToRefresh = self.createPullToRefresh(position: .bottom)
        self.bottomPullToRefresh.rx.action
                .filter { $0.state == .loading }
                .debug("🔽🎬🎬🎬🎬")
                .subscribe(onNext: { [weak self] (state: RxPullToRefreshState, progress: CGFloat, scroll: CGFloat) in
                    if state == .loading { self?.append() }
                })
                .disposed(by: self.disposeBag)
        self.viewModel.canAppend
                .asDriver()
                .drive(self.bottomPullToRefresh.rx.canLoadMore)
                .disposed(by: self.disposeBag)
        self.tableView.addPullToRefresh(self.bottomPullToRefresh)

        /*
         * Initialize UI controls for debugging
         */
        self.setupUIControl()
    }

    open override func viewWillAppear(_ animated: Bool) {
        print("👶 viewWillAppear")
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("👶 viewDidAppear")
        super.viewDidAppear(animated)
        self.reload()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        print("👶 viewWillDisappear")
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("👶 viewDidDisappear")
        super.viewDidDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.debugView.removeFromSuperview()
        self.tableView.endAllRefreshing()
        self.tableView.removeAllPullToRefresh()
    }
}

extension BaseTableViewController {
    func reload() {
        print("👶 reload")
        self.viewModel.reload(shouldFailLoad: self.env.shouldFailLoad,
                              refreshDuration: self.env.refreshDuration,
                              initialCellCount: self.env.initialCellCount,
                              canPrepend: self.env.canPrepend,
                              canAppend: self.env.canAppend)
                      .debug("🔶🔃🔃🔃🔃")
                      .subscribe(onSuccess: { [weak self] in
                          self?.tableView.endAllRefreshing()

                      }, onError: { [weak self] (_: Error) in
                          self?.tableView.endAllRefreshing()
                      })
                      .disposed(by: self.disposeBag)
    }

    func prepend() {
        print("🔺 prepend")
        self.viewModel.prepend()
                      .debug("🔺➕➕➕➕")
                      .subscribe(onSuccess: { [weak self] in
                          self?.tableView.endRefreshing(at: .top)
                      }, onError: { [weak self] (_: Error) in
                          self?.tableView.failRefreshing(at: .top)
                      })
                      .disposed(by: self.disposeBag)
    }

    func append() {
        print("🔽 append")
        self.viewModel.append()
                      .debug("🔽➕➕➕➕")
                      .subscribe(onSuccess: { [weak self] in
                          self?.tableView.endRefreshing(at: .bottom)
                      }, onError: { [weak self] (_: Error) in
                          self?.tableView.failRefreshing(at: .bottom)
                      })
                      .disposed(by: self.disposeBag)
    }

    func forcePrepend() {
        print("🔺 forcePrepend")
        self.tableView.startRefreshing(at: .top)
    }

    func forceAppend() {
        print("🔽 forceAppend")
        self.tableView.startRefreshing(at: .bottom)
    }
}
