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
    @State var safeAreaTop: CGFloat = 0
    @StateObject var vm: MovieDetailViewModel
    var padding: CGFloat = 20
    
    @State var nonAnimatedOffsetY: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var originY: CGFloat = 0
    @State var reloadYPoint: CGFloat = 80
    
    @State var rotation: Double = 0
    
    var body: some View {
        ZStack{
            VStack{
                Color.clear.overlay {
                    GeometryReader{ geometry in
                        Color(uiColor: .systemBackground).onAppear {
                            screenSize = geometry.size
                            safeAreaBottom = geometry.safeAreaInsets.bottom
                            safeAreaTop = geometry.safeAreaInsets.top
                            print("safe area: \(safeAreaTop)")
                        }
                    }
                }
            }
            VStack(spacing: 0){
                ScrollView(showsIndicators: false){
                    VStack(spacing: 0){
                        Color.clear.frame(height: 0).overlay {
                            GeometryReader{ geometry in
                                if #available(iOS 17.0, *) {
                                    Color.clear.onChange(of: geometry.frame(in: .global)) { oldValue, newValue in
                                        offsetChange(y: newValue.origin.y)
                                    }.onAppear {
                                        originY = 0
                                    }
                                } else {
                                    Color.clear.onChange(of: geometry.frame(in: .global)) { newValue in
                                        offsetChange(y: newValue.origin.y)
                                    }.onAppear {
                                        originY = 0
                                    }
                                }
                            }
                        }
                        let width = screenSize.width * 0.8
                        VStack(spacing: padding){
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 0){
                                    if let images = vm.images{
                                        ForEach(images){ image in
                                            CardView(thumbnail: APIEndpoint.image(path: image.filePath, size: 400).url, cornerRadius: 0)
                                                .frame(width: screenSize.width * 0.8, height: width + extraHeight())
                                        }
                                    }
                                }
                            }
                            .frame(height: width + extraHeight())
                            .background(.gray)
                            .if(vm.isFetchingImages) { view in
                                view.shimmer()
                            }
                            HStack{
                                Text(vm.detail?.title ?? "").font(.system(size: 24).bold())
                                Spacer()
                            }.padding(.horizontal, padding)
                            section(title: "Reviews") {
                                ScrollView(.horizontal, showsIndicators: false){
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
                            }.if(vm.isFetchingReview){ view in
                                view.shimmer()
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
                                            Image(systemName: "play.fill").resizable().foregroundStyle(.primary).frame(width: 50, height: 50)
                                                .shadow(color: .black.opacity(0.8), radius: 4)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            vm.userClickOnTrailer(video: video)
                                        }
                                    }.padding(.horizontal, padding)
                                    
                                }
                            }
                        }.padding(.bottom, safeAreaBottom + 20).offset(y: calculatedOffsetY())
                    }
                }
            }.ignoresSafeArea()
            VStack{
                Image(AssetImage.reloadImage.rawValue).resizable().frame(width: 50, height: 50).scaleEffect(scaleReloadImage())
                    .rotationEffect(.degrees(rotation), anchor: .center)
                    .padding(.top, safeAreaTop + extraHeight())
                    .opacity(shouldShowReloadButton() ? 1:0)
                    .onAppear() {
                        if vm.isReloading {
                            startRotationAnimation()
                        }
                    }
                    .onChange(of: vm.isReloading) { isReloading in
                        if isReloading {
                            startRotationAnimation()
                        } else {
                            stopRotationAnimation()
                        }
                    }
                Spacer()
            }.ignoresSafeArea()
            
        }.onAppear {
            vm.viewDidLoad()
        }
        .fullScreenCover(isPresented: $vm.shouldPlayVideo) {
            if let video = vm.playVideo{
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
        .navigationBarBackButtonHidden(true) // Add this
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left").resizable().renderingMode(.template).aspectRatio(contentMode: .fit).frame(width: 20, height: 20).tint(Color(uiColor: .systemBackground)).foregroundStyle(Color(uiColor: .systemBackground))
                    .shadow(color: Color.primary, radius: 4)
                    .contentShape(Rectangle()).onTapGesture {
                    dismiss()
                }
            }
        })
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
    
    
    private func startRotationAnimation() {
        guard vm.isReloading else { return }
        
        withAnimation(.linear(duration: 1.0)) {
            rotation += 360
        }
        
        // Add delay and repeat
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // 1.0s animation + 0.2s delay
            if vm.isReloading {
                startRotationAnimation() // Recursive call for continuous rotation
            }
        }
    }
    
    private func stopRotationAnimation() {
        // Optionally reset rotation to 0
        withAnimation(.easeOut(duration: 0.3)) {
            rotation = 0
        }
    }
    
    func offsetChange(y: CGFloat){
        print("offsetY: \(offsetY) originY: \(originY)")
        let tempY = offsetY - originY
        if tempY > reloadYPoint{
            vm.refresh()
        }
        nonAnimatedOffsetY = y
        withAnimation{
            offsetY = y
        }
    }
    
    func shouldShowReloadButton() -> Bool{
        print("offsetY: \(offsetY) originY: \(originY)")
        let tempY = offsetY - originY
        if vm.isReloading{
            return true
        }
        if tempY > 0{
            return true
        }else{
            return false
        }
    }
    
    
    func scaleReloadImage() -> CGFloat{
        let offsetY = offsetY - originY
        //        if vm.isReloading{
        //            return 1
        //        }
        if vm.isReloading{
            return 1
        }
        return min(1, 1 * offsetY / reloadYPoint)
    }
    
    func extraHeight() -> CGFloat{
        let offsetY = offsetY - originY
        print("offsetY: \(offsetY)")
        if offsetY > 0{
            return offsetY
        }else{
            return 0
        }
    }
    
    func calculatedOffsetY() -> CGFloat{
        let offsetY = nonAnimatedOffsetY - originY
        if offsetY > 0{
            return -offsetY
        }else{
            return 0
        }
    }
    
}

#Preview {
    MovieDetailView(vm: MovieDetailViewModel(id: 1087192, service: MovieDetailViewUseCase(repository: MovieDetailViewRepository(executor: NetworkExecutor()))))
}
