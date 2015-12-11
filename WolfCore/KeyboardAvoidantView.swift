//
//  KeyboardAvoidantView.swift
//  WolfCore
//
//  Created by Robert McNally on 7/19/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class KeyboardAvoidantView : View {
    // Superview.bottom Equal KeyboardAvoidantView.bottom
    // A positive constant should move the bottom of the KeyboardAvoidantView up.

//    private var superviewConstraints: LayoutConstraintsGroup?
    @IBOutlet public var bottomConstraint: NSLayoutConstraint!
    
    var keyboardView: UIView? = nil
    var keyboardWillMoveAction: NotificationAction!
    
    public override func setup() {
        super.setup()
        
        makeTransparent()
        keyboardWillMoveAction = NotificationAction(name: UIKeyboardWillChangeFrameNotification, object: nil) { notification in
            self.keyboardWillMove(notification)
        }
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillMove:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        stopTrackingKeyboard()
    }
    
    public override func didMoveToSuperview() {
//        superviewConstraints?.active = false
        
//        if let bottomConstraint = bottomConstraint {
//            bottomConstraint.active = false
//        }
//        bottomConstraint = nil

//        if let superview = superview {
//            let topConstraint = superview.topAnchor == topAnchor
//            let bottomConstraint = superview.bottomAnchor == bottomAnchor =&= UILayoutPriorityDefaultHigh
//            let leadingConstraint = superview.leadingAnchor == leadingAnchor
//            let trailingConstraint = superview.trailingAnchor == trailingAnchor

//            self.bottomConstraint = bottomConstraint
            
//            superviewConstraints = LayoutConstraintsGroup(constraints: [
//                topConstraint, bottomConstraint, leadingConstraint, trailingConstraint
//                ], active: true)
//        }
    }

    private func endKeyboardRectangleFromNotification(notification: NSNotification) -> CGRect {
        if let keyboardScreenFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            if let keyboardSuperviewFrame = superview?.convertRect(keyboardScreenFrame, fromView: nil) {
                return keyboardSuperviewFrame
            }
        }
        fatalError("Could not get keyboard rectangle from notification")
    }
    
    func keyboardWillMove(notification: NSNotification) {
        assert(bottomConstraint != nil, "bottomConstraint not set")
        if superview != nil {
            let endKeyboardRectangle = endKeyboardRectangleFromNotification(notification)
            updateBottomConstraintForKeyboardRectangle(endKeyboardRectangle)
            
            let duration = NSTimeInterval((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
            let animationCurveValue = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.integerValue ?? UIViewAnimationCurve.Linear.rawValue
            //let animationCurve = UIViewAnimationCurve(rawValue: animationCurveValue & 3)!
            let options = UIViewAnimationOptions(rawValue: UInt(animationCurveValue) << 16)
            
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: {
                self.layoutSubviews()
                }, completion: { (Bool) in
                    self.startTrackingKeyboard()
            })
        }
    }
    
    private func updateBottomConstraintForKeyboardRectangle(keyboardRectangle: CGRect) {
        if let superview = superview {
            let intersects = keyboardRectangle.intersects(superview.bounds)
            let newMaxY = intersects ? keyboardRectangle.minY : superview.bounds.maxY
//            print("\(self) updateBottomConstraintForKeyboardRectangle:\(keyboardRectangle) newMaxY:\(newMaxY)")
            bottomConstraint.constant = superview.bounds.maxY - newMaxY
            setNeedsUpdateConstraints()
        }
    }
    
    private func startTrackingKeyboard() {
        if keyboardView == nil {
            if let kv = findKeyboardView() {
                keyboardView = kv
                //            println("startTrackingKeyboard: \(keyboardView)")
                kv.addObserver(self, forKeyPath: "center", options: .New, context: nil)
            } else {
                log?.error("Could not find keyboard view.")
            }
        }
    }
    
    private func stopTrackingKeyboard() {
        keyboardView?.removeObserver(self, forKeyPath: "center", context: nil)
        keyboardView = nil
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyboardRectangle = keyboardView?.frame {
            updateBottomConstraintForKeyboardRectangle(keyboardRectangle)
        }
    }
    
    func findKeyboardView() -> UIView? {
        var result: UIView? = nil
        
        let windows = UIApplication.sharedApplication().windows
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
