//
//  PostDecoder.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
class RedditAPIDecoder {
    // MARK: - Reddit posts list data type

    struct RedditPostsListWrapper: Codable {
        let kind: String
        let data: RedditListingData
    }

    struct RedditListingData: Codable {
        let dist: Int
        let children: [RedditPostPreviewWrapper]
    }

    struct RedditPostPreviewWrapper: Codable {
        let kind: String
        let data: RedditPostPreview?
    }
    struct RedditPostPreview: Codable {
        let title: String?

        // Thumbnail
        // TODO: does external link has thumbnail in here?
        let thumbnail_width: Int?
        let thumbnail_height: Int?
        let thumbnail: String? // URL for the thumbnail
    }
}
//swiftlint:enable identifier_name
