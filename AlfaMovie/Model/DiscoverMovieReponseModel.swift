//
//  DiscoverMovieReponseModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

struct DiscoverMovieResponseModel: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
