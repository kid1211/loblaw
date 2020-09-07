//
//  ViewController.swift
//  RedditSwift
//
//  Source: https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import UIKit

class RedditPostsListViewController: UIViewController, AlertDisplayer {
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    // MARK: - Properties

    private let viewModel = RedditPostsListViewModel()
    private let fetchDataRepository: RedditAPIRepository = RedditAPIURLSessionRepository()
    private let cellIdentifiers = "PostPreview" // use Enum if there is multiple

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }

    // MARK: - Helper functions

    private func initialize() {
        // setup View
        // startFetching
        viewModel.configure(viewModelDelegate: self)
        viewModel.isFetching.bind(self, action: fetchCompleted)

        configureTableView()

        initView()
    }

    private func initView() {
        indicatorView.color = ColorPalette.RWGreen
        // show activity identifier, for fetching
        viewModel.fetchPostsList()
    }

    private func configureTableView() {
        tableView.separatorColor = ColorPalette.RWGreen
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
}

extension RedditPostsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifiers,
                for: indexPath
                ) as? RedditPostPreviewTableViewCell
            else { return UITableViewCell() }

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none, cellSelected: nil)
        } else {
            cell.configure(
                with: viewModel.getPostPreviewCell(at: indexPath.row),
                cellSelected: createCellSelectedCallBack()
            )
        }
        return cell
    }
}

extension RedditPostsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPostsList()
        }
    }
}

extension RedditPostsListViewController: RedditPostsListViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPaths = newIndexPathsToReload else { return }
        DispatchQueue.main.async { [weak self] in
            // TODO: remove
            self?.tableView.reloadData()
            return

            guard let indexPaths = self?.visibleIndexPathsToReload(intersecting: newIndexPaths) else { return }
            self?.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }

    func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)

        DispatchQueue.main.async { [weak self] in
            self?.displayAlert(with: title, message: reason, actions: [action])
        }
    }
}

private extension RedditPostsListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }

    // MARK: - fetch data status updated

    private func fetchCompleted(_ isFetching: Bool) {
        DispatchQueue.main.async { [weak self] in
            let hasError = self?.viewModel.hasError ?? false
            if isFetching {
                self?.indicatorView.startAnimating()
                self?.tableView.isHidden = true
            } else if hasError {
                self?.indicatorView.stopAnimating()
                self?.tableView.isHidden = true
            } else {
                self?.indicatorView.stopAnimating()
                self?.tableView.isHidden = false
            }
        }
    }

    // MARK: - Generate callbacks

    private func createCellSelectedCallBack() -> ((RedditPostsListBusiness.PostPreview?) -> Void)? {
        return { [weak self] postData in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                guard
                    let viewController = storyboard.instantiateViewController(
                        withIdentifier: "RedditPostDetailViewController"
                        ) as? RedditPostDetailViewController else { return }
                let navController = UINavigationController(rootViewController: viewController)
                viewController.postPreviewDataFromParent = postData
                self?.present(navController, animated: true)
            }
        }
    }
}
