//
//  fetchDataViewModelWrapper.swift
//  RedditSwift
//
//  Created by Joe Zheng on 2020-10-02.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

enum FetchedRes<T>: Equatable {
    static func == (lhs: FetchedRes<T>, rhs: FetchedRes<T>) -> Bool {
        switch (lhs, rhs) {
        case (.fetching, .fetching):
            fallthrough
        case (.notStarted, notStarted):
            fallthrough
        case (.error(_), .error(_)):
            fallthrough
        case (.success(_), .success(_)):
            return true
        default:
            return false
        }
    }
    
    case notStarted
    case fetching
    case success(T)
    case error(String?)
}
