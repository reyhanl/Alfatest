//
//  NowPlayingReponseModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

struct NowPlayingReponseModel: Codable {
    
    let dates: Dates?
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    struct Dates: Codable {
        let maximum: String?
        let minimum: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
