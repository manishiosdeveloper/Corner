//
//  Feed.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

typealias ReactionCounts = [String: Int]

struct PostsAPIResponse: Codable {
    let status: Int?
    let message: Message?
}

extension PostsAPIResponse {
    struct Message: Codable {
        let posts: [Feed]?
    }
}

struct Feed: Codable {
    let user: User?
    let postContent: PostContent?
}

extension Feed {
    struct Data: Codable {
        let suggestedReactions: [String]?
    }
    
    struct PostContent: Codable {
        let post: Post?
        let thread: [Thread]?
    }
    
    struct Thread: Codable {
        let id: String?
        let reactionCounts: ReactionCounts?
        let currentUserReactions: [String]?
        let data: Data?
    }
}

extension Feed.Thread {
    struct Data: Codable {
        let suggestedReactions: [String]?
    }
}
