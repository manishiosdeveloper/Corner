//
//  FeedTableViewCellModel.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation

struct FeedTableViewCellModel: Hashable {
    let id: String
    let images: [String]
    let description: String?
    let commentCount: Int?
    let bookmarkCount: Int?
    var reaction: ReactionCounts?
    let suggestedReactions: [String]?
    var currentUserReactions: [String]?
    
    var currentImageIndex: Int = .zero
    var reactionScrollPosition: CGPoint = .zero
    
    func getImageURL(at index: Int) -> String {
        images[safe: index] ?? ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedTableViewCellModel, rhs: FeedTableViewCellModel) -> Bool {
        return lhs.id == rhs.id
    }
}
