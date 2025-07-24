//
//  ContentView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @State var screenSize: CGSize = .zero
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    GeometryReader{ geometry in
                        Color.white.onAppear {
                            screenSize = geometry.size
                        }
                    }
                }
                VStack {
                    ScrollView{
                        if vm.nowPlayingMovies.count > 0{
                            BannerView(movies: $vm.nowPlayingMovies)
                        }
                        let numberOfItem = 3
                        let spacing: CGFloat = 0
                        LazyVGrid(columns:
                                    (0..<numberOfItem).map({_ in GridItem(.flexible())})
                                  , spacing: spacing) {
                            ForEach(0..<vm.movies.count, id: \.self){ index in
                                let movie = vm.movies[index]
                                let posterPath = APIEndpoint.imagePath(imagePath: movie.posterPath ?? "", size: 200)
                                
                                let cardWidth = screenSize.width / CGFloat(numberOfItem) - (spacing * CGFloat(numberOfItem - 1))
                                CardView(title: movie.title, thumbnail: posterPath)
                                    .frame(height: cardWidth * 1.5)
                                    .onAppear {
                                        if index == vm.movies.count - 1 {
                                            vm.userDidScrollToBottom()
                                        }
                                    }
                            }
                        }.padding(.horizontal, 10)
                    }
                }
                .onAppear {
                    vm.viewDidLoad()
                }
            }
        }
    }
}

#Preview {
    HomeView(vm: HomeViewModel(service: HomeUseCase(repository: HomeRepository(executor: NetworkExecutor()))))
}
