//
//  Review.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

struct ReviewResponse: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Review: Codable, Hashable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

struct AuthorDetails: Codable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
