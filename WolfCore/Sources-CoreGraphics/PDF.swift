//
//  PDF.swift
//  WolfCore
//
//  Created by Robert McNally on 12/21/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import Foundation

import CoreGraphics

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif


public class PDF {
    private let pdf: CGPDFDocument
    public let pageCount: Int

    public init(url: NSURL) {
        pdf = CGPDFDocumentCreateWithURL(url)!
        pageCount = CGPDFDocumentGetNumberOfPages(pdf)
    }

    public convenience init?(named name: String, inSubdirectory subdirectory: String? = nil, fromBundleForClass aClass: AnyClass) {
        let bundle = NSBundle.findBundle(forClass: aClass)
        if let url = bundle.URLForResource(name, withExtension: "pdf", subdirectory: subdirectory) {
            self.init(url: url)
        } else {
            return nil
        }
    }

    public func getSize(ofPageAtIndex index: Int = 0) -> CGSize {
        return getSize(ofPage: getPage(atIndex: index))
    }

    #if os(iOS) || os(tvOS)
    public func getImage(forPageAtIndex index: Int = 0, size: CGSize? = nil, scale: CGFloat = 0.0, renderingMode: UIImageRenderingMode = .Automatic) -> UIImage {
        let page = getPage(atIndex: index)
        let size = size ?? getSize(ofPageAtIndex: index)
        let bounds = CGRect(origin: .zero, size: size)
        let cropBox = CGPDFPageGetBoxRect(page, .CropBox)
        let scaling = CGVector(size: bounds.size) / CGVector(size: cropBox.size)
        let transform = CGAffineTransform.scaling(scaling)
        return newImage(withSize: size, opaque: false, scale: scale, flipped: true, renderingMode: renderingMode) { context in
            CGContextConcatCTM(context, transform)
            CGContextDrawPDFPage(context, page)
        }
    }
    #endif

    #if os(iOS) || os(tvOS)
    public func getImage(forPageAtIndex index: Int = 0, fittingSize: CGSize, scale: CGFloat = 0.0, renderingMode: UIImageRenderingMode = .Automatic) -> UIImage? {
        guard fittingSize.width > 0 && fittingSize.height > 0 else { return nil }
        let size = getSize(ofPageAtIndex: index)
        let newSize = size.aspectFitWithinSize(fittingSize)
        return getImage(forPageAtIndex: index, size: newSize, scale: scale, renderingMode: renderingMode)
    }
    #endif

    #if os(iOS) || os(tvOS)
    public func getImage() -> UIImage {
        return getImage(forPageAtIndex: 0)
    }
    #endif

    //
    // MARK: - Private
    //

    private func getPage(atIndex index: Int) -> CGPDFPage {
        assert(index < pageCount)
        return CGPDFDocumentGetPage(pdf, index + 1)!
    }

    private func getSize(ofPage page: CGPDFPage) -> CGSize {
        var rect = CGPDFPageGetBoxRect(page, .CropBox)
        let rotationAngle = CGPDFPageGetRotationAngle(page)
        if rotationAngle == 90 || rotationAngle == 270 {
            swap(&rect.size.width, &rect.size.height)
        }
        return rect.size
    }
}
