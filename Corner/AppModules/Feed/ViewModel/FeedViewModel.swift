//
//  FeedViewModel.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation
import Combine


class FeedViewModel {
    
    enum State {
        case loading(LoadingState)
        case success(data: [FeedTableViewCellModel])
        
        enum LoadingState {
            case initialData
            case pagination
            case PTR
        }
    }
    
    enum FeedViewModelError: Error {
        case unableToFetchFeed
    }

    private let networkService: FeedNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
        
    private var feeds: [Feed] = []
    
    var feedViewModelPassThroughSubject = PassthroughSubject<State, FeedViewModelError>()
    
    init(
        networkService: FeedNetworkServiceProtocol
    ) {
        self.networkService = networkService
    }
    
    func fetchFeedItems(state: State) {
        feedViewModelPassThroughSubject.send(state)
        networkService.fetchFeedItems().sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error): print(error.localizedDescription)
            }
        } receiveValue: { [weak self] response in
            guard let self else {return}
            self.feeds = response.message?.posts ?? []
            self.feedViewModelPassThroughSubject.send(
                .success(
                    data: createTableViewSnapshot(
                        from: self.feeds
                    )
                )
            )
        }.store(in: &cancellables)
    }
    
    func addReaction(_ reaction: String) {
        print("addReaction request called with \(reaction)")
        Utilities.generateHaptic()
    }
    
    func commentSelection(_ postId: String) {
        print("comment \(postId) was tapped")
    }
    
    func bookmarkSelection(_ postId: String) {
        print("Bookmark \(postId) was tapped")
    }
}

//MARK: - FeedViewModel
private extension FeedViewModel {
    func createTableViewSnapshot(from response: [Feed]) -> [FeedTableViewCellModel] {
        let tableViewCellModels: [FeedTableViewCellModel] = response.compactMap { feed in
            let post = feed.postContent?.post
            guard let postId = feed.postContent?.post?.id else {return nil}
            let thread = feed.postContent?.thread?.first
            guard let mediaURLs = post?.mediaUrls else {return nil}
            return FeedTableViewCellModel(
                id: postId,
                images: mediaURLs,
                description: post?.caption,
                commentCount: post?.commentCount,
                bookmarkCount: post?.saveCount,
                reaction: thread?.reactionCounts,
                suggestedReactions: thread?.data?.suggestedReactions,
                currentUserReactions: thread?.currentUserReactions
            )
        }
        
        return tableViewCellModels
    }
}
