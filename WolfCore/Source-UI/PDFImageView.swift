//
//  PDFImageView.swift
//  WolfCore
//
//  Created by Robert McNally on 4/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit

public class PDFImageView: ImageView {
    public var pdf: PDF! {
        didSet {
            setNeedsLayout()
        }
    }

    private func syncToPDF() {
        image = pdf.imageForPage(atIndex: 0, fittingSize: bounds.size)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        syncToPDF()
    }
}
