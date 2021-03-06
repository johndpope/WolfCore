//
//  AlertControllerExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 5/24/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(iOS) || os(tvOS)
    extension UIAlertController {
        /// This is a hack to set the accessibilityIdentifier attribute of a button created by a UIAlertAction on a UIAlertController. It is coded conservatively so as not to crash if Apple changes the view hierarchy of UIAlertController.view at some future date.
        public func setAction(identifier identifier: String, atIndex index: Int) {
            let collectionViews: [UICollectionView] = view.descendentViews(ofClass: UICollectionView.self)
            if collectionViews.count > 0 {
                let collectionView = collectionViews[0]
                if let cell /* :_UIAlertControllerCollectionViewCell */ = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) {
                    if cell.subviews.count > 0 {
                        let subview /* :UIView */ = cell.subviews[0]
                        if subview.subviews.count > 0 {
                            let actionView /* :_UIAlertControllerActionView */ = subview.subviews[0]
                            actionView.accessibilityIdentifier = identifier
                        }
                    }
                }
            }
        }

        public func setAction(accessibilityIdentifiers identifiers: [String]) {
            for index in 0..<actions.count {
                setAction(identifier: identifiers[index], atIndex: index)
            }
        }
    }
#endif
