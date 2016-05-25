//
//  TraitCollectionExtensions.swift
//  WolfCore
//
//  Created by Robert McNally on 12/11/15.
//  Copyright © 2015 Arciem. All rights reserved.
//

import UIKit

public func + (lhs: UITraitCollection, rhs: UITraitCollection) -> UITraitCollection {
    return UITraitCollection(traitsFromCollections: [lhs, rhs])
}

extension UITraitCollection {
    public static var HCompact: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: .Compact)
    }

    public static var HAny: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: .Unspecified)
    }

    public static var HRegular: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: .Regular)
    }


    public static var VCompact: UITraitCollection {
        return UITraitCollection(verticalSizeClass: .Compact)
    }

    public static var VAny: UITraitCollection {
        return UITraitCollection(verticalSizeClass: .Unspecified)
    }

    public static var VRegular: UITraitCollection {
        return UITraitCollection(verticalSizeClass: .Regular)
    }


    // FINAL VALUES
    // For 3.5-inch, 4-inch, and 4.7-inch iPhones in landscape.
    public static var HCompactVCompact: UITraitCollection {
        return UITraitCollection.HCompact + UITraitCollection.VCompact
    }

    // BASE VALUES
    // For all compact height layouts, e.g., iPhones in landscape.
    public static var HAnyVCompact: UITraitCollection {
        return UITraitCollection.HAny + UITraitCollection.VCompact
    }

    // FINAL VALUES
    // for 5.5-inch iPhone in landscape.
    public static var HRegularVCompact: UITraitCollection {
        return UITraitCollection.HRegular + UITraitCollection.VCompact
    }


    // BASE VALUES
    // For all compact width layouts, e.g. 3.5-inch, 4-inch, and 4.7-inch iPhones in portrait or landscape.
    public static var HCompactVAny: UITraitCollection {
        return UITraitCollection.HCompact + UITraitCollection.VAny
    }

    // BASE VALUES
    // For all layouts.
    public static var HAnyVAny: UITraitCollection {
        return UITraitCollection.HAny + UITraitCollection.VAny
    }

    // BASE VALUES
    // For all regular width layouts, e.g. iPads in portrait or landscape.
    public static var HRegularVAny: UITraitCollection {
        return UITraitCollection.HRegular + UITraitCollection.VAny
    }


    // FINAL VALUES
    // For all iPhones in portrait.
    public static var HCompactVRegular: UITraitCollection {
        return UITraitCollection.HCompact + UITraitCollection.VRegular
    }

    // BASE VALUES
    // For all regular height layouts, e.g. iPhones in portrait and iPads in portrait or landscape.
    public static var HAnyVRegular: UITraitCollection {
        return UITraitCollection.HAny + UITraitCollection.VRegular
    }

    // FINAL VALUES
    // For iPads in portrait or landscape.
    public static var HRegularVRegular: UITraitCollection {
        return UITraitCollection.HRegular + UITraitCollection.VRegular
    }
}
