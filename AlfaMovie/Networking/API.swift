//
//  API.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

enum APIEndpoint {
    case nowPlaying
    case discover
    case detail(id: Int)
    case reviews(id: Int)
    case images(id: Int)
    case videos(id: Int)
    case image(path: String, size: Int)
    case youtubeVideo(id: String)
    case youtubeThumbnail(id: String)

    static var baseURL: String { "https://api.themoviedb.org/3" }
    static var imageBaseURL: String { "https://image.tmdb.org/t/p/" }
    static var youtubeURL: String { "https://www.youtube.com/embed/" }
    static var youtubeThumbnailURL: String { "https://img.youtube.com/vi/" }

    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .discover:
            return "/discover/movie"
        case .detail(let id):
            return "/movie/\(id)"
        case .reviews(let id):
            return "/movie/\(id)/reviews"
        case .image(let path, let size):
            return "/w\(size)/\(path)"
        case .images(let id):
            return "/movie/\(id)/images"
        case .videos(let id):
            return "/movie/\(id)/videos"
        case .youtubeVideo(let id):
            return "\(id)?&autoplay=1"
        case .youtubeThumbnail(let id):
            return "\(id)/hqdefault.jpg"
        }
    }

    var method: String {
        switch self {
        case .nowPlaying, .discover, .reviews, .image, .images(_), .detail(_), .videos(_):
            return "get"
        case .youtubeVideo(_), .youtubeThumbnail(_):
            return ""
        }
    }

    var url: String {
        switch self {
        case .image:
            return Self.imageBaseURL + path
        case .youtubeVideo(let id):
            return Self.youtubeURL + path
        case .youtubeThumbnail(let id):
            return Self.youtubeThumbnailURL + path
        default:
            return Self.baseURL + path
        }
    }
}
