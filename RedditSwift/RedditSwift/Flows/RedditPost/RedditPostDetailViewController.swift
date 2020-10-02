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
    @IBOutlet weak var articleBody: UILabel!

    // MARK: - Properties

    private var viewModel: RedditPostDetailViewModel?
    var postPreviewDataFromParent: RedditPostsListBusiness.PostPreview?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postData = postPreviewDataFromParent else { return }
        viewModel = RedditPostDetailViewModel(data: postData)
        
        initialize()
        initView()
    }

    // MARK: - Init view

    private func initialize() {
        viewModel?.fetchedRes.bind(self, action: fetchCompleted)
    }

    private func initView() {
        let leftNavItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.leftBarButtonItem = leftNavItem

        indicatorView.color = ColorPalette.RWGreen
    }

    // MARK: - Helpers

    private func fetchCompleted(_ fetchedRes: FetchedRes<RedditPostDetailBusiness.PostDetail>) {
        DispatchQueue.main.async { [weak self] in
            switch fetchedRes {
            case .fetching:
                self?.indicatorView.startAnimating()
                self?.thumbnail.isHidden = true
                self?.articleBody.isHidden = true
                self?.navigationItem.title = "Loading ..."
            case .error(let errorMsg):
                self?.indicatorView.stopAnimating()
                self?.thumbnail.isHidden = true
                self?.articleBody.isHidden = true
                self?.navigationItem.title = errorMsg
                self?.showAlert(with: errorMsg)
            case .success(let postDetail):
                self?.indicatorView.stopAnimating()
                self?.articleBody.isHidden = false

                if let bodyText = postDetail.bodyText, bodyText != "" {
                    self?.articleBody.text = bodyText
                } else {
                    self?.articleBody.text = "Article Body Empty"
                }

                if let title = postDetail.title {
                    let titleLabel = self?.getTitleLabel(with: title)
                    self?.navigationItem.titleView = titleLabel
                }

                if let imgData = postDetail.imgData {
                    self?.thumbnail.isHidden = false
                    self?.thumbnail.image = UIImage(data: imgData)
                } else {
                    self?.thumbnail.isHidden = true
                }
            case .notStarted:
                self?.indicatorView.stopAnimating()
                self?.thumbnail.isHidden = true
                self?.articleBody.isHidden = true
            }
        }
    }

    private func getTitleLabel(with title: String) -> UILabel {
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = title
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        tlabel.numberOfLines = 2
        return tlabel
    }

    @objc func addTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension RedditPostDetailViewController {
    private func showAlert(with reason: String?) {
        guard let reason = reason else { return }
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message: reason, actions: [action])
    }
}
