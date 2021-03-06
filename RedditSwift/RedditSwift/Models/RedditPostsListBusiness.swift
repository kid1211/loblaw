//
//  RedditPostsListAPP.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

class RedditPostsListBusiness {
    enum ResData {
        case success([PostPreview])
        case failure(String) // Error to display in an alert
    }

    struct PostPreview {
        let title: String?
        let permalink: String?

        // Thumbnail
        // TODO: does external link has thumbnail in here?
        let thumbnailWidth: Int?
        let thumbnailHeight: Int?
        let thumbnailURL: String? // URL for the thumbnail
        var imgData: Data? // set after fetched from url

        init(_ post: RedditPostPreview) {
            title = post.title
            thumbnailWidth = post.thumbnail_width
            thumbnailHeight = post.thumbnail_height
            if post.thumbnail_width != nil  && post.thumbnail_height != nil {
                thumbnailURL = post.thumbnail
            } else {
                thumbnailURL = nil
            }
            permalink = post.permalink
        }
    }
}
