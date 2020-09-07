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
    func fetchPostDetail(permaLink: String?, completion: @escaping RedditPostQueryResult)
    func fetchImageData(with url: String?, completion: @escaping RedditThumbnailQueryResult)
}

typealias RedditBaseQueryResult = (RedditPostsListBusiness.ResData) -> Void
typealias RedditPostQueryResult = (RedditPostDetailBusiness.ResData) -> Void
typealias RedditThumbnailQueryResult = (Data?) -> Void

class RedditAPIURLSessionRepository: RedditAPIRepository {
    // MARK: - Properties

    private let domain = "https://www.reddit.com"
    private let baseInfoURL = "/r/swift/.json"

    // MARK: - Variables

    // MARK: - Methods

    func fetchBaseInfo(completion: @escaping RedditBaseQueryResult) {
        guard let url = URLComponents(string: "\(domain)\(baseInfoURL)")?.url else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // TODO: check response status
            print(response)
            if error == nil {
                guard let data = data else { return }
                do {
                    let baseInfo = try JSONDecoder().decode(RedditPostsListAPI.self, from: data)
                    var resPosts = baseInfo.data?.children.compactMap { RedditPostsListBusiness.PostPreview($0.data) } ?? []
                    completion(.success(resPosts))

                    // start using your model here
                } catch let error {
                    //error handling
                    completion(.failure(error.localizedDescription))
                }
            }
        }.resume()
    }

    func fetchPostDetail(permaLink: String?, completion: @escaping RedditPostQueryResult) {
        guard
            let permaLink = permaLink,
            let url = URLComponents(string: "\(domain)\(permaLink).json")?.url
            else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // TODO: check response status
            print(response)
            if error == nil {
                guard let data = data else { return }
                do {
                    let postsDetailList = try JSONDecoder().decode([RedditPostDetailAPI].self, from: data)
                    if let postData = postsDetailList.first?.data?.children.first?.data {
                        var resPost = RedditPostDetailBusiness.PostDetail(postData)
                        if
                            let thumbnail = resPost.thumbnailURL,
                            let thumbnailURL = URLComponents(string: thumbnail)?.url {
                            URLSession.shared.dataTask(with: thumbnailURL) { (data, _, _) in
                                // Suppress errors
                                resPost.imgData = data
                                completion(.success(resPost))
                            }.resume()
                        } else {
                            completion(.success(resPost))
                        }
                    } else {
                        completion(.failure("failure to decode."))
                        return
                    }
                } catch let error {
                    //error handling
                    completion(.failure(error.localizedDescription))
                }
            }
        }.resume()
    }

    func fetchImageData(with url: String?, completion: @escaping RedditThumbnailQueryResult) {
        // TODO: if there is time
        guard let url = url, let thumbnailURL = URLComponents(string: url)?.url else { return }
        URLSession.shared.dataTask(with: thumbnailURL) { (data, _, _) in
            // Suppress errors
            completion(data)
        }.resume()
    }
}
