//
//  ImageView.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class ImageView: UIImageView {
    public var transparentToTouches = false

    public var pdf: PDF? {
        didSet {
            makeTransparent(debugColor: .green, debug: false)
            updatePDFImage()
            setNeedsLayout()
        }
    }

    private var lastFittingSize: CGSize?
    private weak var lastPDF: PDF?

    private func updatePDFImage() {
        let fittingSize = bounds.size
        if lastFittingSize != fittingSize || lastPDF !== pdf {
            let newImage = self.pdf?.getImage(fittingSize: fittingSize)
            self.image = newImage
            lastFittingSize = fittingSize
            lastPDF = pdf
        }
    }

    var canceler: Canceler?

    public override func layoutSubviews() {
        canceler?.cancel()
        if pdf != nil {
            canceler = dispatchOnMain(afterDelay: 0.1) {
                self.updatePDFImage()
            }
        }
        super.layoutSubviews()
    }

    public override func intrinsicContentSize() -> CGSize {
        let size: CGSize
        if let pdf = pdf {
            size = pdf.getSize()
        } else {
            size = super.intrinsicContentSize()
        }
        return size
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public override init(image: UIImage?) {
        super.init(image: image)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        ~~self
        setup()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    /// Override in subclasses
    public func setup() { }

    /// Override in subclasses
    public func updateAppearance() { }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}
