//
//  Timeline.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

extension Log.GroupName {
    public static let timeline = Log.GroupName("timeline")
}

public class Timeline {
    public typealias ActionBlock = ((_ completion: @escaping Block) -> Void)
    public private(set) var events = [Event]()
    public var onFinish: Block?
    private var notifyWorkItem: DispatchWorkItem?
    private var playTime: DispatchTime!
    private var elapsedTime: TimeInterval {
        return TimeInterval(DispatchTime.now().uptimeNanoseconds - playTime.uptimeNanoseconds) / 1_000_000_000
    }

    public init() { }

    public class Event: Comparable, CustomStringConvertible {
        public let time: TimeInterval
        public let name: String
        public let action: ActionBlock?
        var workItem: DispatchWorkItem?
        var onStateChange: ((Event) -> Void)?

        var state: State {
            didSet {
                onStateChange?(self)
            }
        }

        enum State {
            case ready
            case queued
            case executing
            case finished
            case canceled
        }

        init(at time: TimeInterval, named name: String, action: @escaping ActionBlock) {
            self.time = time
            self.name = name
            self.action = action
            state = .ready
        }

        public static func == (lhs: Event, rhs: Event) -> Bool { return lhs.time == rhs.time }
        public static func < (lhs: Event, rhs: Event) -> Bool { return lhs.time < rhs.time }

        public var description: String {
            return "\(state) \(name) (\(time %% 3))"
        }
    }

    public func addEvent(at time: TimeInterval, named name: String, action: @escaping ActionBlock) {
        let event = Event(at: time, named: name, action: action)
        event.onStateChange = { [weak self] event in
            guard let s = self else { return }
            logTrace("\(s.elapsedTime %% 3): \(event)", group: .timeline)
        }
        events.append(event)
        events.sort(by: <)
    }

    private lazy var group: DispatchGroup = {
        let group = DispatchGroup()
        return group
    }()

    private lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "Timeline", qos: .userInteractive, attributes: [.concurrent])
        return queue
    }()

    private func finish() {
        logTrace("\(self.elapsedTime %% 3) finish", group: .timeline)
        onFinish?()
    }

    public func play() {
        playTime = DispatchTime.now()
        for event in events {
            group.enter()
            let dispatchTime = playTime + DispatchTimeInterval.milliseconds(Int(event.time * 1000))
            event.state = .queued
            event.workItem = DispatchWorkItem(flags: [.inheritQoS, .enforceQoS]) { [unowned self] in
                if !(event.state == .canceled) {
                    event.state = .executing
                    dispatchOnMain {
                        event.action!() {
                            event.state = .finished
                            self.group.leave()
                        }
                    }
                }
            }
            queue.asyncAfter(deadline: dispatchTime, execute: event.workItem!)
        }

        notifyWorkItem = DispatchWorkItem(qos: .background, flags: []) { [unowned self] in
            self.finish()
        }
        group.notify(queue: DispatchQueue.main, work: notifyWorkItem!)
    }

    public func cancel() {
        notifyWorkItem?.cancel()
        events.forEach {
            $0.state = .canceled
            $0.workItem?.cancel()
        }
    }

    public static func dummyWork(duration: TimeInterval) {
        Thread.sleep(forTimeInterval: duration)
    }
}
