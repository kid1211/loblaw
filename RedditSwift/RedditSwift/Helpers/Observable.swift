//
//  Observable.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-06.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

final class Observable<ObservedType> {
    public typealias Observer = (ObservedType) -> Bool
    private var observers: [Observer]

    public var value: ObservedType? {
        didSet {
            if let value = value {
                notifyObservers(value)
            }
        }
    }

    public init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }

    public func bind(_ object: AnyObject, action: @escaping (ObservedType) -> Void) {
        observers.append { [weak object] value in
            guard object != nil else { return false }

            action(value)
            return true
        }
    }

    private func notifyObservers(_ value: ObservedType) {
        observers = observers.filter {
            $0(value)
        }
    }
}
