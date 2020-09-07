//
//  RedditPostDetailBusiness.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-07.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

class RedditPostDetailBusiness {
    enum ResData {
        case success(PostDetail)
        case failure(String) // Error to display in an alert
    }

    struct PostDetail {
        let title: String?
        let bodyText: String?

        // Thumbnail
        // TODO: does external link has thumbnail in here?
        let thumbnailWidth: Int?
        let thumbnailHeight: Int?
        let thumbnailURL: String? // URL for the thumbnail
        var imgData: Data? // set after fetched from url

        init(_ post: RedditPostDetailPreview) {
            title = post.title
            thumbnailWidth = post.thumbnail_width
            thumbnailHeight = post.thumbnail_height
            if post.thumbnail_width != nil  && post.thumbnail_height != nil {
                thumbnailURL = post.thumbnail
            } else {
                thumbnailURL = nil
            }
            bodyText = post.selftext
        }
    }
}
