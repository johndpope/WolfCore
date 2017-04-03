//
//  VideoControllerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

extension Log.GroupName {
    public static let video = Log.GroupName("video")
}

open class VideoControllerView: View {
    public typealias UpdatePositionBlock = (_ position: TimeInterval, _ duration: TimeInterval) -> Void
    public var onUpdatePosition: UpdatePositionBlock?
    public var onEnterFullscreen: Block?
    public var onExitFullscreen: Block?
    public var contentView: UIView!

    public required init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public enum Mode {
        case foreground
        case background
    }

    public var mode: Mode = .foreground {
        didSet {
            syncToMode()
        }
    }

    open func syncToMode() { }

    public enum State {
        case paused(Int)
        case playing
        case complete
        case stopped
    }

    public var state: State = .paused(1) {
        didSet {
            syncToState()
        }
    }

    open func syncToState() {
        switch state {
        case .playing:
            logTrace("PLAYING", group: .video)
        case .paused(let level):
            logTrace("PAUSED (\(level))", group: .video)
        case .complete:
            logTrace("COMPLETE", group: .video)
        case .stopped:
            logTrace("STOPPED", group: .video)
        }
    }

    open var position: TimeInterval {
        return 0
    }

    open func play(reason: String) {
        logTrace("play (\(reason))", group: .video)

        switch state {
        case .playing, .complete:
            state = .playing
        case .paused(let level):
            switch level {
            case 1:
                state = .playing
            default:
                state = .paused(level - 1)
            }
        case .stopped:
            break
        }
    }

    open func pause(reason: String) {
        logTrace("pause (\(reason))", group: .video)

        switch state {
        case .playing:
            state = .paused(1)
        case .paused(let level):
            state = .paused(level + 1)
        case .complete, .stopped:
            break
        }
    }

    open func stop(reason: String) {
        logTrace("stop (\(reason))", group: .video)
        state = .stopped
    }

    open func toggle() {
        switch state {
        case .playing:
            pause(reason: "toggled")
        case .paused, .complete:
            play(reason: "toggled")
        case .stopped:
            break
        }
    }

    open func seek(to time: TimeInterval) {
        logTrace("seek to: (\(time))", group: .video)
    }

    open func review(secondsBack: TimeInterval) {
        logTrace("review secondsBack: (\(time))", group: .video)
    }

    open var fileURL: URL!

    open var posterURL: URL!

    open var volume: Frac = 1.0
    
    open var forceFullscreenOnLandscape: Bool = false
    
    open var isInFullscreen: Bool { return false }
}
