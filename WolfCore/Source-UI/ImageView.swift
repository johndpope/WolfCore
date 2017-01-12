//
//  ImageView.swift
//  WolfCore
//
//  Created by Robert McNally on 7/8/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import UIKit

public var sharedImageCache: Cache<UIImage>! = Cache<UIImage>(filename: "sharedImageCache", sizeLimit: 100000, includeHTTP: true)
public var sharedDataCache: Cache<Data>! = Cache<Data>(filename: "sharedDataCache", sizeLimit: 100000, includeHTTP: true)

open class ImageView: UIImageView, Skinnable {
    public var transparentToTouches = false
    private var updatePDFCanceler: Cancelable?
    private var retrieveCanceler: Cancelable?
    public var skinChangedAction: SkinChangedAction!

    public var pdf: PDF? {
        didSet {
            makeTransparent(debugColor: .green, debug: false)
            updatePDFImage()
            setNeedsLayout()
        }
    }

    public var url: URL? {
        didSet {
            guard let url = self.url else { return }
            retrieveCanceler?.cancel()
            self.pdf = nil
            self.image = nil
            if url.absoluteString.hasSuffix("pdf") {
                self.retrieveCanceler = sharedDataCache.retrieveObject(forURL: url) { data in
                    guard let data = data else { return }
                    self.pdf = PDF(data: data)
                }
            } else {
                self.retrieveCanceler = sharedImageCache.retrieveObject(forURL: url) { image in
                    self.image = image
                }
            }
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

    open override func layoutSubviews() {
        updatePDFCanceler?.cancel()
        lastFittingSize = nil
        if pdf != nil {
            updatePDFCanceler = dispatchOnMain(afterDelay: 0.1) {
                self.updatePDFImage()
            }
        }
        super.layoutSubviews()
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        lastFittingSize = nil
    }

    open override var intrinsicContentSize: CGSize {
        let size: CGSize
        if let pdf = pdf {
            size = pdf.getSize()
        } else {
            size = super.intrinsicContentSize
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
        setupSkinnable()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        updateAppearance()
    }

    open func setup() { }

    open func updateAppearance() { }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if transparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}
