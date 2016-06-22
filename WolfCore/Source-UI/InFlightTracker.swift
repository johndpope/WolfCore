//
//  InFlightTracker.swift
//  WolfCore
//
//  Created by Robert McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public internal(set) var inFlightTracker = InFlightTracker()
public internal(set) var inFlightView: InFlightView!

extension Log.GroupName {
    public static let inFlight = Log.GroupName("inFlight")
}

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

    public func setup(withView: Bool) {
        inFlightTracker = InFlightTracker()
        if withView {
            inFlightView = InFlightView()
            devOverlay.addSubview(inFlightView)
            inFlightView.constrainToSuperview(identifier: "inFlight")
        }
        syncToHidden()
    }

    public func syncToHidden() {
        logTrace("syncToHidden: \(hidden)", group: .inFlight)
        inFlightView.isHidden = hidden
    }

    public func start(withName name: String) -> InFlightToken {
        let token = InFlightToken(name: name)
        token.isNetworkActive = true
        tokens.insert(token)
        didStart?(token)
        logTrace("started: \(token)", group: .inFlight)
        return token
    }

    public func end(withToken token: InFlightToken, result: ResultSummary) {
        token.isNetworkActive = false
        token.result = result
        if tokens.remove(token) != nil {
            didEnd?(token)
            logTrace("ended: \(token)", group: .inFlight)
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
            let token = inFlightTracker.start(withName: "Test")
            testTokens.append(token)
        case 0.4..<0.8:
            if testTokens.count > 0 {
                let index = Random.randomInt(0..<testTokens.count)
                let token = testTokens.remove(at: index)
                let result = Random.randomBoolean() ? Result<Int>.Success(0) : Result<Int>.Failure(GeneralError(message: "err"))
                inFlightTracker.end(withToken: token, result: result)
            }
        case 0.8..<1.0:
            // do nothing
            break
        default:
            break
        }
    }
}
