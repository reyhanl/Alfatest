//
//  HomeViewModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

class HomeViewModel: ObservableObject{
    @Published var nowPlayingMovies: [Movie] = [] //Banner
    @Published var movies: [Movie] = []
    
    @Published var isFetchingBannerStatus: Bool = false
    @Published var isFetchingFeedStatus: Bool = false
    @Published var isReloading: Bool = false
    
    @Published var selectedMovie: Movie?
    @Published var pushDetail: Bool = false
    
    var fetchMoreFeedFailed: Bool = false
    var getBannerFailed: Bool = false
    var initialFeedFetchFailed: Bool = false
    
    let service: HomeUseCaseProtocol
    @State var imagePath: String
    
    init(service: HomeUseCaseProtocol) {
        self.service = service
        imagePath =  APIEndpoint.imageBaseURL
    }
    
    func viewDidLoad(){
        fetchData()
        observeNetworkStatus()
    }
    
    func fetchData(){
        fetchBanner()
        fetchFeed()
    }
    
    func refresh(){
        isReloading = true
        isFetchingBannerStatus = true
        isFetchingFeedStatus = true
        Task{
            do{
                let nowPlayingMovies = try await service.fetchNowPlaying()
                await MainActor.run {
                    isFetchingBannerStatus = false
                    self.nowPlayingMovies = nowPlayingMovies
                }
            }catch{
                await MainActor.run {
                    isFetchingBannerStatus = false
                    isFetchingFeedStatus = false
                    isReloading = false
                }
                getBannerFailed = true
                print("Error: \(String(describing: error))")
            }
            do{
                let movies = try await fetchDiscover()
                await MainActor.run {
                    isFetchingFeedStatus = false
                    self.movies = movies
                    isReloading = false
                }
            }catch{
                await MainActor.run {
                    isFetchingFeedStatus = false
                    isReloading = false
                }
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    private func fetchBanner(){
        isFetchingBannerStatus = true
        Task{
            do{
                let nowPlayingMovies = try await service.fetchNowPlaying()
                await MainActor.run {
                    isFetchingBannerStatus = false
                    self.nowPlayingMovies = nowPlayingMovies
                }
            }catch{
                await MainActor.run {
                    isFetchingBannerStatus = false
                }
                getBannerFailed = true
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    private func fetchFeed(){
        isFetchingFeedStatus = true
        Task{
            do{
                let movies = try await fetchDiscover()
                await MainActor.run {
                    isFetchingFeedStatus = false
                    self.movies = movies
                }
            }catch{
                await MainActor.run {
                    isFetchingFeedStatus = false
                }
                initialFeedFetchFailed = true
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func observeNetworkStatus(){
        NotificationCenter.default.addObserver(self, selector: #selector(backOnline), name: .backOnline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backOnline), name: .userAskToReload, object: nil)
    }
    
    func fetchDiscover() async throws -> [Movie]{
        let movies = try await service.fetchDiscover()
        return movies
    }
    
    func userDidScrollToBottom(){
        fetchMore()
    }
    
    private func fetchMore(){
        isFetchingFeedStatus = true
        Task{
            do{
                let movies = try await service.fetchMoreDiscover()
                await MainActor.run {
                    isFetchingFeedStatus = false
                    self.movies.append(contentsOf: movies)
                }
            }catch{
                await MainActor.run {
                    isFetchingFeedStatus = false
                }
                fetchMoreFeedFailed = true
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func userDidTapOnCard(movie: Movie){
        selectedMovie = movie
        pushDetail = true
    }
    
    func retry(){
        if fetchMoreFeedFailed{
            fetchMoreFeedFailed = false
            fetchMore()
        }
        if getBannerFailed{
            getBannerFailed = false
            fetchBanner()
        }
        if initialFeedFetchFailed{
            initialFeedFetchFailed = false
            fetchFeed()
        }
    }
    
    @objc func backOnline(){
        if fetchMoreFeedFailed{
            fetchMoreFeedFailed = false
            fetchMore()
        }
        if getBannerFailed{
            getBannerFailed = false
            fetchBanner()
        }
        if initialFeedFetchFailed{
            initialFeedFetchFailed = false
            fetchFeed()
        }
    }
}
