//
//  CustomTableViewController.swift
//  Example
//
//  Created by kojirof on 2018/12/16.
//  Copyright © 2018 Gumob. All rights reserved.
//

import Foundation
import UIKit
import RxPullToRefresh

class CustomTableViewController: BaseTableViewController {
    override var reuseId: String {
        return "CustomCellId"
    }

    override func createPullToRefresh(position: RxPullToRefreshPosition) -> RxPullToRefresh {
        return CustomPullToRefresh(position: position,
                                   shouldStartLoadingWhileDragging: self.env.loadWhileDragging)
    }
}
