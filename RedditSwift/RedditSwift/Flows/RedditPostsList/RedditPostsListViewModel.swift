//
//  RedditPostsListViewModel.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-06.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

protocol RedditPostsListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func onFetchImageCompleted()
}

final class RedditPostsListViewModel {
    // MARK: - Properties

    weak private var delegate: RedditPostsListViewModelDelegate?
    private let fetchDataRepository: RedditAPIRepository
    private(set) var redditPostsList: [RedditPostsListBusiness.PostPreview] = []
    private(set) var isFetching: Observable<Bool> = Observable(false)
    private(set) var hasError = false
    private(set) var currentPage = 1
    private(set) var total = 10 // TODO: hook this up to infinite scrolling
    var currentCount: Int {
      return redditPostsList.count
    }

    // MARK: - Init

    init(repo: RedditAPIRepository = RedditAPIURLSessionRepository()) {
        fetchDataRepository = repo
    }

    /// ViewController need to call this in viewDidLoad to set up viewModel
    func configure(viewModelDelegate: RedditPostsListViewModelDelegate) {
        delegate = viewModelDelegate
    }
}

extension RedditPostsListViewModel {
    // MARK: Methods

    func fetchPostsList() {
        guard !(isFetching.value ?? true) else { return }

        isFetching.value = true
        hasError = false
        fetchDataRepository.fetchBaseInfo { [weak self] res in
            switch res {
            case .success(let postLists):
                self?.redditPostsList = postLists
                self?.fetchImages()
                self?.delegate?.onFetchCompleted(with: [IndexPath(row: 0, section: 0)])
            case .failure(let error):
                self?.hasError = true
                self?.delegate?.onFetchFailed(with: error)
            }

            self?.isFetching.value = false
        }
    }

    func getPostPreviewCell(at row: Int) -> RedditPostsListBusiness.PostPreview? {
        return redditPostsList[safe: row]
    }

    private func fetchImages() {
        redditPostsList.enumerated().forEach { [weak self] idx, post in
            guard
                post.thumbnailWidth != nil && post.thumbnailHeight != nil,
                let repo = self?.fetchDataRepository
                else { return }
            repo.fetchImageData(with: post.thumbnailURL) { [weak self] data in
                self?.redditPostsList[idx].imgData = data
                self?.delegate?.onFetchImageCompleted()
            }
        }
    }
}
