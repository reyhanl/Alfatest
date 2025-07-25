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
                                let posterPath = APIEndpoint.image(path: movie.posterPath ?? "", size: 200).url
                                
                                let cardWidth = screenSize.width / CGFloat(numberOfItem) - (spacing * CGFloat(numberOfItem - 1))
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
                                            Text(movie.title).lineLimit(1).foregroundStyle(.black)
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
    
    @ViewBuilder func makeDetailView() -> some View {
        if let movie = vm.selectedMovie{
            MovieDetailView(vm: MovieDetailViewModel(id: movie.id, service: MovieDetailViewUseCase(repository: MovieDetailViewRepository(executor: NetworkExecutor()))))
        }
    }
}

#Preview {
    HomeView(vm: HomeViewModel(service: HomeUseCase(repository: HomeRepository(executor: NetworkExecutor()))))
}
