//
//  ReachabilityBulletin.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/30/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import SystemConfiguration
import UIKit

public class ReachabilityBulletin: MessageBulletin {
    private typealias `Self` = ReachabilityBulletin

    public let flags: SCNetworkReachabilityFlags

    public class ReachableSkin: DefaultSkin {
        public override var bulletinBackgroundColor: UIColor {
            return UIColor.green.darkened(by: 0.4)
        }

        public override init() {
            super.init()
            fontStyles[.bulletinTitle]!.color = .white
            fontStyles[.bulletinMessage]!.color = .white
        }
    }

    public class UnreachableSkin: DefaultSkin {
        public override var bulletinBackgroundColor: UIColor {
            return .red
        }

        public override init() {
            super.init()
            fontStyles[.bulletinTitle]!.color = .white
            fontStyles[.bulletinMessage]!.color = .white
        }
    }

    public static var reachableSkin: Skin = ReachableSkin()
    public static var unreachableSkin: Skin = UnreachableSkin()

    public init(endpoint: Endpoint, flags: SCNetworkReachabilityFlags) {
        self.flags = flags

        let title: String
        let duration: TimeInterval?

        if flags.contains(.reachable) {
            title = "Your connection to \(endpoint.name) is now working."¶
            duration = 4
        } else {
            title = "There is a problem with your connection to \(endpoint.name)."¶
            duration = nil
        }

        super.init(title: title, priority: Self.maximumPriority, duration: duration)
    }

    public override func newBulletinView() -> BulletinView {
        let bulletinView = super.newBulletinView()
        let view = bulletinView.view
        if flags.contains(.reachable) {
            view.skin = Self.reachableSkin
        } else {
            view.skin = Self.unreachableSkin
        }
        return bulletinView
    }
}
