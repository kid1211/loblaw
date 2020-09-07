//
//  RedditPostViewController.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import UIKit

class RedditPostDetailViewController: UIViewController, AlertDisplayer {

    // MARK: - IBOutlets

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var articleBody: UITextView!

    // MARK: - Properties

    private var viewModel = RedditPostDetailViewModel()
    var postPreviewDataFromParent: RedditPostsListBusiness.PostPreview?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initView()
        viewModel.fetchPostDetail()
    }

    // MARK: - Init view

    private func initialize() {
        viewModel.configure(viewModelDelegate: self, data: postPreviewDataFromParent)
        viewModel.isFetching.bind(self, action: fetchCompleted)
    }

    private func initView() {
        let leftNavItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.leftBarButtonItem = leftNavItem
    }

    // MARK: - Helpers

    private func fetchCompleted(_ isFetching: Bool) {
        DispatchQueue.main.async { [weak self] in
            let hasError = self?.viewModel.hasError ?? false
            if isFetching {
                self?.indicatorView.startAnimating()
                self?.thumbnail.isHidden = true
                self?.articleBody.isHidden = true
                self?.navigationItem.title = "Loading ..."
            } else if hasError {
                self?.indicatorView.stopAnimating()
                self?.thumbnail.isHidden = true
                self?.articleBody.isHidden = true
                self?.navigationItem.title = "Error"
            } else {
                self?.indicatorView.stopAnimating()
                self?.articleBody.isHidden = false
                self?.articleBody.text = self?.viewModel.postDetailData?.bodyText

                if let title = self?.viewModel.postDetailData?.title {
                    let titleLabel = self?.getTitleLabel(with: title)
                    self?.navigationItem.titleView = titleLabel
                }

                if let imgData = self?.viewModel.postDetailData?.imgData {
                    self?.thumbnail.isHidden = false
                    self?.thumbnail.image = UIImage(data: imgData)
                } else {
                    self?.thumbnail.isHidden = true
                }
            }
        }
    }

    private func getTitleLabel(with title: String) -> UILabel {
        // TODO: not verticle center
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = title
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        return tlabel
    }

    @objc func addTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension RedditPostDetailViewController: RedditPostDetailViewModelDelegate {
    func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)

        DispatchQueue.main.async { [weak self] in
            self?.displayAlert(with: title, message: reason, actions: [action])
        }
    }}
