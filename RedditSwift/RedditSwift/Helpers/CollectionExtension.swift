//
//  CollectionExtension.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-06.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
