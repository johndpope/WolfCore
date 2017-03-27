//
//  InFlightTracker.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public internal(set) var inFlightTracker = InFlightTracker()
public internal(set) var inFlightView: InFlightView!

extension Log.GroupName {
    public static let inFlight = Log.GroupName("inFlight")
}

public class InFlightTracker {
    private let serializer = Serializer(label: "InFlightTracker")
    private var tokens = Set<InFlightToken>()
    public var didStart: ((InFlightToken) -> Void)?
    public var didEnd: ((InFlightToken) -> Void)?
    public var isHidden: Bool = {
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
            devOverlay => [
                inFlightView
            ]
            inFlightView.constrainFrame(identifier: "inFlight")
        }
        syncToHidden()
    }

    public func syncToHidden() {
        logTrace("syncToHidden: \(isHidden)", group: .inFlight)
        inFlightView.hideIf(isHidden)
    }

    public func start(withName name: String) -> InFlightToken {
        let token = InFlightToken(name: name)
        token.isNetworkActive = true
        didStart?(token)
        serializer.dispatch {
            self.tokens.insert(token)
        }
        logTrace("started: \(token)", group: .inFlight)
        return token
    }

    public func end(withToken token: InFlightToken, result: ResultSummary) {
        token.isNetworkActive = false
        token.result = result
        serializer.dispatch {
            if let token = self.tokens.remove(token) {
                logTrace("ended: \(token)", group: .inFlight)
            } else {
                fatalError("Token \(token) not found.")
            }
        }
        self.didEnd?(token)
    }
}

private var testTokens = [InFlightToken]()

public func testInFlightTracker() {
    dispatchRepeatedOnMain(atInterval: 0.5) { canceler in
        let n: Double = Random.number()
        switch n {
        case 0.0..<0.4:
            let token = inFlightTracker.start(withName: "Test")
            testTokens.append(token)
        case 0.4..<0.8:
            if testTokens.count > 0 {
                let index = Random.number(0..<testTokens.count)
                let token = testTokens.remove(at: index)
                let result = Random.boolean() ? Result<Int>.success(0) : Result<Int>.failure(GeneralError(message: "err"))
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
