//
//  Promise.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/26/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation

public typealias SuccessPromise = Promise<Void>

public class Promise<T>: Cancelable, CustomStringConvertible {
    public typealias `Self` = Promise<T>
    public typealias ValueType = T
    public typealias ResultType = Result<T>
    public typealias RunBlock = (Self) -> Void
    public typealias DoneBlock = (Self) -> Void

    public var task: Cancelable?
    private let onRun: RunBlock
    private var onDone: DoneBlock!
    public private(set) var result: ResultType?

    public var value: ValueType? {
        switch result {
        case nil:
            return nil
        case .success(let value)?:
            return value
        default:
            fatalError("Invalid value: \(self).")
        }
    }

    public init(task: Cancelable? = nil, onRun: @escaping RunBlock) {
        self.task = task
        self.onRun = onRun
    }

    public convenience init(error: Error) {
        self.init {
            $0.fail(error)
        }
    }

    @discardableResult public func run(onDone: @escaping DoneBlock) -> Self {
        assert(self.onDone == nil)
        self.onDone = onDone
        onRun(self)
        return self
    }

    @discardableResult public func run() -> Self {
        return run { _ in }
    }

    @discardableResult public func map<U>(to promise: Promise<U>, failing: ((Error) -> Void)? = nil, with success: @escaping (ValueType) -> Void) -> Promise<U> {
        run { p in
            switch p.result! {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failing = failing {
                    failing(error)
                } else {
                    promise.fail(error)
                }
            case .canceled:
                promise.cancel()
            }
        }
        return promise
    }

    @discardableResult public func succeed() -> SuccessPromise {
        return then { _ in }
    }

    public func then<U>(with success: @escaping (ValueType) throws -> U) -> Promise<U> {
        return Promise<U> { promise in
            self.map(to: promise) { value in
                do {
                    try promise.keep(success(value))
                } catch(let error) {
                    promise.fail(error)
                }
            }
        }
    }

    public func `catch`(with failure: @escaping ErrorBlock) -> Promise<T> {
        return Promise<T> { promise in
            self.run { p in
                switch p.result! {
                case .success(let value):
                    promise.keep(value)
                case .failure(let error):
                    promise.fail(error)
                    failure(error)
                case .canceled:
                    promise.cancel()
                }
            }
        }
    }

    public func recover(with failing: @escaping (Error, Promise<T>) -> Void) -> Promise<T> {
        return Promise<T> { promise in
            self.run { p in
                switch p.result! {
                case .success(let value):
                    promise.keep(value)
                case .failure(let error):
                    failing(error, promise)
                case .canceled:
                    promise.cancel()
                }
            }
        }
    }

    public func finally(with block: @escaping Block) -> Promise<T> {
        return Promise<T> { promise in
            self.run { p in
                switch p.result! {
                case .success(let value):
                    promise.keep(value)
                    block()
                case .failure(let error):
                    promise.fail(error)
                    block()
                case .canceled:
                    promise.cancel()
                }
            }
        }
    }

    public func keep(_ value: ValueType) {
        guard self.result == nil else { return }

        self.result = ResultType.success(value)
        onDone(self)
    }

    public func fail(_ error: Error) {
        guard self.result == nil else { return }

        self.result = ResultType.failure(error)
        onDone(self)
    }

    public func cancel() {
        guard self.result == nil else { return }

        task?.cancel()
        self.result = ResultType.canceled

        onDone(self)
    }

    public var isCanceled: Bool {
        return result?.isCanceled ?? false
    }

    public var description: String {
        return "Promise(\(result†))"
    }
}

public func testPromise() {
    typealias IntPromise = Promise<Int>

    func rollDie() -> IntPromise {
        return IntPromise { promise in
            dispatchOnBackground(afterDelay: Random.number(1.0..3.0)) {
                dispatchOnMain {
                    promise.keep(Random.number(1...6))
                }
            }
        }
    }

    func sum(_ a: IntPromise, _ b: IntPromise) -> IntPromise {
        return IntPromise { promise in
            func _sum() {
                if let a = a.value, let b = b.value {
                    promise.keep(a + b)
                }
            }

            a.run {
                print("a: \($0)")
                _sum()
            }

            b.run {
                print("b: \($0)")
                _sum()
            }
        }
    }
    
    sum(rollDie(), rollDie()).run() {
        print("sum: \($0)")
    }
}
