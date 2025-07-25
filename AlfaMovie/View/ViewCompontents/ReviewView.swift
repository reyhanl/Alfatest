//
//  ReviewView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import SwiftUI

struct ReviewView: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading){
            Group{
                HStack{
                    CardView(thumbnail: APIEndpoint.image(path: review.authorDetails.avatarPath ?? "", size: 200).url).frame(width: 50, height: 50).clipShape(Circle())
                    Text(review.author)
                }
                Text(review.content)
            }.padding(10)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10).stroke(.gray, style: .init(lineWidth: 1)).opacity(0.4)
        })
        .shadow(color: .black.opacity(0.1), radius: 4, y: 4)
    }
}

#Preview {
    MovieDetailView(vm: MovieDetailViewModel(id: 1087192, service: MovieDetailViewUseCase(repository: MovieDetailViewRepository(executor: NetworkExecutor()))))
}
