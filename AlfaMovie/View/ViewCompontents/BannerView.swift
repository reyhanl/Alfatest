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
    @State var textIsHidden: Bool = true
    
    var actions: Actions
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                ForEach(movies, id: \.id) { movie in
                    let posterPath =  APIEndpoint.image(path: movie.posterPath ?? "", size: 200).url
                    ZStack{
                        Group{
                            ZStack{
                                Color.gray
                                AsyncImage(url: URL(string: posterPath)){ result in
                                    result.image?
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .frame(height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        LinearGradient(colors: [
                            Color(uiColor: .systemBackground),
                            .clear
                        ], startPoint: .bottomLeading, endPoint: .topTrailing)
                        VStack{
                            Spacer()
                            HStack{
                                Text(movie.title).font(.title2.bold()).foregroundColor(.primary)
                                Spacer()
                            }.padding(.bottom, 30).padding(.horizontal, 10)
                        }
                    }
                    .offset(x: offsetX(id: movie.uuid.uuidString), y: offsetY(id: movie.uuid.uuidString))
                    .rotationEffect(.degrees(Double(rotation(id: movie.uuid.uuidString))), anchor: anchor(id: movie.uuid.uuidString))
                    .opacity(Double(opacity(id: movie.uuid.uuidString)))
                    .frame(height: geometry.size.height)
                    .onTapGesture {
                        actions.userClickOnBanner(movie)
                    }
                }
                if movies.count > 0{
                    VStack{
                        Spacer()
                        
                        HStack{
                            let dotSize: CGFloat = 10
                            let maxNumberOfDot = (geometry.size.width / dotSize) * 3 / 4
                            ForEach(0..<min(movies.count, Int(maxNumberOfDot)), id: \.self){ index in
                                if index == currentActiveBanner % movies.count{
                                    Color(uiColor: .secondaryLabel).frame(height: 10).shadow(radius: 2).clipShape(Capsule())
                                }else{
                                    Color(uiColor: .white).frame(height: 10).shadow(radius: 2).clipShape(Capsule())
                                }
                            }
                        }
                        .frame(height: 20)
                        .padding(.horizontal, 10).padding(.bottom, 10)
                    }.background(
                        VStack{
                            Spacer()
                            LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .bottom, endPoint: .top).frame(height: bannerSize.height * 0.2)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        withAnimation {
                            offsetX = gesture.translation.width
                        }
                    }
                
                    .onEnded { _ in
                        if abs(offsetX) > bannerSize.width / 2 {
                            // First, animate the card off screen
                            withAnimation(.easeInOut(duration: 0.2)) {
                                offsetX = offsetX > 0 ? bannerSize.width * 1.5 : -bannerSize.width * 1.5
                            }
                            
                            // After animation, update the array
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isRemoveAnimationActive = true
                                
                                // Reset position and rearrange array
                                offsetX = 0
                                let last = movies.removeLast()
                                movies.insert(last, at: 0)
                                currentActiveBanner += 1
                                
                                isRemoveAnimationActive = false
                            }
                        } else {
                            withAnimation(.easeOut(duration: 0.15)) {
                                offsetX = 0
                            }
                        }
                    }
            )
            .onAppear {
                bannerSize = geometry.size
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
                    // Do something
                    await MainActor.run {
                        textIsHidden = false
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        
    }
    
    func index(id: String) -> Int?{
        return movies.firstIndex(where: {$0.uuid.uuidString == id})
    }
    
    func offsetX(id: String) -> CGFloat{
        guard let index = index(id: id) else{return 0}
        let count = movies.count - 1
        let normalIndex = count - index
        if isRemoveAnimationActive{
            return 0
        }
        if normalIndex == 0{
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
    
    func anchor(id: String) -> UnitPoint{
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
    
    func offsetY(id: String) -> CGFloat{
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
    
    func rotation(id: String) -> CGFloat{
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
    
    func opacity(id: String) -> CGFloat{
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
    
    struct Actions{
        var userClickOnBanner: (Movie) -> Void
    }
}
