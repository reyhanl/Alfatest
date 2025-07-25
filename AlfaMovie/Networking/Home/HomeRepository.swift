//
//  HomeRepository.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation

class HomeRepository: HomeRepositoryProtocol{
    
    let executor: NetworkExecutor
    
    init(executor: NetworkExecutor) {
        self.executor = executor
    }
    
    func fetchDiscover(page: Int) async throws -> [Movie] {
        let queryItems = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "language", value: "en-US")]
        var urlComps = URLComponents(string: APIEndpoint.discover.url)
        urlComps?.queryItems = queryItems
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: DiscoverMovieResponseModel = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response.results
    }
    
    func fetchNowPlaying(page: Int) async throws -> [Movie] {
        let queryItems = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "language", value: "en-US")]
        var urlComps = URLComponents(string: APIEndpoint.nowPlaying.url)
        urlComps?.queryItems = queryItems
        print("fetchDiscover url: \(String(describing: urlComps?.url))")
        guard let url = urlComps?.url else{throw CustomError.urlIsInvalid}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        let response: NowPlayingReponseModel = try await executor.execute(request: request)
//        print("movies: \(response.results)")
        return response.results ?? []
    }
}

protocol HomeRepositoryProtocol {
    func fetchDiscover(page: Int) async throws -> [Movie]
    func fetchNowPlaying(page: Int) async throws -> [Movie]
}
