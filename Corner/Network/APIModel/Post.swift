//
//  Post.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

struct Post: Codable {
    let id: String
    let user: User?
    let caption: String?
    let mediaUrls: [String]?
    var commentCount: Int?
    var saveCount: Int?
}
