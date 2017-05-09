//
//  EventDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public func printViewTouchedInEvent(_ event: UIEvent) {
    guard event.type == .touches else { return }
    guard let touch = event.allTouches?.first else { return }
    guard touch.phase == .began else { return }
    guard let window = touch.window else { return }
    let locationInWindow = touch.location(in: window)
    let view = window.hitTest(locationInWindow, with: event)
    print("touch in: \(view†)")
}

//
// To subclass UIApplication in order to use printViewTouchedInEvent():
//

// AppDelegate.swift:
//
//    //@UIApplicationMain
//    public class AppDelegate: UIResponder, UIApplicationDelegate {
//      ...
//    }

// Application.swift:
//
//    class Application: UIApplication {
//        override func sendEvent(_ event: UIEvent) {
//            printViewTouchedInEvent(event)
//            super.sendEvent(event)
//        }
//    }

// Main.swift:
//
//    UIApplicationMain(
//        CommandLine.argc,
//        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
//            .bindMemory(
//                to: UnsafeMutablePointer<Int8>.self,
//                capacity: Int(CommandLine.argc)),
//        NSStringFromClass(Application.self),
//        NSStringFromClass(AppDelegate.self)
//    )
