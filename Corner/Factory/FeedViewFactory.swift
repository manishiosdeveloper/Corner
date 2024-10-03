//
//  FeedViewFactory.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation
import UIKit

protocol FeedViewFactoryProtocol {
    func makeFeedView() -> FeedViewController
}

class FeedViewFactory: FeedViewFactoryProtocol {
    private let networkService: FeedNetworkServiceProtocol
    
    init(networkService: FeedNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func makeFeedView() -> FeedViewController {
        let feedViewModel = FeedViewModel(networkService: networkService)
        let feedViewController = FeedViewController.loadFromStoryboard()
        feedViewController.viewModel = feedViewModel
        return feedViewController
    }
}
