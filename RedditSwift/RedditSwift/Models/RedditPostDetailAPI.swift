//
//  RedditPostDetailAPI.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-07.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
final class RedditPostDetailAPI: RedditBaseWrapperDecoder {
    var kind: String?
    var data: RedditPostDetailDataWrapper?

    struct RedditPostDetailDataWrapper: RedditAPIDataWrapper {
        var dist: Int?
        var children: [RedditPostDetailChildDataWrapper]
    }

    struct RedditPostDetailChildDataWrapper: RedditAPIDataChildWrapper {
        var kind: String?
        var data: RedditPostDetailPreview
    }
}

final class RedditPostDetailPreview: RedditAPIDataChildData {
    let title: String?

    // Thumbnail
    // TODO: does external link has thumbnail in here?
    let thumbnail_width: Int?
    let thumbnail_height: Int?
    let thumbnail: String? // URL for the thumbnail

    let selftext: String?

}
//swiftlint:enable identifier_name
