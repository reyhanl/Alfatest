//
//  CardView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI

struct CardView: View {
    var thumbnail: String
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                AsyncImage(url: URL(string: thumbnail)){ phase in
                    switch phase {
                    case .empty:
                        // Loading state
                        Color.gray.shimmer()
                        
                    case .success(let image):
                        // Success state
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    case .failure(_):
                        // Error state
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Failed to load")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 100, height: 100)
                        
                    @unknown default:
                        EmptyView()
                    }}
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
            }
        }
    }
}
