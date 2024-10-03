//
//  FeedService.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation
import Combine

protocol FeedNetworkServiceProtocol {
   func fetchFeedItems() -> AnyPublisher<PostsAPIResponse, NetworkError>
}

class FeedNetworkService: FeedNetworkServiceProtocol {
    func fetchFeedItems() -> AnyPublisher<PostsAPIResponse, NetworkError> {
        NetworkManager.shared.request(
            endpoint: APIEndpoints.postList,
            responseType: PostsAPIResponse.self
        )
    }
}
