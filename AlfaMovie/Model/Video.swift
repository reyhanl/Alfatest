//
//  Video.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

struct VideoResponse: Codable {
    let id: Int
    let results: [VideoItem]
}

struct VideoItem: Codable, Identifiable {
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    private let typeStr: String
    var type: VideoTypeEnum{
        switch typeStr{
        case "Trailer":
            return .trailer
        default:
            return .clip
        }
    }
    let official: Bool
    let publishedAt: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case typeStr = "type"
        case name, key, site, size, official
        case publishedAt = "published_at"
        case id
    }
}

extension VideoItem{
    var videoURL: String?{
        if site.lowercased() == "Youtube".lowercased(){
            return APIEndpoint.youtubeVideo(id: key).url
        }else if site.lowercased() == "vimeo".lowercased(){
            return APIEndpoint.vimeoVideo(id: key).url
        }else{
            return nil
        }
    }
}

enum VideoTypeEnum: String {
    case trailer
    case clip
}
