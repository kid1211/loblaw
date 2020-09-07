//
//  PostDecoder.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
final class RedditPostsListAPI: RedditBaseWrapperDecoder {
    var kind: String?
    var data: RedditPostsDataWrapper?

    struct RedditPostsDataWrapper: RedditAPIDataWrapper {
        var dist: Int?
        var children: [RedditPostsChildDataWrapper]
    }

    struct RedditPostsChildDataWrapper: RedditAPIDataChildWrapper {
        var kind: String?
        var data: RedditPostPreview
    }
}

final class RedditPostPreview: RedditAPIDataChildData {
    var title: String?

    // Thumbnail
    // TODO: does external link has thumbnail in here?
    var thumbnail_width: Int?
    var thumbnail_height: Int?
    var thumbnail: String? // URL for the thumbnail

    var permalink: String?
}
//swiftlint:enable identifier_name
