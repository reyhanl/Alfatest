//
//  HomeViewModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

class HomeViewModel: ObservableObject{
    @Published var nowPlayingMovies: [Movie] = []
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    @Published var pushDetail: Bool = false
    let service: HomeUseCaseProtocol
    @State var imagePath: String
    
    init(service: HomeUseCaseProtocol) {
        self.service = service
        imagePath =  APIEndpoint.imageBaseURL
    }
    
    func viewDidLoad(){
        fetchData()
    }
    
    func fetchData(){
        Task{
            let nowPlayingMovies = try await service.fetchNowPlaying()
            await MainActor.run {
                self.nowPlayingMovies = nowPlayingMovies
            }
        }
        Task{
            let movies = try await fetchDiscover()
            await MainActor.run {
                self.movies = movies
            }
        }
    }
    
    func fetchDiscover() async throws -> [Movie]{
        let movies = try await service.fetchDiscover()
        return movies
    }
    
    func userDidScrollToBottom(){
        Task{
            let movies = try await service.fetchMoreDiscover()
            await MainActor.run {
                self.movies.append(contentsOf: movies)
            }
        }
    }
    
    func userDidTapOnCard(movie: Movie){
        selectedMovie = movie
        pushDetail = true
    }
}
