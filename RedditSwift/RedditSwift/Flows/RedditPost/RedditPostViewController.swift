//
//  RedditPostViewController.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import UIKit

class RedditPostViewController: UIViewController {

    let fetchDataRepository: RedditAPIRepository = RedditAPIURLSessionRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchDataRepository.fetchBaseInfo() {
            print($0)
        }
    }

}
