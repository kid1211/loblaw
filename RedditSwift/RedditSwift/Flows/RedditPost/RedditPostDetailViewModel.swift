//
//  RedditPostDetailViewModel.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-07.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

protocol RedditPostDetailViewModelDelegate: class {
//    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class RedditPostDetailViewModel {
    // MARK: - Properties

    weak private var delegate: RedditPostDetailViewModelDelegate?
    private let fetchDataRepository: RedditAPIRepository
    private(set) var isFetching: Observable<Bool> = Observable(false)
    private(set) var hasError = false
    private var postPreviewData: RedditPostsListBusiness.PostPreview? // Only use when setup
    private var articleBody = ""
    private(set) var postDetailData: RedditPostDetailBusiness.PostDetail?

    // MARK: - Init

    init(repo: RedditAPIRepository = RedditAPIURLSessionRepository()) {
        fetchDataRepository = repo
    }

    /// ViewController need to call this in viewDidLoad to set up viewModel
    func configure(
        viewModelDelegate: RedditPostDetailViewModelDelegate,
        data: RedditPostsListBusiness.PostPreview?
    ) {
        delegate = viewModelDelegate
        postPreviewData = data
    }
}

extension RedditPostDetailViewModel {
    // MARK: Methods

    func fetchPostDetail() {
        guard !(isFetching.value ?? true) else { return }

        postDetailData = nil
        isFetching.value = true
        hasError = false
        fetchDataRepository.fetchPostDetail(permaLink: postPreviewData?.permalink) { [weak self] res in
            switch res {
            case .success(let postDetail):
                self?.postDetailData = postDetail
            case .failure(let error):
                self?.hasError = true
                self?.delegate?.onFetchFailed(with: error)
            }
            self?.isFetching.value = false
        }

    }
}
