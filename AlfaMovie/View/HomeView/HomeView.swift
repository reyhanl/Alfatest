//
//  ContentView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @State var screenSize: CGSize = .zero
    @State var topSafeArea: CGFloat = 0
    
    @State var nonAnimatedOffsetY: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var originY: CGFloat = 0
    @State var rotation: Double = 360
    
    @State var reloadYPoint: CGFloat = 80
    
    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 2) //.easeIn, .easyOut, .linear, etc...
            .repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack{
            VStack{
                Color.clear.overlay {
                    GeometryReader{ geometry in
                        Color(uiColor: .systemBackground).onAppear {
                            screenSize = geometry.size
                            topSafeArea = geometry.safeAreaInsets.top
                        }
                    }
                }
            }
            VStack{
                ScrollView(showsIndicators: false){
                    Color.clear.frame(height: 0).overlay {
                        GeometryReader{ geometry in
                            if #available(iOS 17.0, *) {
                                Color.clear.onChange(of: geometry.frame(in: .global)) { oldValue, newValue in
                                    offsetChange(y: newValue.origin.y)
                                }.onAppear {
                                    originY = geometry.frame(in: .global).origin.y
                                }
                            } else {
                                Color.clear.onChange(of: geometry.frame(in: .global)) { newValue in
                                    offsetChange(y: newValue.origin.y)
                                }.onAppear {
                                    originY = geometry.frame(in: .global).origin.y
                                }
                            }
                        }
                    }
                    BannerView(movies: $vm.nowPlayingMovies, actions: .init(userClickOnBanner: { movie in
                        vm.userDidTapOnCard(movie: movie)
                    }))
                    .frame(
                        height: 200 + extraHeight()
                    )
                    .background {
                        if vm.isFetchingBannerStatus{
                            Color.gray
                                .padding(.horizontal, 10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shimmer()
                        }else{
                            Color.gray
                                .padding(.horizontal, 10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .offset(y: calculatedOffsetY())
                    let numberOfItem = 3
                    let spacing: CGFloat = 0
                    let columns = (0..<numberOfItem).map({_ in GridItem(.flexible())})
                    LazyVGrid(columns: columns, spacing: spacing) {
                        let cardWidth = screenSize.width / CGFloat(numberOfItem) - (spacing * CGFloat(numberOfItem - 1))
                        ForEach(0..<vm.movies.count, id: \.self){ index in
                            let movie = vm.movies[index]
                            let posterPath = APIEndpoint.image(path: movie.posterPath ?? "", size: 200).url
                            
                            NavigationLink(destination: makeDetailView(), isActive: $vm.pushDetail) {
                                VStack{
                                    CardView(thumbnail: posterPath)
                                        .frame(height: cardWidth * 1.5)
                                        .onAppear {
                                            if index == vm.movies.count - 1 {
                                                vm.userDidScrollToBottom()
                                            }
                                        }
                                        .onTapGesture {
                                            vm.userDidTapOnCard(movie: movie)
                                        }
                                    Text(movie.title).lineLimit(1)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    .offset(y: calculatedOffsetY())
                    
                    if vm.isFetchingFeedStatus{
                        HStack{
                            Spacer()
                            Text("Loading").shimmer()
                            Spacer()
                        }
                    }else if vm.fetchMoreFeedFailed{
                        HStack{
                            Spacer()
                            Group{
                                Text("Reload").font(.system(size: 14).bold()).foregroundStyle(Color(uiColor: .systemBackground))
                                Image(systemName: "arrow.trianglehead.2.clockwise").resizable().renderingMode(.template).aspectRatio(contentMode: .fit).tint(Color(uiColor: .systemBackground)).foregroundStyle(Color(uiColor: .systemBackground)).frame(width: 14, height: 14).foregroundStyle(Color(uiColor: .systemBackground)).tint(Color(uiColor: .systemBackground))
                            }.contentShape(Rectangle()).onTapGesture(perform: {
                                vm.retry()
                            })
                            Spacer()
                        }
                    }
                }
            }
            .onAppear {
                vm.viewDidLoad()
            }
            VStack{
                Image(AssetImage.reloadImage.rawValue).resizable().frame(width: 50, height: 50).scaleEffect(scaleReloadImage())
                    .rotationEffect(.degrees(rotation), anchor: .center)
                    .padding(.top, topSafeArea)
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
        }
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
        let tempY = offsetY - originY
        if tempY >= reloadYPoint{
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
        if tempY > 3{
            return true
        }else{
            return false
        }
    }
    
    func scaleReloadImage() -> CGFloat{
        let offsetY = offsetY - originY
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
    
    @ViewBuilder func makeDetailView() -> some View {
        if let movie = vm.selectedMovie{
            MovieDetailView(vm: MovieDetailViewModel(id: movie.id, service: MovieDetailViewUseCase(repository: MovieDetailViewRepository(executor: NetworkExecutor()))))
        }
    }
}

#Preview {
    HomeView(vm: HomeViewModel(service: HomeUseCase(repository: HomeRepository(executor: NetworkExecutor()))))
}
