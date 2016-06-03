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
    public func present(alertController alertController: UIAlertController, animated: Bool = true, withIdentifier identifier: String, buttonIdentifiers: [String], didAppear: DispatchBlock? = nil) {
        alertController.view.accessibilityIdentifier = identifier
        presentViewController(alertController, animated: animated, completion: didAppear)
        NSRunLoop.currentRunLoop().runOnce()
        for i in 0..<buttonIdentifiers.count {
            alertController.setAction(identifier: buttonIdentifiers[i], atIndex: i)
        }
    }

    private func presentAlertController(withPreferredStyle style: UIAlertControllerStyle, title: String?, message: String?, identifier: String, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .Any, actions: [AlertAction], didAppear: DispatchBlock?, didDisappear: DispatchBlock?) {
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
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { alertAction in
                didDisappear?()
                action.handler?(alertAction)
                }
            )
            buttonIdentifiers.append(action.identifier)
            alert.addAction(alertAction)
        }
        present(alertController: alert, withIdentifier: identifier, buttonIdentifiers: buttonIdentifiers, didAppear: didAppear)
    }

    public func presentAlert(withTitle title: String, message: String? = nil, identifier: String, actions: [AlertAction], didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .Alert, title: title, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(withMessage message: String, identifier: String, actions: [AlertAction], didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .Alert, title: nil, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentSheet(withTitle title: String, message: String? = nil, identifier: String, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .Any, actions: [AlertAction], didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        presentAlertController(withPreferredStyle: .ActionSheet, title: title, message: message, identifier: identifier, popoverSourceView: popoverSourceView, popoverSourceRect: popoverSourceRect, popoverBarButtonItem: popoverBarButtonItem, popoverPermittedArrowDirections: popoverPermittedArrowDirections, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentOKAlert(withTitle title: String, message: String, identifier: String, didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        presentAlert(withTitle: title, message: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentOKAlert(withMessage message: String, identifier: String, didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        presentAlert(withMessage: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: ErrorType, withTitle title: String, message: String, identifier: String, didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        logError(errorType)
        presentOKAlert(withTitle: title, message: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: ErrorType, withMessage message: String, identifier: String, didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        logError(errorType)
        presentOKAlert(withMessage: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: ErrorType, didAppear: DispatchBlock? = nil, didDisappear: DispatchBlock? = nil) {
        if let error = errorType as? Error {
            presentAlert(forError: error, withMessage: error.message, identifier: error.identifier, didAppear: didAppear)
        } else {
            presentAlert(forError: errorType, withTitle: "Something Went Wrong"¶, message: "Please try again later."¶, identifier: "error", didAppear: didAppear, didDisappear: didDisappear)
        }
    }
}
