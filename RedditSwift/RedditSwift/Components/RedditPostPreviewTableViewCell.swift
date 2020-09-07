//
//  RedditPostPreviewTableViewCell.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-06.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import UIKit

class RedditPostPreviewTableViewCell: UITableViewCell {
    // MARK: - IBOutlet

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    // MARK: - Properties

    private var cellSelected: ((RedditPostsListBusiness.PostPreview?) -> Void)?
    private var cellData: RedditPostsListBusiness.PostPreview?

    // MARK: - Life cycles

    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: Not Sure, could be a bug for reuse
        configure(with: .none, cellSelected: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard selected else { return }
        cellSelected?(cellData)
    }

    // MARK: - Initialization

    func configure(
        with data: RedditPostsListBusiness.PostPreview?,
        cellSelected: ((RedditPostsListBusiness.PostPreview?) -> Void)?
    ) {
        self.cellSelected = cellSelected
        if let data = data {
            cellData = data
            title?.text = "data.title  \(data.imgData)"
            title.alpha = 1
            indicatorView.stopAnimating()
        } else {
            title.alpha = 0
            indicatorView.startAnimating()
        }
    }

    private func initView() {
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 6
        indicatorView.hidesWhenStopped = true
        indicatorView.color = ColorPalette.RWGreen
    }
}
