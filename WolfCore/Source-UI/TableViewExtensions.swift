//
//  TableViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/27/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

extension UITableView {
    public func register(nibName name: String, in bundle: Bundle? = nil, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
    }

    public func setupDynamicRowHeights(withEstimatedRowHeight estimatedRowHeight: CGFloat) {
        rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }

    public func update(cell: UITableViewCell, at indexPath: IndexPath, using block: @escaping Block) {
        beginUpdates()
        dispatchAnimated(duration: 0.3) {
            block()
            cell.layoutIfNeeded()
            dispatchOnMain {
                dispatchAnimated {
                    let cellFrame = self.rectForRow(at: indexPath)
                    self.scrollRectToVisible(cellFrame, animated: false)
                }
            }
        }
        endUpdates()
    }

    public func performUpdates(using block: Block) {
        beginUpdates()
        block()
        endUpdates()
    }
}
