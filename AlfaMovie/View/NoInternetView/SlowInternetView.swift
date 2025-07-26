//
//  SlowInternetView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/26.
//

import SwiftUI

struct SlowInternetView: View{
    
    @Binding var isPresented: Bool
    var actions: Actions
    
    var body: some View{
        HStack(){
            Group{
                Text("Your internet seems to be slow, reload?").font(.system(size: 14).bold())
                Image(systemName: "arrow.trianglehead.2.clockwise").resizable().renderingMode(.template).aspectRatio(contentMode: .fit).frame(width: 14, height: 14).foregroundStyle(Color(uiColor: .systemBackground)).tint(Color(uiColor: .systemBackground))
            }.padding(.horizontal, 10).padding(.vertical, 10)
        }
        .background(Color(hex: "CBAE38"))
        .clipShape(Capsule())
        .contentShape(Rectangle())
        .onTapGesture {
            actions.reload()
        }
    }
    
    struct Actions{
        var reload: () -> Void
        var cancel: () -> Void
    }
}

#Preview {
    @State var isPresented: Bool = false
    NoInternetView(isPresented: $isPresented, actions: .init(clickReloadButton: {
        
    }, cancel: {
        
    }))
}
