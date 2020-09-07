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

    // MARK: - Life cycles

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Initialization

    func configure(with data: RedditPostsListBusiness.PostPreview?) {
        if let data = data {
            title?.text = data.title
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
