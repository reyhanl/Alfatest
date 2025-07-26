//
//  NoInternetView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import SwiftUI

struct NoInternetView: View{
    
    @Binding var isPresented: Bool
    var actions: Actions
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack{
                Spacer()
                VStack(){
                    Group{
                        Image(AssetImage.noInternetImage.rawValue).resizable().aspectRatio(contentMode: .fit)
                        HStack(spacing: 10){
                            HStack{
                                Button {
                                    withAnimation {
                                        isPresented = false
                                    }
                                    actions.cancel()
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Cancel").bold().foregroundStyle(Color(uiColor: .systemBackground))
                                        Spacer()
                                    }
                                    .frame(height: 60)
                                    .background(Color(hex: "CB3838"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                            
                            HStack{
                                Button {
                                    withAnimation {
                                        isPresented = false
                                    }
                                    actions.clickReloadButton()
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Oke").bold().foregroundStyle(Color(uiColor: .systemBackground))
                                        Spacer()
                                    }
                                    .frame(height: 60)
                                    .background(Color(hex: "38CB7D"))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                        
                    }.padding(.horizontal, 20).padding(.vertical, 20)
                }.background(Color(uiColor: .systemBackground)).clipShape(RoundedRectangle(cornerRadius: 20)).padding(10)
            }
        }
    }
    
    struct Actions{
        var clickReloadButton: () -> Void
        var cancel: () -> Void
    }
}

#Preview {
    @State var isPresented: Bool = false
    NoInternetView(isPresented: $isPresented, actions: .init(clickReloadButton: {
        
    }, cancel: {
        
    }))
}
