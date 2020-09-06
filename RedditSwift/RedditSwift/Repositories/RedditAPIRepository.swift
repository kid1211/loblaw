//
//  RedditAPIBaseInfo.swift
//  RedditSwift
//
//  Created by Xujie Zheng on 2020-09-05.
//  Copyright © 2020 Xujie Zheng. All rights reserved.
//

import Foundation

protocol RedditAPIRepository {
    func fetchBaseInfo(completion: @escaping RedditBaseQueryResult)
}

typealias RedditBaseQueryResult = (RedditPostsListBusiness.Data) -> Void

class RedditAPIURLSessionRepository: RedditAPIRepository  {
    // MARK: - Properties

    private let baseInfoURL = "https://www.reddit.com/r/swift/.json"

    // MARK: - Variables


    // MARK: - Methods

    func fetchBaseInfo(completion: @escaping RedditBaseQueryResult) {
        guard let url = URLComponents(string: baseInfoURL)?.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          if error == nil {
            guard let data = data else { return }
            do {
                let postBaseInfo = try JSONDecoder().decode(RedditAPIDecoder.RedditPostsListWrapper.self, from: data)
                let resPost = postBaseInfo.data.children.compactMap { RedditPostsListBusiness.PostPreview($0) }
                completion(.success(resPost))
              // start using your model here
             } catch let error {
                //error handling
                completion(.failure(error.localizedDescription))
             }
           }
        }.resume()
    }
}
