//
//  RedditPostsListAPP.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

class RedditPostsListBusiness {
    enum Data {
        case success([PostPreview])
        case failure(String) // Error to display in an alert
    }

    struct PostPreview {
        let title: String?

        // Thumbnail
        // TODO: does external link has thumbnail in here?
        let thumbnailWidth: Int?
        let thumbnailHeight: Int?
        let thumbnail: String? // URL for the thumbnail

        init(_ post: RedditAPIDecoder.RedditPostPreviewWrapper) {
            title = post.data?.title
            thumbnailWidth = post.data?.thumbnail_width
            thumbnailHeight = post.data?.thumbnail_height
            thumbnail = post.data?.thumbnail
        }
    }
}
