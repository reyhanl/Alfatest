//
//  BannerView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

struct BannerView: View {
    @Binding var movies: [Movie]
    @State var currentActiveBanner: Int = 0
    @State var offsetX: CGFloat = 0
    @State var bannerSize: CGSize = .zero
    @State var isRemoveAnimationActive: Bool = false
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                Color.clear.onAppear {
                    bannerSize = geometry.size
                }
            }
            ForEach(movies, id: \.id) { movie in
                let count = movies.count - 1
                let posterPath = APIEndpoint.imagePath(imagePath: movie.posterPath ?? "", size: 200)
                Group{
                    AsyncImage(url: URL(string: posterPath)){ result in
                                result.image?
                                    .resizable()
                                    .scaledToFill()
                            }
                    .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .offset(x: offsetX(id: movie.id), y: offsetY(id: movie.id))
                .rotationEffect(.degrees(Double(rotation(id: movie.id))), anchor: anchor(id: movie.id))
                .opacity(Double(opacity(id: movie.id)))
            }
            VStack{
                Spacer()
                HStack{
                    ForEach(0..<movies.count, id: \.self){ index in
                        if index == currentActiveBanner % movies.count{
                            Color.black.frame(width: 10, height: 10).shadow(radius: 2).clipShape(Circle())
                        }else{
                            Color.white.frame(width: 10, height: 10).shadow(radius: 2).clipShape(Circle())
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 10).padding(.bottom, 10)
            }.background(
                VStack{
                    Spacer()
                    LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .bottom, endPoint: .top).frame(height: bannerSize.height * 0.2)
                }
            )
        }.padding(.horizontal, 10)
        
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation {
                        offsetX = gesture.translation.width
                    }
                }
                        
                .onEnded { _ in
                    if abs(offsetX) > bannerSize.width / 2 {
                        isRemoveAnimationActive = true
                        offsetX = 0
                        withAnimation {
                            let last = movies.removeLast()
                            isRemoveAnimationActive = false
                            movies.insert(last, at: 0)
                            currentActiveBanner += 1
                        }
                    } else {
                        withAnimation {
                            offsetX = 0
                        }
                    }
                }
        )
    }
    
    func index(id: Int) -> Int?{
        return movies.firstIndex(where: {$0.id == id})
    }
    
    func offsetX(id: Int) -> CGFloat{
        guard let index = index(id: id) else{return 0}
        let count = movies.count - 1
        let normalIndex = count - index
        if normalIndex == 0{
            if isRemoveAnimationActive{
                return 0
            }
            return offsetX * 2
        }else if normalIndex == 1{
            return 0
//            let percentage = abs(offsetX) / (bannerSize.width / 2)
//            if percentage < 0.5{
//                return -offsetX / 2
//            }else if percentage < 1{
//                return offsetX / 2 + (-offsetX / 2)
//            }else{
//                return 0
//            }
        }
        return 0
    }
    
    func anchor(id: Int) -> UnitPoint{
        guard let index = index(id: id) else{return .center}
        let count = movies.count - 1
        let normalIndex = count - index
        if normalIndex == 0{
            return .center
        }else if normalIndex == 1{
//            return .bottomTrailing
        }
        return .center
    }
    
    func offsetY(id: Int) -> CGFloat{
        guard let index = index(id: id) else{return 0}
        let count = movies.count - 1
        let normalIndex = count - index
        if normalIndex == 0{
            return 0
        }else if normalIndex == 1{
//            let percentage = abs(offsetX) / (bannerSize.width / 2)
//            if percentage < 0.5{
//                return -bannerSize.height * abs(offsetX) / (bannerSize.width / 2)
//            }else if percentage < 1{
//                return (-bannerSize.height * (1 - (abs(offsetX) / (bannerSize.width / 2))))
//            }else{
//                return 0
//            }
        }
        return 0
    }
    
    func rotation(id: Int) -> CGFloat{
        guard let index = index(id: id) else{return 0}
        let count = movies.count - 1
        let normalIndex = count - index
        if normalIndex == 0{
            if isRemoveAnimationActive{
                return 0
            }
            return (-90 * -offsetX / (bannerSize.width)) / 2
        }else if normalIndex == 1{
//            let percentage = abs(offsetX) / (bannerSize.width / 2)
//            if percentage < 0.5{
//                return 90 * abs(offsetX) / (bannerSize.width / 2)
//            }else if percentage < 1{
//                return 90 * (1 - abs(offsetX) / (bannerSize.width / 2))
//            }else{
//                return 0
//            }
        }
        return 0
    }
    
    func opacity(id: Int) -> CGFloat{
        guard let index = index(id: id) else{return 0}
        let count = movies.count - 1
        let normalIndex = count - index
        if normalIndex == 0{
            if isRemoveAnimationActive{
                return 1
            }
            return 1
        }else if normalIndex == 1{
            
        }
        return 1
    }
}
