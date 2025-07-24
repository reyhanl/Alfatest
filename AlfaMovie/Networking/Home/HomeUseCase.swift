//
//  HomeUseCase.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation

class HomeUseCase: HomeUseCaseProtocol{
    var page: Int = 1
    let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDiscover() async throws -> [Movie] {
        let movies = try await repository.fetchDiscover(page: page)
        return movies
    }
    
    func fetchMoreDiscover() async throws -> [Movie] {
        do{
            page += 1
            let movies = try await repository.fetchDiscover(page: page)
            return movies
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchNowPlaying() async throws -> [Movie] {
        do{
            let movies = try await repository.fetchNowPlaying(page: 1)
            return movies
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
}

protocol HomeUseCaseProtocol {
    func fetchDiscover() async throws -> [Movie]
    func fetchMoreDiscover() async throws -> [Movie]
    func fetchNowPlaying() async throws -> [Movie]
}
