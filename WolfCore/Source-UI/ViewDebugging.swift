//
//  ViewDebugging.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIView {
    public func printViewHierarchy(includingConstraints includeOwnedConstraints: Bool = false, includingConstraintsAffectingHorizontal includeHConstraints: Bool = false, includingConstraintsAffectingVertical includeVConstraints: Bool = false) {
        let aliaser = ObjectAliaser()
        var stack = [(view: UIView, level: Int, indent: String)]()
        stack.append((self, 0, ""))
        let includeConstraints = includeOwnedConstraints || includeHConstraints || includeVConstraints
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

            joiner.append("frame:\(view.frame.debugSummary)")

            appendAttributes(forView: view, toJoiner: joiner)

            print(joiner)

            if includeConstraints {
                var needBlankLines = [Bool]()

                if includeOwnedConstraints {
                    needBlankLines.append(printConstraints(view.constraints, withPrefix: "🔳", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if includeHConstraints {
                    needBlankLines.append(printConstraints(view.constraintsAffectingLayoutForAxis(.Horizontal), withPrefix: "H:", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if includeVConstraints {
                    needBlankLines.append(printConstraints(view.constraintsAffectingLayoutForAxis(.Vertical), withPrefix: "V:", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if needBlankLines.contains(true) {
                    print("\(constraintPrefixJoiner.description) \(indent)  │")
                }
            }

            view.subviews.reverse().forEach { subview in
                stack.append((subview, level + 1, indent + "  |"))
            }
        } while !stack.isEmpty
    }

    private func printConstraints(constraints: [NSLayoutConstraint], withPrefix prefix: String, currentView view: UIView, constraintPrefixJoiner: Joiner, indent: String, aliaser: ObjectAliaser) -> Bool {
        let needBlankLines = constraints.count > 0
        if needBlankLines {
            print("\(constraintPrefixJoiner.description) \(indent)  │")
        }
        for constraint in constraints {
            let constraintJoiner = Joiner("", "", " ")
            constraintJoiner.append(constraintPrefixJoiner, indent, " │  \(prefix)")

            appendAttributes(forConstraint: constraint, withCurrentView: view, toJoiner: constraintJoiner, withAliaser: aliaser)

            print(constraintJoiner)
        }
        return needBlankLines
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
                joiner.append("backgroundColor:\(backgroundColor.debugSummary)")
            }
        }

        if view == self || (view.superview != nil && view.tintColor != view.superview!.tintColor) {
            joiner.append("tintColor:\((view.tintColor ?? defaultTintColor).debugSummary)")
        }
    }

    private func appendTextAttributes(forView view: UIView, toJoiner joiner: Joiner) {
        if let label = view as? UILabel {
            joiner.append("textColor:\(label.textColor.debugSummary)")
            if let text = label.text {
                joiner.append("text:\"\(text.debugSummary)\"")
            }
        } else if let textView = view as? UITextView {
            if let textColor = textView.textColor {
                joiner.append("textColor:\(textColor.debugSummary)")
            }
            if let text = textView.text {
                joiner.append("text:\"\(text.debugSummary)\"")
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

    private func descriptor(forRelationship relationship: ViewRelationship, aliaser: ObjectAliaser) -> String {
        switch relationship {
        case .unrelated:
            return "❌"
        case .same:
            return "✅"
        case .sibling:
            return "⚫️"
        case .ancestor:
            return "🚺"
        case .descendant:
            return "🚼"
        case .cousin(let commonAncestor):
            return "🚹 \(aliaser.name(forObject: commonAncestor))"
        }
    }

    private func appendDescriptor(forRelationship relationship: ViewRelationship, toJoiner joiner: Joiner, aliaser: ObjectAliaser) {
        switch relationship {
        case .same:
            break
        default:
            joiner.append(descriptor(forRelationship: relationship, aliaser: aliaser))
        }
    }

    private func name(forView view: UIView, forRelationshipToCurrentView relationship: ViewRelationship, aliaser: ObjectAliaser) -> String {
        var viewName = ""
        switch relationship {
        case .same:
            break
        default:
            viewName = aliaser.name(forObject: view)
        }
        return viewName
    }

    private func appendAttributes(forConstraint constraint: NSLayoutConstraint, withCurrentView currentView: UIView, toJoiner constraintJoiner: Joiner, withAliaser aliaser: ObjectAliaser) {

        constraintJoiner.append("\(aliaser.name(forObject: constraint)):")

        let firstView = constraint.firstItem as! UIView
        let firstToCurrentRelationship: ViewRelationship = firstView.relationship(toView: currentView)

        let firstViewName = name(forView: firstView, forRelationshipToCurrentView: firstToCurrentRelationship, aliaser: aliaser)

        constraintJoiner.append("\(firstViewName).\(string(forAttribute: constraint.firstAttribute))")

        appendDescriptor(forRelationship: firstToCurrentRelationship, toJoiner: constraintJoiner, aliaser: aliaser)

        constraintJoiner.append(string(forRelation: constraint.relation))

        if let secondView = constraint.secondItem as? UIView {
            let secondToCurrentRelationship = secondView.relationship(toView: currentView)

            let secondViewName = name(forView: secondView, forRelationshipToCurrentView: secondToCurrentRelationship, aliaser: aliaser)

            constraintJoiner.append("\(secondViewName).\(string(forAttribute: constraint.secondAttribute))")

            appendDescriptor(forRelationship: secondToCurrentRelationship, toJoiner: constraintJoiner, aliaser: aliaser)

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

public func printWindowViewHierarchy(includingConstraints includeConstraints: Bool = false, includingConstraintsAffectingHorizontal includeHConstraints: Bool = false, includingConstraintsAffectingVertical includeVConstraints: Bool = false) {
    UIApplication.sharedApplication().windows[0].printViewHierarchy(includingConstraints: includeConstraints, includingConstraintsAffectingHorizontal: includeHConstraints, includingConstraintsAffectingVertical: includeVConstraints)
}
