//
//  RedditBaseDecoder.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-07.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
protocol RedditBaseWrapperDecoder: Codable {
    associatedtype GenericDataWrapper: RedditAPIDataWrapper
    var kind: String? { get }
    var data: GenericDataWrapper? { get }
}

protocol RedditAPIDataWrapper: Codable {
    associatedtype GenericChildWrapper: RedditAPIDataChildWrapper
    var dist: Int? { get }
    var children: [GenericChildWrapper] { get }
}

protocol RedditAPIDataChildWrapper: Codable {
    associatedtype GenericChildData: RedditAPIDataChildData
    var kind: String? { get }
    var data: GenericChildData { get }
}

protocol RedditAPIDataChildData: Codable {}
//swiftlint:disable identifier_name
