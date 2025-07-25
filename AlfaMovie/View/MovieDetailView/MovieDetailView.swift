//
//  MovieDetailView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var screenSize: CGSize = .zero
    @State var safeAreaBottom: CGFloat = 0
    @ObservedObject var vm: MovieDetailViewModel
    var padding: CGFloat = 20
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    GeometryReader{ geometry in
                        Color.white.onAppear {
                            screenSize = geometry.size
                            safeAreaBottom = geometry.safeAreaInsets.bottom
                        }
                    }
                }
                ScrollView {
                    VStack(spacing: padding){
                        ScrollView(.horizontal){
                            LazyHStack(spacing: 0){
                                if let images = vm.images{
                                    ForEach(images){ image in
                                        let width = screenSize.width * 0.8
                                        CardView(thumbnail: APIEndpoint.image(path: image.filePath, size: 400).url, cornerRadius: 0)
                                            .frame(width: screenSize.width * 0.8, height: width / 1)
                                    }
                                }
                            }
                        }
                        section(title: "Reviews") {
                            ScrollView(.horizontal){
                                LazyHStack(spacing: 0){
                                    if let reviews = vm.reviews{
                                        ForEach(0..<reviews.count, id: \.self){ index in
                                            let review = reviews[index]
                                            ReviewView(review: review).frame(width: 250, height: 150)
                                                .padding(.leading, index == 0 ? 20:0)
                                        }
                                    }
                                }
                            }
                        }
                        section(title: "About Movie") {
                            VStack{
                                Text(vm.detail?.overview ?? "")
                            }.padding(.horizontal, padding)
                        }
                        section(title: "Trailer") {
                            if let video = vm.videos?.first(where: {$0.type == .trailer}){
                                
                                VStack{
                                    ZStack{
                                        CardView(thumbnail: APIEndpoint.youtubeThumbnail(id: video.key).url, cornerRadius: 10)
                                            .frame(height: 200)
                                        Image(systemName: "play.fill").resizable().foregroundStyle(.white).frame(width: 50, height: 50)
                                            .shadow(color: .black.opacity(0.8), radius: 4)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        vm.userClickOnTrailer(video: video)
                                    }
                                }.padding(.horizontal, padding)

                            }
                        }
                    }.padding(.bottom, safeAreaBottom)
                }.ignoresSafeArea()
            }.onAppear {
                vm.viewDidLoad()
            }
//            .toolbar(content: {
//                ToolbarItem(placement: .principal) {
//                    HStack{
//                        Image(systemName: "chevron.left").resizable().renderingMode(.template).frame(width: 20, height: 20).tint(.white).padding(.horizontal, padding).onTapGesture {
//                            dismiss()
//                        }
//                        Spacer()
//                    }
//                }
//            })
            .fullScreenCover(item: $vm.playVideo) { video in
                let videoURL = APIEndpoint.youtubeVideo(id: video.key)
                VideoPlayerRepresentable(videoURL: videoURL.url)
                    .ignoresSafeArea()
                    .onAppear {
                        print("youtubeURL: \(videoURL.url)")
                        modifyOrientation(.landscape)
                    }
                    .onDisappear {
                        modifyOrientation(.portrait)
                    }
            }
        }
    }
    
    @ViewBuilder
    func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
                .padding(.horizontal, padding)
            
            content()
        }
        .cornerRadius(12)
    }
}

#Preview {
    MovieDetailView(vm: MovieDetailViewModel(id: 1087192, service: MovieDetailViewUseCase(repository: MovieDetailViewRepository(executor: NetworkExecutor()))))
}
