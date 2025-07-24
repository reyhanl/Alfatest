//
//  CardView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

struct CardView: View {
    var title: String
    var thumbnail: String
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                AsyncImage(url: URL(string: thumbnail)){ result in
                            result.image?
                                .resizable()
                                .scaledToFill()
                        }
                .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            Text(title).lineLimit(1)
        }
    }
}
