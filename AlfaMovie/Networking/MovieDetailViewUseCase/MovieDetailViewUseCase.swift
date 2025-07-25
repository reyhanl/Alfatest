//
//  MovieDetailViewUseCase.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

class MovieDetailViewUseCase: MovieDetailViewUseCaseProtocol{
    
    var page: Int = 1
    let repository: MovieDetailViewRepositoryProtocol
    
    init(repository: MovieDetailViewRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDetail(id: Int) async throws -> MovieDetail {
        return try await repository.fetchDetail(id: id)
    }
    
    func fetchImages(id: Int) async throws -> [MediaImage] {
        return try await repository.fetchImages(id: id)
    }
    
    func fetchReview(id: Int, page: Int) async throws -> [Review] {
        return try await repository.fetchReview(id: id, page: page)
    }
    
    func fetchVideos(id: Int) async throws -> [VideoItem] {
        return try await repository.fetchVideos(id: id)
    }
}

protocol MovieDetailViewUseCaseProtocol {
    func fetchDetail(id: Int) async throws -> MovieDetail
    func fetchImages(id: Int) async throws -> [MediaImage]
    func fetchReview(id: Int, page: Int) async throws -> [Review]
    func fetchVideos(id: Int) async throws -> [VideoItem]
}
