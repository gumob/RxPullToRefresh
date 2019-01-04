//
//  DefaultTableViewController.swift
//  Example
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxPullToRefresh

class DefaultTableViewController: BaseTableViewController {
    override var reuseId: String { return "DefaultCellId" }

    override func createPullToRefresh(position: RxPullToRefreshPosition) -> RxPullToRefresh {
        return RxPullToRefresh(position: position,
                               shouldStartLoadingWhileDragging: self.env.loadWhileDragging)
    }
}
