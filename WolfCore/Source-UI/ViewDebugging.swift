//
//  ViewDebugging.swift
//  WolfCore
//
//  Created by Robert McNally on 7/3/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    public func printViewHierarchy() {
        printViewHierarchy(self, indent: "", level: 0)
    }
    
    private func printViewHierarchy(view: UIView, indent: String, level: Int) {
        var scrollViewPrefix = "⬜️"
        if let scrollView = view as? UIScrollView {
            scrollViewPrefix = "🔃"
            if scrollView.scrollsToTop {
                scrollViewPrefix = "🔝"
            }
        }
        let translatesPrefix = view.translatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅"
        let ambiguousPrefix = view.hasAmbiguousLayout() ? "❓" : "⬜️"
        var auxInfoStrings = [String]()
        
        auxInfoStrings.append("opaque:\(view.opaque)")
        #if os(iOS) || os(tvOS)
            auxInfoStrings.append("backgroundColor:\(view.backgroundColor)")
            if let label = view as? UILabel {
                auxInfoStrings.append("textColor:\(label.textColor)")
            }
            auxInfoStrings.append("tintColor:\(view.tintColor)")
        #endif
        auxInfoStrings.append("alpha:\(view.alpha)")
        let debugName: String? = "" //view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let auxInfoString = auxInfoStrings.joinWithSeparator(" ")
        let prefix = "\(scrollViewPrefix) \(translatesPrefix) \(ambiguousPrefix)"
        let s = NSString(format: "%@%@%3d %@%@ %@", prefix, indent, level, debugNameString, view, auxInfoString)
        print(s)
        
        let nextIndent = indent + "  |"
        for subview in view.subviews {
            printViewHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
    
    public func printConstraintsHierarchy() {
        printConstraintsHierarchy(self, indent: "", level: 0)
    }
    
    private func printConstraintsHierarchy(view: UIView, indent: String, level: Int) {
        let translatesPrefix = view.translatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅"
        let ambiguousPrefix = view.hasAmbiguousLayout() ? "❓" : "✅"
        let prefix = "\(translatesPrefix) \(ambiguousPrefix)"
        let debugName: String? = "" // view.debugName
        let debugNameString = debugName == nil ? "" : "\(debugName): "
        let viewString = NSString(format: "%@<%p>", NSStringFromClass(view.dynamicType), view)
        let frameString = NSString(format: "(%g %g; %g %g)", Float(view.frame.origin.x), Float(view.frame.origin.y), Float(view.frame.size.width), Float(view.frame.size.height))
        let s = NSString(format: "%@ ⬜️ %@%3d %@%@ %@", prefix, indent, level, debugNameString, viewString, frameString)
        print(s)
        for constraint in view.constraints {
            let layoutGroupName: String? = "" // constraint.layoutGroupName
            let layoutGroupNameString = layoutGroupName == nil ? "" : "\(layoutGroupName): "
            print("⬜️ ⬜️ 🔵 \(indent)  │    \(layoutGroupNameString)\(constraint)")
        }
        
        let nextIndent = indent + "  |"
        for subview in view.subviews {
            printConstraintsHierarchy(subview, indent: nextIndent, level: level + 1)
        }
    }
}
