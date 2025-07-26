//
//  SplashView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/26.
//

import SwiftUICore

struct SplashView: View{
    var body: some View{
        ZStack{
            Image(AssetImage.splashImage.rawValue).resizable().scaledToFill()
            VStack{
                Spacer()
                Text("Getting the system ready...").font(.system(size: 16).bold()).foregroundStyle(.white).shimmer().lineLimit(1)
                    .padding(.bottom, 30)
            }
        }
    }
}
