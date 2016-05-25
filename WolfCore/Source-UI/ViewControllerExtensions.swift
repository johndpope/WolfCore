//
//  ViewControllerExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 5/23/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public typealias AlertActionBlock = (UIAlertAction) -> Void

public struct AlertAction {
    public let title: String
    public let style: UIAlertActionStyle
    public let identifier: String
    public let handler: AlertActionBlock?

    public init(title: String, style: UIAlertActionStyle, identifier: String, handler: AlertActionBlock? = nil) {
        self.title = title
        self.style = style
        self.identifier = identifier
        self.handler = handler
    }

    public static func newCancelAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "Cancel"¶, style: .Cancel, identifier: "cancel", handler: handler)
    }

    public static func newOKAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "OK"¶, style: .Default, identifier: "ok", handler: handler)
    }
}

extension UIViewController {
    public func present(alertController alertController: UIAlertController, animated: Bool = true, withIdentifier identifier: String, buttonIdentifiers: [String], completion: DispatchBlock? = nil) {
        alertController.view.accessibilityIdentifier = identifier
        presentViewController(alertController, animated: animated, completion: completion)
        NSRunLoop.currentRunLoop().runOnce()
        for i in 0..<buttonIdentifiers.count {
            alertController.setAction(identifier: buttonIdentifiers[i], atIndex: i)
        }
    }

    private func presentAlertController(withPreferredStyle style: UIAlertControllerStyle, title: String?, message: String?, identifier: String, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .Any, actions: [AlertAction], completion: DispatchBlock?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if let popover = alert.popoverPresentationController {
            if let popoverSourceView = popoverSourceView {
                popover.sourceView = popoverSourceView
                if let popoverSourceRect = popoverSourceRect {
                    popover.sourceRect = popoverSourceRect
                } else {
                    popover.sourceRect = popoverSourceView.bounds
                }
            } else if let popoverBarButtonItem = popoverBarButtonItem {
                popover.barButtonItem = popoverBarButtonItem
            }
            popover.permittedArrowDirections = popoverPermittedArrowDirections
        }
        var buttonIdentifiers = [String]()
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
            buttonIdentifiers.append(action.identifier)
            alert.addAction(alertAction)
        }
        present(alertController: alert, withIdentifier: identifier, buttonIdentifiers: buttonIdentifiers, completion: completion)
    }

    public func presentAlert(withTitle title: String, message: String? = nil, identifier: String, actions: [AlertAction], completion: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .Alert, title: title, message: message, identifier: identifier, actions: actions, completion: completion)
    }

    public func presentAlert(withMessage message: String, identifier: String, actions: [AlertAction], completion: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .Alert, title: nil, message: message, identifier: identifier, actions: actions, completion: completion)
    }

    public func presentSheet(withTitle title: String, message: String? = nil, identifier: String, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .Any, actions: [AlertAction], completion: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .ActionSheet, title: title, message: message, identifier: identifier, popoverSourceView: popoverSourceView, popoverSourceRect: popoverSourceRect, popoverBarButtonItem: popoverBarButtonItem, popoverPermittedArrowDirections: popoverPermittedArrowDirections, actions: actions, completion: completion)
    }

    public func presentOKAlert(withTitle title: String, message: String, identifier: String, completion: DispatchBlock? = nil) {
        presentAlert(withTitle: title, message: message, identifier: identifier, actions: [AlertAction.newOKAction()], completion: completion)
    }

    public func presentOKAlert(withMessage message: String, identifier: String, completion: DispatchBlock? = nil) {
        presentAlert(withMessage: message, identifier: identifier, actions: [AlertAction.newOKAction()], completion: completion)
    }

    public func presentAlert(forError error: ErrorType, completion: DispatchBlock? = nil) {
        logError(error)
        presentOKAlert(withTitle: "Something Went Wrong"¶, message: "Please try again later."¶, identifier: "error", completion: completion)
    }
}
