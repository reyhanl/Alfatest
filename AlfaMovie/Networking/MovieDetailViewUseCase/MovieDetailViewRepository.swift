//
//  MovieDetailViewRepository.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

class MovieDetailViewRepository: MovieDetailViewRepositoryProtocol{

    let executor: NetworkExecutor
    
    init(executor: NetworkExecutor) {
        self.executor = executor
    }
    
    func fetchDetail(id: Int) async throws -> MovieDetail {
        let queryItems = [URLQueryItem(name: "language", value: "en-US")]
        var urlComps = URLComponents(string: APIEndpoint.detail(id: id).url)
        urlComps?.queryItems = queryItems
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: MovieDetail = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response
    }
    
    func fetchImages(id: Int) async throws -> [MediaImage] {
        let urlComps = URLComponents(string: APIEndpoint.images(id: id).url)
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: ImageResponse = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response.posters
    }
    
    func fetchReview(id: Int, page: Int) async throws -> [Review] {
        let queryItems = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "language", value: "en-US")]
        var urlComps = URLComponents(string: APIEndpoint.reviews(id: id).url)
        urlComps?.queryItems = queryItems
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: ReviewResponse = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response.results
    }
    
    func fetchVideos(id: Int) async throws -> [VideoItem] {
        let queryItems = [URLQueryItem(name: "language", value: "en-US")]
        var urlComps = URLComponents(string: APIEndpoint.videos(id: id).url)
        urlComps?.queryItems = queryItems
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: VideoResponse = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response.results
    }
}

protocol MovieDetailViewRepositoryProtocol {
    func fetchDetail(id: Int) async throws -> MovieDetail
    func fetchImages(id: Int) async throws -> [MediaImage]
    func fetchReview(id: Int, page: Int) async throws -> [Review]
    func fetchVideos(id: Int) async throws -> [VideoItem]
}
