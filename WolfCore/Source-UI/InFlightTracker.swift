//
//  InFlightTracker.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public internal(set) var inFlightTracker = InFlightTracker()
public internal(set) var inFlightView: InFlightView!

public class InFlightTracker {
    private var tokens = Set<InFlightToken>()
    public var didStart: ((InFlightToken) -> Void)?
    public var didEnd: ((InFlightToken) -> Void)?
    public var hidden: Bool = {
        return !((userDefaults["DevInFlight"] as? Bool) ?? false)
        }() {
        didSet {
            syncToHidden()
        }
    }

    public func setup(withView withView: Bool, withLog: Bool) {
        inFlightTracker = InFlightTracker()
        if withView {
            inFlightView = InFlightView()
            devOverlay.addSubview(inFlightView)
            inFlightView.constrainToSuperview()
        }
        if withLog {
            logger?.setGroup("InFlight")
        }
        syncToHidden()
    }

    public func syncToHidden() {
        logTrace("syncToHidden: \(hidden)", group: "InFlight")
        inFlightView.hidden = hidden
    }

    public func startWithName(name: String) -> InFlightToken {
        let token = InFlightToken(name: name)
        tokens.insert(token)
        didStart?(token)
        logTrace("started: \(token)", group: "InFlight")
        return token
    }

    public func endWithToken(token: InFlightToken, result: ResultSummary) {
        token.result = result
        if tokens.remove(token) != nil {
            didEnd?(token)
            logTrace("ended: \(token)", group: "InFlight")
        } else {
            fatalError("Token \(token) not found.")
        }
    }
}

private var testTokens = [InFlightToken]()

public func testInFlightTracker() {
    dispatchRepeatedOnMain(atInterval: 0.5) { canceler in
        switch Random.randomDouble() {
        case 0.0..<0.4:
            let token = inFlightTracker.startWithName("Test")
            testTokens.append(token)
        case 0.4..<0.8:
            if testTokens.count > 0 {
                let index = Random.randomInt(0..<testTokens.count)
                let token = testTokens.removeAtIndex(index)
                let result = Random.randomBoolean() ? Result<Int>.Success(0) : Result<Int>.Failure(GeneralError(message: "err"))
                inFlightTracker.endWithToken(token, result: result)
            }
        case 0.8..<1.0:
            // do nothing
            break
        default:
            break
        }
    }
}
