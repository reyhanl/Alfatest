//
//  ImageReponse.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

struct ImageResponse: Codable {
    let id: Int
    let backdrops: [MediaImage]
    let logos: [MediaImage]
    let posters: [MediaImage]
}

struct MediaImage: Codable, Identifiable {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount: Int
    let width: Int
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
