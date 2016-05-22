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
            
            prefixJoiner.append(view.translatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅")
            constraintPrefixJoiner.append("⬜️")
            
            prefixJoiner.append(view.hasAmbiguousLayout() ? "❓" : "✅")
            constraintPrefixJoiner.append("⬜️")
            
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
            
            let joiner = Joiner("", "", " ")
            joiner.append(prefixJoiner)
            
            joiner.append( indent, "\(level)".padded(toCount: 2) )
            
            if includeConstraints {
                joiner.append("🔲")
            }
            
            joiner.append(aliaser.name(forObject: view))
            
            joiner.append("frame:\(view.frame)")
            
            if let scrollView = view as? UIScrollView {
                joiner.append("contentSize:\(scrollView.contentSize)")
                joiner.append("contentOffset:\(scrollView.contentOffset)")
            }
            
            #if os(iOS) || os(tvOS)
                if let backgroundColor = view.backgroundColor {
                    joiner.append("backgroundColor:(\(backgroundColor))")
                }
                if let label = view as? UILabel {
                    joiner.append("textColor:\(label.textColor)")
                }
                if view == self || (view.superview != nil && view.tintColor != view.superview!.tintColor) {
                    joiner.append("tintColor:(\(view.tintColor))")
                }
            #endif
            
            if !view.userInteractionEnabled {
                joiner.append("userInteractionEnabled:\(view.userInteractionEnabled)")
            }
            
            if !view.opaque {
                joiner.append("opaque:\(view.opaque)")
            }
            
            if view.alpha < 1.0 {
                joiner.append("alpha:\(view.alpha)")
            }
            
            print(joiner)
            
            if includeConstraints {
                for constraint in view.constraints {
                    let constraintJoiner = Joiner("", "", " ")
                    constraintJoiner.append(constraintPrefixJoiner, indent, " │  🔳")
                    
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
                    
                    Swift.print(constraintJoiner)
                }
            }
            
            view.subviews.reverse().forEach { subview in
                stack.append((subview, level + 1, indent + "  |"))
            }
        } while !stack.isEmpty
    }
}

public func printWindowViewHierarchy(includingConstraints includeConstraints: Bool = false) {
    UIApplication.sharedApplication().windows[0].printViewHierarchy(includingConstraints: includeConstraints)
}
