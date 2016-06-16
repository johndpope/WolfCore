//
//  KeyboardAvoidantView.swift
//  WolfCore
//
//  Created by Robert McNally on 7/19/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class KeyboardAvoidantView: View {
    // Superview.bottom Equal KeyboardAvoidantView.bottom
    // A positive constant should move the bottom of the KeyboardAvoidantView up.

    private var superviewConstraints: LayoutConstraintsGroup?
    @IBOutlet public var bottomConstraint: NSLayoutConstraint!

    var keyboardView: UIView?
    var keyboardWillMoveAction: NotificationAction!

    public override func setup() {
        super.setup()

        makeTransparent()
        keyboardWillMoveAction = NotificationAction(name: .UIKeyboardWillChangeFrame, object: nil) { [unowned self] notification in
            self.keyboardWillMove(withNotification: notification)
        }
    }

    deinit {
        stopTrackingKeyboard()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        superviewConstraints?.isActive = false

        if let bottomConstraint = bottomConstraint {
            bottomConstraint.isActive = false
        }
        bottomConstraint = nil

        if let superview = superview {
            let topConstraint = superview.topAnchor == topAnchor
            let bottomConstraint = superview.bottomAnchor == bottomAnchor =&= UILayoutPriorityDefaultHigh
            let leadingConstraint = superview.leadingAnchor == leadingAnchor
            let trailingConstraint = superview.trailingAnchor == trailingAnchor

            self.bottomConstraint = bottomConstraint

            superviewConstraints = LayoutConstraintsGroup(constraints: [
                topConstraint, bottomConstraint, leadingConstraint, trailingConstraint
                ], active: true)
        }
    }

    private func endKeyboardRectangle(fromNotification notification: NSNotification) -> CGRect {
        if let keyboardScreenFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue() {
            if let keyboardSuperviewFrame = superview?.convert(keyboardScreenFrame, from: nil) {
                return keyboardSuperviewFrame
            }
        }
        fatalError("Could not get keyboard rectangle from notification")
    }

    func keyboardWillMove(withNotification notification: NSNotification) {
        assert(bottomConstraint != nil, "bottomConstraint not set")
        if superview != nil {
            let endKeyboardRectangle = self.endKeyboardRectangle(fromNotification: notification)
            updateBottomConstraint(forKeyboardRectangle: endKeyboardRectangle)

            let duration = TimeInterval((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
            let animationCurveValue = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? UIViewAnimationCurve.linear.rawValue
            //let animationCurve = UIViewAnimationCurve(rawValue: animationCurveValue & 3)!
            let options = UIViewAnimationOptions(rawValue: UInt(animationCurveValue) << 16)

            UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
                self.layoutSubviews()
                }, completion: { _ in
                    self.startTrackingKeyboard()
            })
        }
    }

    private func updateBottomConstraint(forKeyboardRectangle keyboardRectangle: CGRect) {
        if let superview = superview {
            let intersects = keyboardRectangle.intersects(superview.bounds)
            let newMaxY = intersects ? keyboardRectangle.minY : superview.bounds.maxY
            //            println("\(self) updateBottomConstraintForKeyboardRectangle:\(keyboardRectangle) newMaxY:\(newMaxY)")
            bottomConstraint.constant = superview.bounds.maxY - newMaxY
            setNeedsUpdateConstraints()
        }
    }

    private func startTrackingKeyboard() {
        if keyboardView == nil {
            if let kv = findKeyboardView() {
                keyboardView = kv
                //            println("startTrackingKeyboard: \(keyboardView)")
                kv.addObserver(self, forKeyPath: "center", options: .new, context: nil)
            } else {
                logError("Could not find keyboard view.")
            }
        }
    }

    private func stopTrackingKeyboard() {
        keyboardView?.removeObserver(self, forKeyPath: "center", context: nil)
        keyboardView = nil
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        if let keyboardRectangle = keyboardView?.frame {
            updateBottomConstraint(forKeyboardRectangle: keyboardRectangle)
        }
    }

    func findKeyboardView() -> UIView? {
        var result: UIView? = nil

        let windows = UIApplication.shared().windows
        for window in windows {
            if window.description.hasPrefix("<UITextEffectsWindow") {
                for subview in window.subviews {
                    if subview.description.hasPrefix("<UIInputSetContainerView") {
                        for sv in subview.subviews {
                            if sv.description.hasPrefix("<UIInputSetHostView") {
                                result = sv
                                break
                            }
                        }
                        break
                    }
                }
                break
            }
        }

        return result
    }
}
