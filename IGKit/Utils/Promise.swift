//
//  Promise.swift
//  IGKit
//
//  Created by CaptainTeemo on 5/13/16.
//  Copyright © 2016 CaptainTeemo. All rights reserved.
//

import Foundation

private enum State<T> {
    case Fulfilled(T)
    case Rejected(ErrorType)
    case Pending
    case Cancelled
}

public class Promise<T> {
    
    private var _state = State<T>.Pending
    private let _semaphore = dispatch_semaphore_create(0)
    
    /**
     Create a `Promise`.
     
     - parameter resolver: Resolver should call fulfill or reject when their task finished.
     
     - returns: A `Promise` instance.
     */
    public init(_ resolver: (fulfill: T -> Void, reject: ErrorType -> Void) -> Void) {
        resolver(fulfill: { result -> Void in
            self.translation(.Fulfilled(result))
            }, reject: { error -> Void in
                self.translation(.Rejected(error))
        })
    }
    
    deinit {
        if case .Pending = _state {
            debugPrint("Warning: Deallocated a pending Promise.")
        }
    }
    
    /**
     A general `then` call on a `Promise`.
     
     - parameter excecution: Do something and return a value.
     
     - returns: A new `Promise`.
     */
    public func then<U>(excecution: T -> U) -> Promise<U> {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER)
        switch _state {
        case .Fulfilled(let result):
            return Promise<U>({ (fulfill, reject) in
                fulfill(excecution(result))
            })
        case .Rejected(let error):
            return Promise<U>({ (fulfill, reject) in
                reject(error)
            })
        default:
            debugPrint("Warning: returning a pending promise that might never be fulfilled or rejected")
        }
        // It should never happen.
        return Promise<U>({ (fulfill, reject) in })
    }
    
    /**
     A general `then` call on a `Promise`.
     
     - parameter excecution: Do something and return a `Promise`.
     
     - returns: A new `Promise`.
     */
    public func then<U>(excecution: T -> Promise<U>) -> Promise<U> {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER)
        switch _state {
        case .Fulfilled(let result):
            return excecution(result)
        case .Rejected(let error):
            return Promise<U>({ (fulfill, reject) in
                reject(error)
            })
        default:
            debugPrint("Warning: returning a pending promise that might never be fulfilled or rejected")
        }
        // It should never happen.
        return Promise<U>({ (fulfill, reject) in })
    }
    
    /**
     Handle error.
     
     - parameter excecution: Only executing when error occurs.
     */
    public func error(excecution: ErrorType -> Void) {
        switch _state {
        case .Rejected(let error):
            excecution(error)
        default:
            break
        }
    }
    
    private func translation(state: State<T>) {
        switch _state {
        case .Pending:
            _state = state
            dispatch_semaphore_signal(_semaphore)
        default:
            break
        }
    }
    
}