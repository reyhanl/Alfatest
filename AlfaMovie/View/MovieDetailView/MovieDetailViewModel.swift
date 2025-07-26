//
//  MovieDetailViewModel.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

class MovieDetailViewModel: ObservableObject{
    var id: Int
    var service: MovieDetailViewUseCaseProtocol
    @Published var detail: MovieDetail?
    @Published var images: [MediaImage]?
    @Published var videos: [VideoItem]?
    @Published var playVideo: VideoItem?
    @Published var shouldPlayVideo: Bool = true
    @Published var reviews: [Review]?
    
    @Published var isReloading: Bool = false
    @Published var isFetchingReview: Bool = false
    @Published var isFetchingImages: Bool = false
    @Published var isFetchingDetail: Bool = false
    @Published var isFetchingVideos: Bool = false
    
    @Published var isReloadingFailed: Bool = false
    @Published var isFetchingReviewFailed: Bool = false
    @Published var isFetchingImagesFailed: Bool = false
    @Published var isFetchingDetailFailed: Bool = false
    @Published var isFetchingVideosFailed: Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    init(id: Int, service: MovieDetailViewUseCaseProtocol) {
        self.id = id
        self.service = service
        observe()
    }
    
    func viewDidLoad(){
        fetchData()
    }
    
    func refresh(){
        fetchData()
    }
    
    func observe(){
        notificationCenter.addObserver(self, selector: #selector(backOnline), name: .backOnline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backOnline), name: .userAskToReload, object: nil)
    }
    
    func fetchData(){
        isFetchingDetail = true
        Task{
            let detail = try await fetchDetail()
            await MainActor.run {
                self.detail = detail
                isFetchingDetail = false
            }
        }
        isFetchingReview = true
        Task{
            let reviews = try await fetchReviews()
            await MainActor.run {
                self.reviews = reviews
                isFetchingReview = false
            }
        }
        isFetchingImages = true
        Task{
            let images = try await fetchImages()
            await MainActor.run {
                self.images = images
                isFetchingImages = false
            }
            print("images: \(images)")
        }
        isFetchingVideos = true
        Task{
            let videos = try await fetchVideos()
            await MainActor.run {
                self.videos = videos
                isFetchingVideos = true
            }
            print("videos: \(videos)")
        }
    }
    
    func userClickOnTrailer(video: VideoItem){
        playVideo = video
        shouldPlayVideo = true
    }
    
    func fetchDetail() async throws -> MovieDetail{
        do{
            let detail = try await service.fetchDetail(id: id)
            return detail
        }catch{
            print("Error: \(String(describing: error))")
            await MainActor.run {
                isFetchingDetailFailed = true
            }
            throw error
        }
    }
    
    func fetchReviews() async throws -> [Review]{
        do{
            let reviews = try await service.fetchReview(id: id, page: 1)
            return reviews
        }catch{
            print("Error: \(String(describing: error))")
            await MainActor.run {
                isFetchingReviewFailed = true
            }
            throw error
        }
    }
    
    func fetchImages() async throws -> [MediaImage]{
        do{
            let images = try await service.fetchImages(id: id)
            return images
        }catch{
            print("Error: \(String(describing: error))")
            await MainActor.run {
                isFetchingImagesFailed = true
            }
            throw error
        }
    }
    
    func fetchVideos() async throws -> [VideoItem]{
        do{
            let videos =  try await service.fetchVideos(id: id)
            return videos
        }catch{
            print("Error: \(String(describing: error))")
            await MainActor.run {
                isFetchingVideosFailed = true
            }
            throw error
        }
    }
    
    @objc func backOnline(){
        refresh()
    }

}
