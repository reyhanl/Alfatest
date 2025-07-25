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
    @Published var reviews: [Review]?
    @Published var isFetchingReview: Bool = false
    @Published var isFetchingImages: Bool = false
    @Published var isFetchingDetail: Bool = false
    @Published var isFetchingVideos: Bool = false
    
    init(id: Int, service: MovieDetailViewUseCaseProtocol) {
        self.id = id
        self.service = service
    }
    
    func viewDidLoad(){
        fetchData()
    }
    
    func fetchData(){
        isFetchingDetail = true
        Task{
            let detail = try await fetchDetail()
            await MainActor.run {
                self.detail = detail
            }
        }
        isFetchingReview = true
        Task{
            let reviews = try await fetchReviews()
            await MainActor.run {
                self.reviews = reviews
            }
        }
        isFetchingImages = true
        Task{
            let images = try await fetchImages()
            await MainActor.run {
                self.images = images
            }
            print("images: \(images)")
        }
        isFetchingVideos = true
        Task{
            let videos = try await fetchVideos()
            await MainActor.run {
                self.videos = videos
            }
            print("videos: \(videos)")
        }
    }
    
    func userClickOnTrailer(video: VideoItem){
        playVideo = video
    }
    
    func fetchDetail() async throws -> MovieDetail{
        return try await service.fetchDetail(id: id)
    }
    
    func fetchReviews() async throws -> [Review]{
        return try await service.fetchReview(id: id, page: 1)
    }
    
    func fetchImages() async throws -> [MediaImage]{
        return try await service.fetchImages(id: id)
    }
    
    func fetchVideos() async throws -> [VideoItem]{
        return try await service.fetchVideos(id: id)
    }
}
