//
//  RedditPostDetailViewModel.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-07.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

final class RedditPostDetailViewModel {
    // MARK: - Properties

    private let fetchDataRepository: RedditAPIRepository
    
    private(set) var fetchedRes: Observable<FetchedRes<RedditPostDetailBusiness.PostDetail>> = Observable(.notStarted)
    
    private var articleBody = ""
    private var postPreviewData: RedditPostsListBusiness.PostPreview

    // MARK: - Init

    init(repo: RedditAPIRepository = RedditAPIURLSessionRepository(), data: RedditPostsListBusiness.PostPreview) {
        fetchDataRepository = repo
        postPreviewData = data
        
        // start fetching right away
        fetchPostDetail()
    }
}

extension RedditPostDetailViewModel {
    // MARK: Methods

    func fetchPostDetail() {
        guard fetchedRes.value != .fetching else { return }

        fetchedRes.value = .fetching
        fetchDataRepository.fetchPostDetail(permaLink: postPreviewData.permalink) { [unowned self] res in
            switch res {
            case .success(let postDetail):
                self.fetchedRes.value = .success(postDetail)
            case .failure(let error):
                self.fetchedRes.value = .error(error)
            }
        }
    }
}
