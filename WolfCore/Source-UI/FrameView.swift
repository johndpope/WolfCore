//
//  FrameView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/4/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class FrameView: View {
    public var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    public enum Mode {
        case rectangle
        case rounded(cornerRadius: CGFloat) // corner radius
        case underline // uses bottom of first child view as the place to draw the underline
    }

    public var mode: Mode = .rectangle {
        didSet {
            setNeedsDisplay()
        }
    }

    public var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var insetBounds: CGRect {
        let halfLineWidth = lineWidth / 2
        return bounds.insetBy(dx: halfLineWidth, dy: halfLineWidth)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawIntoCurrentContext { context in
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(lineWidth)

            switch mode {
            case .rectangle:
                context.stroke(insetBounds)

            case .rounded(let cornerRadius):
                let path = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
                path.stroke()

            case .underline:
                guard let childView = subviews.first else {
                    logWarning("Underline frame with no child view.")
                    return
                }

                let childFrame = childView.frame
                let path = UIBezierPath()
                path.move(to: childFrame.minXmaxY)
                path.addLine(to: childFrame.maxXmaxY)
                path.stroke()
            }
        }
    }
}
