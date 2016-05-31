//
//  ViewDebugging.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIView {
    public func printViewHierarchy(includingConstraints includeConstraints: Bool = false) {
        let aliaser = ObjectAliaser()
        var stack = [(view: UIView, level: Int, indent: String)]()
        stack.append((self, 0, ""))
        repeat {
            let (view, level, indent) = stack.removeLast()

            let prefixJoiner = Joiner("", "", " ")
            let constraintPrefixJoiner = Joiner("", "", " ")

            appendScrollViewPrefix(forView: view, prefixJoiner: prefixJoiner, constraintPrefixJoiner: constraintPrefixJoiner)

            prefixJoiner.append(view.translatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅")
            constraintPrefixJoiner.append("⬜️")

            prefixJoiner.append(view.hasAmbiguousLayout() ? "❓" : "✅")
            constraintPrefixJoiner.append("⬜️")

            appendFocusedPrefix(forView: view, prefixJoiner: prefixJoiner, constraintPrefixJoiner: constraintPrefixJoiner)

            let joiner = Joiner("", "", " ")
            joiner.append(prefixJoiner)

            joiner.append( indent, "\(level)".padded(toCount: 2) )

            if includeConstraints {
                joiner.append("🔲")
            }

            joiner.append(aliaser.name(forObject: view))

            joiner.append("frame:\(view.frame.debugName)")

            appendAttributes(forView: view, toJoiner: joiner)

            print(joiner)

            if includeConstraints {
                for constraint in view.constraints {
                    let constraintJoiner = Joiner("", "", " ")
                    constraintJoiner.append(constraintPrefixJoiner, indent, " │  🔳")

                    appendAttributes(forConstraint: constraint, toJoiner: constraintJoiner, withAliaser: aliaser)

                    Swift.print(constraintJoiner)
                }
            }

            view.subviews.reverse().forEach { subview in
                stack.append((subview, level + 1, indent + "  |"))
            }
        } while !stack.isEmpty
    }

    private func appendScrollViewPrefix(forView view: UIView, prefixJoiner: Joiner, constraintPrefixJoiner: Joiner) {
        #if !os(tvOS)
            var scrollViewPrefix = "⬜️"
            if let scrollView = view as? UIScrollView {
                scrollViewPrefix = "🔃"
                if scrollView.scrollsToTop {
                    scrollViewPrefix = "🔝"
                }
            }
            prefixJoiner.append(scrollViewPrefix)
            constraintPrefixJoiner.append("⬜️")
        #endif
    }

    private func appendFocusedPrefix(forView view: UIView, prefixJoiner: Joiner, constraintPrefixJoiner: Joiner) {
        #if os(tvOS)
            var focusedPrefix = "⬜️"
            if view.canBecomeFocused() {
                focusedPrefix = "💙"
            }
            if view.focused {
                focusedPrefix = "💚"
            }
            prefixJoiner.append(focusedPrefix)
            constraintPrefixJoiner.append("⬜️")
        #endif
    }

    private func appendAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        appendScrollViewAttributes(forView: view, toJoiner: joiner)
        appendColorAttributes(forView: view, toJoiner: joiner)
        appendTextAttributes(forView: view, toJoiner: joiner)
        appendInteractionAttributes(forView: view, toJoiner: joiner)
        appendOpacityAttributes(forView: view, toJoiner: joiner)
    }

    private func appendScrollViewAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        if let scrollView = view as? UIScrollView {
            joiner.append("contentSize:\(scrollView.contentSize)")
            joiner.append("contentOffset:\(scrollView.contentOffset)")
        }
    }

    private func appendColorAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        if let backgroundColor = view.backgroundColor {
            if backgroundColor != .Clear {
                joiner.append("backgroundColor:\(backgroundColor.debugName)")
            }
        }

        if view == self || (view.superview != nil && view.tintColor != view.superview!.tintColor) {
            joiner.append("tintColor:\(view.tintColor.debugName)")
        }
    }

    private func appendTextAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        if let label = view as? UILabel {
            joiner.append("textColor:\(label.textColor.debugName)")
            if let text = label.text {
                joiner.append("text:\"\(text)\"")
            }
        } else if let textView = view as? UITextView {
            if let textColor = textView.textColor {
                joiner.append("textColor:\(textColor.debugName)")
            }
            if let text = textView.text {
                joiner.append("text:\"\(text)\"")
            }
        }
    }

    private func appendInteractionAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        let userInteractionEnabledDefault: Bool
        if view is UILabel || view is UIImageView {
            userInteractionEnabledDefault = false
        } else {
            userInteractionEnabledDefault = true
        }

        if view.userInteractionEnabled != userInteractionEnabledDefault {
            joiner.append("userInteractionEnabled:\(view.userInteractionEnabled)")
        }
    }

    private func appendOpacityAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        if !(view is UIStackView) {
            if view.opaque {
                joiner.append("opaque:\(view.opaque)")
            }
        }

        if view.alpha < 1.0 {
            joiner.append("alpha:\(view.alpha)")
        }
    }

    private func appendAttributes(forConstraint constraint: NSLayoutConstraint, toJoiner constraintJoiner: Joiner, withAliaser aliaser: ObjectAliaser) {
        if constraint.dynamicType != NSLayoutConstraint.self {
            constraintJoiner.append("\(NSStringFromClass(constraint.dynamicType)):")
        }

        constraintJoiner.append("\(aliaser.name(forObject: constraint.firstItem)).\(string(forAttribute: constraint.firstAttribute))")

        constraintJoiner.append(string(forRelation: constraint.relation))

        if let secondItem = constraint.secondItem {
            constraintJoiner.append("\(aliaser.name(forObject: secondItem)).\(string(forAttribute: constraint.secondAttribute))")
            if constraint.multiplier != 1.0 {
                constraintJoiner.append("×", constraint.multiplier)
            }
            if constraint.constant > 0.0 {
                constraintJoiner.append("+", constraint.constant)
            } else if constraint.constant < 0.0 {
                constraintJoiner.append("-", -constraint.constant)
            }
        } else {
            constraintJoiner.append(constraint.constant)
        }
    }
}

public func printWindowViewHierarchy(includingConstraints includeConstraints: Bool = false) {
    UIApplication.sharedApplication().windows[0].printViewHierarchy(includingConstraints: includeConstraints)
}
